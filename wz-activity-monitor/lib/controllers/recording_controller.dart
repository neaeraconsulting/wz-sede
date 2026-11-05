import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:wzam/controllers/notification_controller.dart';
import 'package:wzam/controllers/settings_controller.dart';
import 'package:wzam/controllers/view_recordings_controller.dart';
import 'package:wzam/models/position_extensions.dart';
import 'package:wzam/models/recording.dart';
import 'package:wzam/models/stt_commands.dart';
import 'package:wzam/models/wzdx_extensions.dart';
import 'package:wzam/models/wzdx_models.dart';
import 'package:wzam/services/auth_service.dart';
import 'package:wzam/services/file_storage.dart';
import 'package:wzam/services/location_health_monitor_service.dart';
import 'package:wzam/services/location_service.dart';
import 'package:wzam/services/push_notification_service.dart';
import 'package:wzam/services/voice_commands/voice_command_service.dart';
import 'package:wzam/services/wzam_api.dart';
import 'package:wzam/ui/pages/home.dart';

import '../ui/styles/app_colors.dart';

class RecordingController extends GetxController with WidgetsBindingObserver {
  MapController mapController = MapController();
  LocationService locationService = Get.find<LocationService>();
  FileStorageService fileStorageService = Get.find<FileStorageService>();
  VoiceCommandService voiceCommandService = Get.find<VoiceCommandService>();
  Rx<MarkerLayer> markerLayer = const MarkerLayer(markers: <Marker>[]).obs;
  RxList<Marker> recordingMarkers = <Marker>[].obs;
  Rx<PolylineLayer> polylineLayer =
      const PolylineLayer(polylines: <Polyline>[]).obs;
  RxBool inWorkZone = false.obs;
  RxBool workersPresent = false.obs;
  Rx<List<Lane>> lanes = Rx<List<Lane>>([]);
  bool recordingLocation = true;
  List<RecordingPoint> points = [];
  RecordingMarking? firstMarking;
  List<LatLng> nonWorkZonePointsLatLng = [];
  List<LatLng> pointsLatLng = [];
  RxInt currentSpeedLimit = 0.obs;
  RxDouble mapZoom = 17.0.obs;
  bool updatingMap =
      false; // Default to false, since only using recording_no_map page
  StreamSubscription<SttCommand>? _commandSubscription;
  Logger logger = Logger();
  late Recording recordingMetadata;
  PushNotificationService pushNotificationService =
      Get.find<PushNotificationService>();
  LocationHealthMonitorService locationHealthMonitorService =
      Get.find<LocationHealthMonitorService>();
  RxBool notGettingLocationUpdates = false.obs;
  Rx<LocationHealthReason> locationHealthReason = LocationHealthReason.none.obs;
  Rx<DateTime>? lastLocationUpdate;
  StreamSubscription<Position>? _locationSubscription;
  LocationHealthSessionHandle? _healthSession;
  Worker? _healthSessionWorker;
  Timer? _availabilityRetryTimer;
  bool _sessionRequested = false;
  bool _startingLocationListener = false;

  static const String _recordingSessionId = 'drive_recording';
  static const int _recordingNotificationId = 203;
  static const Duration _locationStaleThreshold = Duration(seconds: 30);

  int get locationStaleThresholdSeconds => _locationStaleThreshold.inSeconds;

  Future<void> initialize(
      Recording recordingMetadata, int numLanes, int speedLimitMph) async {
    this.recordingMetadata = recordingMetadata;
    _initializeLanes(numLanes);
    currentSpeedLimit.value = speedLimitMph;
    _updateMarkerLayer(recordingMarkers);
    updateAllowedVoiceCommands();
    updateLatestMarking(RecordingMarking(
      speedLimitMph: currentSpeedLimit.value,
      lanes: lanes.value,
    ));
  }

  void initVoice() {
    voiceCommandService.initialize();
    createCommandSubscription(voiceCommandService);
  }

  void deinitVoice() {
    cancelCommandSubscription();
    voiceCommandService.deinit();
  }

  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addObserver(this);
    Get.find<AuthService>().blockLogout();
    initializeVoiceIfEnabled();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _locationSubscription?.cancel();
    _availabilityRetryTimer?.cancel();
    _healthSessionWorker?.dispose();
    locationHealthMonitorService.unregisterSession(_recordingSessionId);
    pushNotificationService.cancelNotification(_recordingNotificationId);
    super.onClose();
    deinitVoice();
    Get.find<AuthService>().unblockLogout();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _sessionRequested) {
      _attemptStartLocationListener();
    }
  }

  List<SttCommand> getAllowedVoiceCommands() {
    if (!inWorkZone.value) {
      return [SttCommand.startWorkZone];
    }
    List<SttCommand> allowedCommands = [SttCommand.endWorkZone];
    if (workersPresent.value) {
      allowedCommands.add(SttCommand.workersNotPresent);
    } else {
      allowedCommands.add(SttCommand.workersPresent);
    }
    if (lanes.value.isNotEmpty) {
      for (int i = 0; i < lanes.value.length; i++) {
        Lane lane = lanes.value[i];
        if (lane.status == LaneStatus.open) {
          allowedCommands.add(SttCommandExtension.getCommandsByCategory(
                  SttCommandCategory.laneClosed)
              .firstWhere((command) => command.getValue == i + 1));
        } else if (lane.status == LaneStatus.closed) {
          allowedCommands.add(SttCommandExtension.getCommandsByCategory(
                  SttCommandCategory.laneOpen)
              .firstWhere((command) => command.getValue == i + 1));
        }
      }
    }
    if (currentSpeedLimit.value > 0) {
      allowedCommands.addAll(SttCommandExtension.getCommandsByCategory(
              SttCommandCategory.speedLimit)
          .where((command) => command.getValue != currentSpeedLimit.value));
    }
    return allowedCommands;
  }

  void updateAllowedVoiceCommands() {
    List<SttCommand> allowedCommands = getAllowedVoiceCommands();
    voiceCommandService.updateAllowedCommands(allowedCommands);
  }

  void updateLatestMarking(RecordingMarking newMarking) {
    if (points.isNotEmpty) {
      RecordingPoint lastPoint = points.last;
      RecordingMarking? lastMarking = points.last.marking;
      lastMarking ??= RecordingMarking();
      RecordingMarking updatedMarking = lastMarking.copyWithMarking(newMarking);
      lastPoint = lastPoint.copyWith(marking: updatedMarking);
      points[points.length - 1] = lastPoint;
    } else {
      firstMarking =
          (firstMarking ?? RecordingMarking()).copyWithMarking(newMarking);
      logger.w("No points to update with new marking");
    }
  }

  void initializeVoiceIfEnabled() {
    bool enabled =
        voiceCommandService.settingsController.voiceCommandState.value;
    if (enabled) {
      initVoice();
    } else {
      deinitVoice();
    }
  }

  void createCommandSubscription(VoiceCommandService voiceCommandService) {
    _commandSubscription?.cancel();
    _commandSubscription =
        voiceCommandService.commandStream.listen(processVoiceCommand);
  }

  void cancelCommandSubscription() {
    _commandSubscription?.cancel();
    _commandSubscription = null;
  }

  void startListeningToLocation() {
    _sessionRequested = true;
    _initializeHealthSession();
    _attemptStartLocationListener(showUnavailableDialog: true);
  }

  Future<void> _startListeningToLocationStream() async {
    if (_locationSubscription != null) {
      return;
    }
    // TODO: Add markings to previous point instead of next point
    // this is more accurate, and will work more consistently with sparse points
    _locationSubscription =
        locationService.locationStream.listen((Position position) {
      locationHealthMonitorService.reportLocationAvailability(
        _recordingSessionId,
        permissionGranted: true,
        serviceEnabled: true,
      );
      locationHealthMonitorService.reportLocationUpdate(_recordingSessionId);
      lastLocationUpdate?.value = DateTime.now();
      if (recordingLocation) {
        RecordingPoint recordingPoint = RecordingPoint(
          timestamp: DateTime.now().toUtc().millisecondsSinceEpoch,
          numSatellites: 0, //TODO: Figure out how to get this
          accuracy: position.accuracy,
          latitude: position.latitude,
          longitude: position.longitude,
          altitude: position.altitude,
          speed: position.speed,
          heading: position.heading,
          marking: firstMarking,
        );

        if (firstMarking != null) {
          firstMarking = null;
        }
        points.add(recordingPoint);
        //pointsLatLng.add(position.getLatLng());
        _addPointToPolyline(position.latitude, position.longitude);
      }
      if (updatingMap) {
        _updateMarkerLayer(recordingMarkers);
        updateMap();
      }
    }, onError: (_) {
      locationHealthMonitorService.markOffline(
          _recordingSessionId, LocationHealthReason.staleLocationUpdates);
    }, onDone: () {
      locationHealthMonitorService.markOffline(
          _recordingSessionId, LocationHealthReason.staleLocationUpdates);
      _locationSubscription = null;
      if (_sessionRequested) {
        _ensureAvailabilityRetryTimer();
      }
    });
  }

  void updateMap() {
    if (updatingMap) {
      mapController.move(getCurrentUserLatLng(), mapZoom.value);
    }
  }

  LatLng getCurrentUserLatLng() {
    Position? position = locationService.currentPosition.value;
    if (position == null) {
      logger.e("Invalid user position in RecordingController");
      return const LatLng(0.0, 0.0);
    } else {
      return position.getLatLng();
    }
  }

  Marker _createUserMaker(Position position) {
    return Marker(
        point: position.getLatLng(),
        child: Image.asset('assets/images/location_with_border.png',
            width: 25.0, height: 25.0),
        rotate: true);
  }

  void _updateMarkerLayer(List<Marker> recordingMarkers) {
    Position? position = locationService.currentPosition.value;
    List<Marker> markers = [...recordingMarkers];
    if (updatingMap && position != null) {
      markers.add(_createUserMaker(position));
    }
    markerLayer.value = MarkerLayer(markers: markers);
  }

  void _addPointToPolyline(double lat, double long) {
    if (!inWorkZone.value) {
      nonWorkZonePointsLatLng.add(LatLng(lat, long));
    } else {
      if (pointsLatLng.isEmpty && nonWorkZonePointsLatLng.isNotEmpty) {
        pointsLatLng.add(nonWorkZonePointsLatLng.last);
      }
      pointsLatLng.add(LatLng(lat, long));
    }
    List<Polyline> polylines = [];
    if (nonWorkZonePointsLatLng.length >= 2) {
      polylines.add(Polyline(
        points: nonWorkZonePointsLatLng,
        strokeWidth: 3.0,
        color: darkGrey,
      ));
    }
    if (pointsLatLng.length >= 2) {
      polylines.add(Polyline(
        points: pointsLatLng,
        strokeWidth: 5.0,
        color: primaryColor,
      ));
    }

    polylineLayer.value = PolylineLayer(polylines: <Polyline>[...polylines]);
  }

  void _initializeLanes(int maxLanes) {
    lanes.value = List.generate(
        maxLanes,
        (idx) => Lane(
            laneOrder: idx,
            type: LaneType.general,
            status: LaneStatus.open,
            restrictions: [])).obs;
  }

  void _addMarker(Marker marker) {
    recordingMarkers.add(marker);
    _updateMarkerLayer(recordingMarkers);
  }

  void startWorkZoneRecording() {
    inWorkZone.value = true;
    updateAllowedVoiceCommands();
    updateLatestMarking(RecordingMarking(refPt: true));
  }

  void stopWorkZoneRecording({bool save = true}) {
    inWorkZone.value = false;
    updateAllowedVoiceCommands();
    recordingLocation = false;
    Get.find<AuthService>().unblockLogout();
    if (save) {
      addStopWorkZoneToRecording();
      _saveRecording();
      SettingsController settingsController = Get.find<SettingsController>();
      if (settingsController.showRecordingMap.value) {
        _showFullRecordingMap();
        Get.dialog(_createRecordingDialog());
      }
    }
    voiceCommandService.deinit();
    updatingMap = false;
    _sessionRequested = false;
    _availabilityRetryTimer?.cancel();
    _availabilityRetryTimer = null;
    _locationSubscription?.cancel();
    _locationSubscription = null;
    locationHealthMonitorService.unregisterSession(_recordingSessionId);
    _healthSessionWorker?.dispose();
    _healthSessionWorker = null;
    _healthSession = null;
    pushNotificationService.cancelNotification(_recordingNotificationId);
    Get.offAll(() => Home());
  }

  Future<void> _attemptStartLocationListener({
    bool showUnavailableDialog = false,
  }) async {
    if (!_sessionRequested ||
        _locationSubscription != null ||
        _startingLocationListener) {
      return;
    }

    final _LocationAvailability availability = await _getLocationAvailability();

    locationHealthMonitorService.reportLocationAvailability(
      _recordingSessionId,
      permissionGranted: availability.permissionGranted,
      serviceEnabled: availability.serviceEnabled,
    );

    if (!availability.isAvailable) {
      if (showUnavailableDialog) {
        _showLocationUnavailableDialog(availability);
      }
      _ensureAvailabilityRetryTimer();
      return;
    }

    _availabilityRetryTimer?.cancel();
    _availabilityRetryTimer = null;
    _startingLocationListener = true;
    try {
      await _startListeningToLocationStream();
    } finally {
      _startingLocationListener = false;
    }
  }

  void _ensureAvailabilityRetryTimer() {
    if (_availabilityRetryTimer != null || !_sessionRequested) {
      return;
    }
    _availabilityRetryTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _attemptStartLocationListener();
    });
  }

  Future<_LocationAvailability> _getLocationAvailability() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    final LocationPermission permission = await Geolocator.checkPermission();
    final bool permissionGranted = permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
    return _LocationAvailability(
      permissionGranted: permissionGranted,
      serviceEnabled: serviceEnabled,
    );
  }

  void _showLocationUnavailableDialog(_LocationAvailability availability) {
    if (Get.isDialogOpen ?? false) {
      return;
    }

    final String message = availability.serviceEnabled
        ? 'Location permission is required to start drive recording. Please enable location permission in app settings.'
        : 'Location services are disabled on this device. Please enable location services to start drive recording.';

    Get.dialog(
      AlertDialog(
        title: const Text('Drive Recording Unavailable'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  void _initializeHealthSession() {
    _healthSessionWorker?.dispose();
    _healthSession = locationHealthMonitorService.registerSession(
      const LocationHealthSessionConfig(
        sessionId: _recordingSessionId,
        staleThreshold: _locationStaleThreshold,
        notificationId: _recordingNotificationId,
        offlineTitle: 'Device is offline',
        offlineBody:
            'Drive recording is unavailable. It will resume when the device is back online.',
        recoveredTitle: 'Device is back online',
        recoveredBody: 'Drive recording has continued',
      ),
    );
    _healthSessionWorker = ever<LocationHealthSnapshot>(
      _healthSession!.snapshot,
      _syncHealthSnapshot,
    );
  }

  void _syncHealthSnapshot(LocationHealthSnapshot snapshot) {
    notGettingLocationUpdates.value = snapshot.isOffline;
    locationHealthReason.value = snapshot.reason;
    lastLocationUpdate ??= Rx<DateTime>(DateTime.now());
    if (snapshot.lastLocationUpdate != null) {
      lastLocationUpdate?.value = snapshot.lastLocationUpdate!;
    }
  }

  String get offlineStatusPrefix {
    if (!notGettingLocationUpdates.value) {
      return '';
    }
    return '${locationHealthReasonMessage(locationHealthReason.value)}\n';
  }

  String get offlineGuidance {
    if (!notGettingLocationUpdates.value) {
      return '';
    }
    return locationHealthReasonGuidance(locationHealthReason.value);
  }

  LocationHealthBannerViewModel get locationStatusBanner {
    return buildLocationHealthBannerViewModel(
      snapshot: LocationHealthSnapshot(
        isOffline: notGettingLocationUpdates.value,
        lastLocationUpdate: lastLocationUpdate?.value,
        reason: locationHealthReason.value,
      ),
      timestampLabel: 'Last Location Update',
    );
  }

  void _showFullRecordingMap() {
    List<LatLng> constraintPoints = findRecordingBounds();
    LatLngBounds bounds =
        LatLngBounds(constraintPoints.first, constraintPoints.last);
    CameraFit cameraFit =
        CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(60.0));
    _updateMarkerLayer(recordingMarkers);
    mapController.fitCamera(cameraFit);
  }

  void toggleWorkersPresent() {
    if (!workersPresent.value) {
      Marker marker = Marker(
        point: getCurrentUserLatLng(),
        child: Container(
          width: 20,
          height: 30,
          decoration: BoxDecoration(
            color: lightGrey,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Image.asset('assets/images/workers_present.png'),
        ),
        rotate: true,
      );
      _addMarker(marker);
    } else {
      Marker marker = Marker(
        point: getCurrentUserLatLng(),
        child: Container(
          width: 20,
          height: 30,
          decoration: BoxDecoration(
            color: lightGrey,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Image.asset('assets/images/workers_not_present.png'),
        ),
        rotate: true,
      );
      _addMarker(marker);
    }

    updateLatestMarking(
        RecordingMarking(workersPresent: !workersPresent.value));
    workersPresent.value = !workersPresent.value;
    updateAllowedVoiceCommands();
  }

  void addStopWorkZoneToRecording() {
    updateLatestMarking(RecordingMarking(refPt: false));
  }

  void _saveRecording() {
    Recording recording = recordingMetadata.copyWith(
        points: points, recordingEndTimestamp: DateTime.now());
    NotificationController().sendNotificationWithPromise<RecordingWithId>(
      task: () async {
        RecordingWithId? response = await postRecording(recording);
        if (response == null) {
          throw Exception("Recording upload failed");
        } else {
          return response;
        }
      },
      loadingTitle: "Uploading Recording",
      loadingMessage: "Please wait while your recording is uploaded...",
      successTitle: "Recording Uploaded",
      successMessage: "Your recording has been successfully uploaded.",
      onErrorSendPushNotification: true,
      errorTitle: "Recording Upload Failed",
      errorMessageBuilder: (error) =>
          "There was an error uploading your recording. Please try again later.",
    );
  }

  Future<RecordingWithId?> postRecording(Recording recording) async {
    RecordingWithId? recordingWithId = await WzamApi.createRecording(recording);

    if (recordingWithId == null) {
      ViewRecordingsController viewRecordingsController =
          Get.find<ViewRecordingsController>();
      await fileStorageService.refreshLocalUploadState();
      viewRecordingsController.loadInRecordings();
    }
    return recordingWithId;
  }

  void sendSuccessNotification(String title, String body) {
    pushNotificationService.showSimpleNotification(
      title: title,
      body: body,
      payload: title,
      id: 0,
    );
  }

  AlertDialog _createRecordingDialog() {
    return AlertDialog(
      title: const Text('Recording Saved'),
      content: const Text('The recording has been saved.'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Get.offAll(() => Home());
          },
          child: const Text('OK'),
        ),
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('View Recording'),
        )
      ],
    );
  }

  void toggleLaneStatus(int laneIndex) {
    List<Lane> localLanes = lanes.value;
    if (laneIndex < localLanes.length) {
      Lane lane = localLanes[laneIndex];
      LaneStatus newStatus =
          lane.status == LaneStatus.open ? LaneStatus.closed : LaneStatus.open;
      changeLaneStatus(laneIndex, newStatus);
    }
  }

  void changeLaneStatus(int laneIndex, LaneStatus status) {
    List<Lane> localLanes = [...lanes.value];
    if (laneIndex < localLanes.length) {
      Lane originalLane = localLanes[laneIndex];
      Lane lane = Lane(
        laneOrder: originalLane.laneOrder,
        type: originalLane.type,
        status: status, // Updated status
        restrictions: originalLane.restrictions,
      );
      localLanes[laneIndex] = lane;
      lanes.value = localLanes;
      updateAllowedVoiceCommands();

      updateLatestMarking(RecordingMarking(
        lanes: localLanes,
      ));

      Marker marker = Marker(
        point: getCurrentUserLatLng(),
        child: Container(
          width: 20,
          height: 30,
          decoration: BoxDecoration(
            color: lightGrey,
            shape: BoxShape.circle,
          ),
          child: lane.status.image(),
        ),
      );
      _addMarker(marker);
    }
  }

  void speedLimitChanging(int speedLimitAdjustment) {
    currentSpeedLimit.value += speedLimitAdjustment;
    updateAllowedVoiceCommands();
    updateLatestMarking(RecordingMarking(
      speedLimitMph: currentSpeedLimit.value,
    ));
    Marker marker = Marker(
      point: getCurrentUserLatLng(),
      child: Container(
        width: 20,
        height: 30,
        decoration: BoxDecoration(
          color: lightGrey,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Image.asset('assets/images/speed_change.png'),
      ),
      rotate: true,
    );
    _addMarker(marker);
  }

  void setSpeedLimit(int speedLimit) {
    updateLatestMarking(RecordingMarking(
      speedLimitMph: speedLimit,
    ));
    currentSpeedLimit.value = speedLimit;
    updateAllowedVoiceCommands();
    Marker marker = Marker(
      point: getCurrentUserLatLng(),
      child: Container(
        width: 20,
        height: 30,
        decoration: BoxDecoration(
          color: lightGrey,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Image.asset('assets/images/speed_change.png'),
      ),
      rotate: true,
    );
    _addMarker(marker);
  }

  List<LatLng> findRecordingBounds() {
    double smallLat = pointsLatLng.first
        .latitude; //TODO: This can fail is you stop the recording before anything is actually recorded
    double smallLong = pointsLatLng.first.longitude;
    double bigLat = pointsLatLng.first.latitude;
    double bigLong = pointsLatLng.first.longitude;
    for (LatLng points in pointsLatLng) {
      if (points.latitude < smallLat) {
        smallLat = points.latitude;
      }
      if (points.latitude > bigLat) {
        bigLat = points.latitude;
      }
      if (points.longitude < smallLong) {
        smallLong = points.longitude;
      }
      if (points.longitude > bigLong) {
        bigLong = points.longitude;
      }
    }
    LatLng cornerOne = LatLng(smallLat, smallLong);
    LatLng cornerTwo = LatLng(bigLat, bigLong);
    return [cornerOne, cornerTwo];
  }

  void processVoiceCommand(SttCommand command) {
    switch (command) {
      case SttCommand.laneClosed1:
      case SttCommand.laneClosed2:
      case SttCommand.laneClosed3:
      case SttCommand.laneClosed4:
      case SttCommand.laneClosed5:
      case SttCommand.laneClosed6:
        changeLaneStatus(command.getValue! - 1, LaneStatus.closed);
        break;
      case SttCommand.laneOpened1:
      case SttCommand.laneOpened2:
      case SttCommand.laneOpened3:
      case SttCommand.laneOpened4:
      case SttCommand.laneOpened5:
      case SttCommand.laneOpened6:
        changeLaneStatus(command.getValue! - 1, LaneStatus.open);
        break;
      case SttCommand.speedLimit5:
      case SttCommand.speedLimit10:
      case SttCommand.speedLimit15:
      case SttCommand.speedLimit20:
      case SttCommand.speedLimit25:
      case SttCommand.speedLimit30:
      case SttCommand.speedLimit35:
      case SttCommand.speedLimit40:
      case SttCommand.speedLimit45:
      case SttCommand.speedLimit50:
      case SttCommand.speedLimit55:
      case SttCommand.speedLimit60:
      case SttCommand.speedLimit65:
      case SttCommand.speedLimit70:
      case SttCommand.speedLimit75:
      case SttCommand.speedLimit80:
      case SttCommand.speedLimit85:
      case SttCommand.speedLimit90:
      case SttCommand.speedLimit95:
      case SttCommand.speedLimit100:
        setSpeedLimit(command.getValue!);
        break;
      case SttCommand.workersPresent:
        if (!workersPresent.value) {
          toggleWorkersPresent();
        }
        break;
      case SttCommand.workersNotPresent:
        if (workersPresent.value) {
          toggleWorkersPresent();
        }
        break;
      case SttCommand.startWorkZone:
        if (!inWorkZone.value) {
          startWorkZoneRecording();
        }
        break;
      case SttCommand.endWorkZone:
        if (inWorkZone.value) {
          stopWorkZoneRecording();
        }
        break;
      case SttCommand.noCommandRecognized:
        break;
    }
  }
}

class _LocationAvailability {
  final bool permissionGranted;
  final bool serviceEnabled;

  const _LocationAvailability({
    required this.permissionGranted,
    required this.serviceEnabled,
  });

  bool get isAvailable => permissionGranted && serviceEnabled;
}
