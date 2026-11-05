import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:wzam/app_config.dart';
import 'package:wzam/main.dart';
import 'package:wzam/models/fixed_length_queue.dart';
import 'package:wzam/models/generated/road_event.pb.dart';
import 'package:wzam/models/generated/wzdx.pbenum.dart';
import 'package:wzam/models/live_worker_location.dart';
import 'package:wzam/models/mappable_road_event.dart';
import 'package:wzam/models/marker_data.dart';
import 'package:wzam/models/position_extensions.dart';
import 'package:wzam/models/wrappers/road_event_wrapper.dart';
import 'package:wzam/services/auth_service.dart';
import 'package:wzam/services/cache_service.dart';
import 'package:wzam/services/file_storage.dart';
import 'package:wzam/services/foreground_location_service.dart';
import 'package:wzam/services/location_service.dart';
import 'package:wzam/services/location_health_monitor_service.dart';
import 'package:wzam/services/push_notification_service.dart';
import 'package:wzam/services/wzam_api.dart';
import 'package:wzam/ui/styles/app_colors.dart';
import 'package:latlong2/latlong.dart' as map;
import 'package:wzam/ui/styles/screen_size.dart';
import 'package:wzam/ui/views/road_event_details_dialog.dart';
import 'package:wzam/models/page.dart' as page_model;

class WorkZoneMapController extends GetxController with WidgetsBindingObserver {
  // Controllers and Services
  late MapController? mapController;
  LocationService locationService = Get.find<LocationService>();
  ForegroundLocationService foregroundLocationService =
      Get.find<ForegroundLocationService>();
  AuthService authService = Get.find<AuthService>();
  FileStorageService fileService = Get.find<FileStorageService>();
  CacheService cacheService = Get.find<CacheService>();
  List<StreamSubscription> subscriptions = [];

  // Item lists based on types
  RxList<RoadEventWrapper> roadEvents = <RoadEventWrapper>[].obs;

  // Marker Data
  RxList<MarkerData> reportMarkerData = <MarkerData>[].obs;
  RxList<MappableRoadEvent> mappableRoadEvents = <MappableRoadEvent>[].obs;
  Rx<Marker?> userMarker = Rx<Marker?>(null);

  // Marker Lists
  RxList<Marker> reportMarkers = <Marker>[].obs;
  RxList<Marker> roadEventMarkers = <Marker>[].obs;

  // Polyline Lists
  final LayerHitNotifier<Object> _polylineHitNotifier = ValueNotifier(null);

  // Polygon Lists
  final LayerHitNotifier<Object> _polygonHitNotifier = ValueNotifier(null);

  // Layers
  Rx<MarkerLayer> markerLayer = const MarkerLayer(markers: <Marker>[]).obs;
  Rx<PolylineLayer> polylineLayer =
      const PolylineLayer(polylines: <Polyline>[]).obs;
  Rx<PolygonLayer> polygonLayer = const PolygonLayer(polygons: <Polygon>[]).obs;

  Rx<int> selectedRoadEvent = (-1).obs;

  RxBool showFilters = false.obs;
  RxBool showActive = true.obs;
  RxBool showInactive = true.obs;
  RxBool showUnknown = true.obs;
  RxBool showRecentlyCompleted = true.obs;
  RxBool showStatic = true.obs;
  RxBool showMoving = true.obs;
  RxBool showPlanned = true.obs;
  RxBool sortMine = false.obs;

  WorkerLocationType workerLocationType = WorkerLocationType.WORKER;
  RxBool activeLiveWorker = false.obs;
  Rx<RoadEvent?> currentLiveWorkerRoadEvent = Rx<RoadEvent?>(null);

  StreamSubscription<Position>? _locationSubscription;
  Rx<DateTime?> lastLiveWorkerLocationUpdate = Rx<DateTime?>(null);
  Position? _lastLiveWorkerLocation;
  FixedLengthQueue<map.LatLng> positionHistory =
      FixedLengthQueue<map.LatLng>(10);
  Rx<Marker?> liveMarker = Rx<Marker?>(null);

  RxBool loadingLiveWorker = false.obs;
  RxDouble currentZoom = 18.0.obs;

  RxBool isMapFollowingWorker = true.obs;
  late Position currentUserPosition; 

  RxBool notGettingLocationUpdates = false.obs;
  Rx<LocationHealthReason> locationHealthReason = LocationHealthReason.none.obs;
  PushNotificationService pushNotificationService = Get.find<PushNotificationService>();
  LocationHealthMonitorService locationHealthMonitorService =
      Get.find<LocationHealthMonitorService>();
  LocationHealthSessionHandle? _healthSession;
  Worker? _healthSessionWorker;
  Timer? _availabilityRetryTimer;
  bool _sessionRequested = false;
  bool _startingLocationListener = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _polylineHitNotifier
        .addListener(() => onLayerTap(_polylineHitNotifier.value?.hitValues));
    _polygonHitNotifier
        .addListener(() => onLayerTap(_polygonHitNotifier.value?.hitValues));
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _locationSubscription?.cancel();
    _availabilityRetryTimer?.cancel();
    _healthSessionWorker?.dispose();
    locationHealthMonitorService.unregisterSession(_liveWorkerSessionId);
    pushNotificationService.cancelNotification(_liveWorkerNotificationId);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _sessionRequested) {
      _attemptStartLocationListener();
    }
  }

  static const String _liveWorkerSessionId = 'live_worker';
  static const int _liveWorkerNotificationId = 201;

  Future<void> initialize() async {
    // Initializing road event update stream
    subscriptions.forEach((subscription) => subscription.cancel());
    subscriptions.clear();
    subscriptions.add(cacheService.roadEvents.listen((roadEvents) {
      updateRoadEventData(roadEvents.values.toList());
    }));
    await cacheService.updateRoadEvents();

    // redefine statuses based on dates
    for (var wrapper in roadEvents) {
      RoadEvent event = wrapper.roadEvent;
      RoadEvent_RoadEventActiveStatus status = getRoadEventStatus(event);
      event.status = status;
    }

    // get mappable road events
    mappableRoadEvents.value = getRoadEventMarkersData();
    // create layers
    await createLayers();
    // move to user location
    moveToUserLocation();
  }

  Future<void> updateRoadEventData(List<RoadEventWrapper> updatedRoadEvents) async {
    roadEvents.value = updatedRoadEvents;
    // redefine statuses based on dates
    for (var wrapper in roadEvents) {
      RoadEvent event = wrapper.roadEvent;
      RoadEvent_RoadEventActiveStatus status = getRoadEventStatus(event);
      event.status = status;
    }
    // get mappable road events
    mappableRoadEvents.value = getRoadEventMarkersData();
    // create layers
    await createLayers();
  }

  void moveToUserLocation() {
    mapController?.move(
      userMarker.value?.point ?? AppConfig.defaultMapCenter,
      currentZoom.value,
    );
  }

  void updateMap() {
    if (mapController == null || isMapFollowingWorker.value == false) return;
    mapController?.move(currentUserPosition.getLatLng(), currentZoom.value);
  }


  Future<List<RoadEventWrapper>> getRoadEvents() async {
    // try {
      page_model.Page<RoadEventWrapper>? events = await WzamApi.getRoadEvents();
      if (events == null) {
        return [];
      } else {
        return events.content;
      }
    // } catch (e) {
    //   return await fileService.getRoadEventFiles('road_events');
    // }
  }

  Future<void> createLayers() async {
    List<Marker> markers = [];
    List<Polyline> polylines = [];
    List<Polygon> polygons = [];
    if (activeLiveWorker.value) {
      int liveWorkerIndex = mappableRoadEvents.indexWhere((roadEvent) =>
          roadEvent.id == currentLiveWorkerRoadEvent.value?.id.toInt());
      MappableRoadEvent? liveWorkerMappableEvent =
          liveWorkerIndex != -1 ? mappableRoadEvents[liveWorkerIndex] : null;
      if (liveWorkerMappableEvent != null) {
        if (liveWorkerMappableEvent.markers.marker != null) {
          markers.addAll(liveWorkerMappableEvent.markers.marker!);
        }
        if (liveWorkerMappableEvent.markers.polyline != null) {
          polylines.add(liveWorkerMappableEvent.markers.polyline!);
        }
        if (liveWorkerMappableEvent.markers.polygon != null) {
          polygons.add(liveWorkerMappableEvent.markers.polygon!);
        }
        markers.add(liveMarker.value!);
        selectRoadEvent(liveWorkerIndex);
      }
    } else {
      for (MappableRoadEvent roadEvent in mappableRoadEvents) {
        if (roadEvent.markers.marker != null) {
          markers.addAll(roadEvent.markers.marker!);
        }
        if (roadEvent.markers.polyline != null) {
          polylines.add(roadEvent.markers.polyline!);
        }
        if (roadEvent.markers.polygon != null) {
          polygons.add(roadEvent.markers.polygon!);
        }
      }
      userMarker.value = await getUserMarker();
      if (userMarker.value != null) {
        markers.add(userMarker.value!);
      }
    }
    markerLayer.value = MarkerLayer(markers: markers);
    polylineLayer.value =
        PolylineLayer(polylines: polylines, hitNotifier: _polylineHitNotifier);
    polygonLayer.value =
        PolygonLayer(polygons: polygons, hitNotifier: _polygonHitNotifier);
  }

  Future<void> updateLiveWorkerMap() async {
    List<Marker> markers = [];
    if (activeLiveWorker.value) {
      int liveWorkerIndex = mappableRoadEvents.indexWhere((roadEvent) =>
          roadEvent.id == currentLiveWorkerRoadEvent.value?.id.toInt());
      MappableRoadEvent? liveWorkerMappableEvent =
          liveWorkerIndex != -1 ? mappableRoadEvents[liveWorkerIndex] : null;
      if (liveWorkerMappableEvent != null) {
        if (liveWorkerMappableEvent.markers.marker != null) {
          markers.addAll(liveWorkerMappableEvent.markers.marker!);
        }
        markers.add(liveMarker.value!);
      }
      if (isMapFollowingWorker.value) {
        mapController?.move(currentUserPosition.getLatLng(), currentZoom.value);
      }
    }
    markerLayer.value = MarkerLayer(markers: markers);
  }

  Future<Marker?> getUserMarker() async {
    try {
      Position? position;
      if (locationService.timesLocationPermissionRequested == 0) {
        position = await locationService.getCurrentLocation();
      } else {
        position = locationService.currentPosition.value;
      }
      if (position != null) {
        return _createUserMaker(position);
      }
    } catch (e) {
      print("Error getting current position: $e");
    }
    return null;
  }

  Marker _createUserMaker(Position position) {
    return Marker(
        point: position.getLatLng(),
        child: Image.asset('assets/images/location_with_border.png',
            width: 25.0, height: 25.0),
        rotate: true);
  }

  Marker _createLiveMarker({Position? position}) {
    Marker liveMarker = Marker(
        point: position?.getLatLng() ??
            foregroundLocationService.currentPosition.value?.getLatLng() ??
            AppConfig.defaultMapCenter,
        width: 45,
        height: 45,
        rotate: true,
        child: GestureDetector(
          onTap: () {},
          child: liveIcon(),
        ));
    return liveMarker;
  }

  void updateLiveMarkerPosition(Position position) {
    if (liveMarker.value != null) {
      liveMarker.value = _createLiveMarker(position: position);
      // Update the marker layer with the new marker
      List<Marker> markers = markerLayer.value.markers.toList();
      int index = markers.indexWhere((m) => m == liveMarker.value);
      if (index != -1) {
        markers[index] = liveMarker.value!;
        markerLayer.value = MarkerLayer(markers: markers);
      }
    }
  }

  Container liveIcon() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        border: Border.all(color: primaryColor, width: 2.0),
      ),
      child: Image.asset(
        'assets/images/workers_not_present.png',
      ),
    );
  }

  List<MappableRoadEvent> getRoadEventMarkersData() {
    List<MappableRoadEvent> markerDataList = [];
    for (RoadEventWrapper roadEventWrapper in roadEvents) {
      if (roadEventWrapper.roadEvent.status ==
              RoadEvent_RoadEventActiveStatus.ROAD_EVENT_ACTIVE_STATUS_ACTIVE &&
          !showActive.value) {
        continue;
      }
      if (roadEventWrapper.roadEvent.status ==
              RoadEvent_RoadEventActiveStatus
                  .ROAD_EVENT_ACTIVE_STATUS_INACTIVE &&
          !showInactive.value) {
        continue;
      }
      if (roadEventWrapper.roadEvent.status ==
              RoadEvent_RoadEventActiveStatus
                  .ROAD_EVENT_ACTIVE_STATUS_UNKNOWN &&
          !showUnknown.value) {
        continue;
      }
      if (roadEventWrapper.roadEvent.areaType ==
              WorkZoneType.WORK_ZONE_TYPE_STATIC &&
          !showStatic.value) {
        continue;
      }
      if (roadEventWrapper.roadEvent.areaType ==
              WorkZoneType.WORK_ZONE_TYPE_MOVING &&
          !showMoving.value) {
        continue;
      }
      if (roadEventWrapper.roadEvent.areaType ==
              WorkZoneType.WORK_ZONE_TYPE_PLANNED_MOVING_AREA &&
          !showPlanned.value) {
        continue;
      }
      MarkerData markerData =
          getRoadEventMarkerData(roadEventWrapper.roadEvent);
      MappableRoadEvent mappableRoadEvent = MappableRoadEvent.fromRoadEvent(
        roadEventWrapper,
        markerData,
      );
      markerDataList.add(mappableRoadEvent);
    }
    return markerDataList;
  }

  MarkerData getRoadEventMarkerData(RoadEvent roadEvent) {
    List<Marker>? marker;
    Polyline? polyline;
    Polygon? polygon;
    if (roadEvent.whichGeometry() == RoadEvent_Geometry.point) {
      marker = [createRoadMarker(roadEvent)];
    } else if (roadEvent.whichGeometry() == RoadEvent_Geometry.lineString) {
      polyline = createRoadPolyline(roadEvent);
    } else if (roadEvent.whichGeometry() == RoadEvent_Geometry.polygon) {
      polygon = createRoadPolygon(roadEvent);
    }
    return MarkerData(marker: marker, polyline: polyline, polygon: polygon);
  }

  Marker createRoadMarker(RoadEvent roadEvent) {
    return Marker(
        width: 35.0,
        height: 35.0,
        rotate: true,
        point: map.LatLng(roadEvent.point.coordinates.latitude,
            roadEvent.point.coordinates.longitude),
        child: GestureDetector(  
          onTap: () {
            onObjectTap(roadEvent.id.toInt());
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(6.0)),
              border: Border.all(color: roadEvent.status == RoadEvent_RoadEventActiveStatus.ROAD_EVENT_ACTIVE_STATUS_ACTIVE ? primaryColor : inactiveColor, width: 2.0),
            ),
            alignment: Alignment.center,
            child: getEventIcon(roadEvent.status)
          ),
        ),
    );
  }

  Polyline createRoadPolyline(RoadEvent roadEvent) {
    return Polyline(
      points: roadEvent.lineString.coordinates.coordinates
          .map((c) => map.LatLng(c.latitude, c.longitude))
          .toList(),
      color: roadEvent.status == RoadEvent_RoadEventActiveStatus.ROAD_EVENT_ACTIVE_STATUS_ACTIVE ? primaryColor : inactiveColor,
      strokeWidth: 4.0,
      hitValue: roadEvent.id.toInt(),
    );
  }

  Polygon createRoadPolygon(RoadEvent roadEvent) {
    return Polygon(
      points: roadEvent.polygon.coordinates.coordinates
          .map((c) => map.LatLng(c.latitude, c.longitude))
          .toList(),
      color: roadEvent.status == RoadEvent_RoadEventActiveStatus.ROAD_EVENT_ACTIVE_STATUS_ACTIVE ? primaryColor.withValues(alpha: 0.5) : inactiveColor.withValues(alpha: 0.5),
      borderColor: roadEvent.status == RoadEvent_RoadEventActiveStatus.ROAD_EVENT_ACTIVE_STATUS_ACTIVE ? primaryColor : inactiveColor,
      borderStrokeWidth: 2.0,
      hitValue: roadEvent.id.toInt(),
    );
  }

  void selectRoadEvent(int index) {
    if (index < 0 || index >= mappableRoadEvents.length) {
      return;
    }
    selectedRoadEvent.value = mappableRoadEvents[index].id;
    if (mappableRoadEvents[index].bounds == null) {
      mapController?.move(
          mappableRoadEvents[index].centerPoint, currentZoom.value,
          offset: const Offset(0, -150));
    } else {
      if (mappableRoadEvents[index].bounds!.north ==
              mappableRoadEvents[index].bounds!.south ||
          mappableRoadEvents[index].bounds!.east ==
              mappableRoadEvents[index].bounds!.west) {
        mapController?.move(
            mappableRoadEvents[index].centerPoint, currentZoom.value,
            offset: const Offset(0, -150));
      } else {
        CameraFit cameraFit = CameraFit.bounds(
          bounds: mappableRoadEvents[index].bounds!,
          padding: EdgeInsets.only(
              top: 20.0,
              left: 60,
              right: 60,
              bottom: screenHeight(Get.context!) * 0.4));
        mapController?.fitCamera(cameraFit);
      }
    }
  }

  void onLayerTap(List<Object>? hitValues) {
    if (hitValues != null && hitValues.isNotEmpty) {
      int id = hitValues.first as int;
      onObjectTap(id);
    }
  }

  void onObjectTap(int id) {
    selectedRoadEvent.value = id;
    MappableRoadEvent? mappableRoadEvent =
        mappableRoadEvents.firstWhereOrNull((re) => re.id == id);
    if (mappableRoadEvent != null) {
      Get.dialog(RoadEventDetailsDialog(roadEvent: mappableRoadEvent));
    } else {
      print("No road event found with ID: $id");
    }
  }

  Future<void> filter() async {
    mappableRoadEvents.value = getRoadEventMarkersData();
    createLayers();
  }

  Future<void> startLiveWorkerSession(
      RoadEvent roadEvent, WorkerLocationType locationType) async {
    workerLocationType = locationType;
    currentLiveWorkerRoadEvent.value = roadEvent;
    _sessionRequested = true;
    activeLiveWorker.value = true;
    _initializeHealthSession();
    await _attemptStartLocationListener(showUnavailableDialog: true);
  }

  Future<void> startListeningToLocation() async {
    if (_locationSubscription != null) {
      return;
    }
    foregroundLocationService.startLocationUpdates();
    _locationSubscription =
        foregroundLocationService.locationStream.listen((Position position) {
      locationHealthMonitorService.reportLocationAvailability(
        _liveWorkerSessionId,
        permissionGranted: true,
        serviceEnabled: true,
      );
      locationHealthMonitorService.reportLocationUpdate(_liveWorkerSessionId);
      loadingLiveWorker.value = false;
      liveMarker.value = _createLiveMarker(position: position);
      currentUserPosition = position;
      updateLiveWorkerMap();
      handleUserPositionUpdate();
    }, onError: (_) {
      locationHealthMonitorService.markOffline(
          _liveWorkerSessionId, LocationHealthReason.staleLocationUpdates);
    }, onDone: () {
      locationHealthMonitorService.markOffline(
          _liveWorkerSessionId, LocationHealthReason.staleLocationUpdates);
      _locationSubscription = null;
      if (_sessionRequested) {
        _ensureAvailabilityRetryTimer();
      }
    });
  }

  void handleUserPositionUpdate() {
    if (!activeLiveWorker.value) {
      return;
    }
    if (_lastLiveWorkerLocation == null) {
      _postNewWorkerPosition(currentUserPosition);
      return;
    }

    // Check if the position has changed significantly
    double distance = Geolocator.distanceBetween(
      _lastLiveWorkerLocation!.latitude,
      _lastLiveWorkerLocation!.longitude,
      currentUserPosition.latitude,
      currentUserPosition.longitude,
    );
    // If the distance is greater than 50 meters, update the position
    if (distance > AppConfig.liveReportMinPositionChangeMeters) {
      _postNewWorkerPosition(currentUserPosition);
      positionHistory.add(map.LatLng(currentUserPosition.latitude, currentUserPosition.longitude));
    } else {
      DateTime currentTime = DateTime.now();
      if (lastLiveWorkerLocationUpdate.value != null &&
          currentTime.difference(lastLiveWorkerLocationUpdate.value!) >
              AppConfig.liveReportMinUpdatePeriod) {
        _postNewWorkerPosition(currentUserPosition);
      }
    }
  }

  Future<void> _postNewWorkerPosition(Position position,
      {bool forceEnd = false}) async {
    if (currentLiveWorkerRoadEvent.value == null) {
      _locationSubscription?.cancel();
    }

    String appVersion = await getAppVersion();
    LiveWorkerLocation liveWorkerLocation = LiveWorkerLocation(
      roadEventId: currentLiveWorkerRoadEvent.value!.id.toInt(),
      workerId: await authService.getUserId() ?? "",
      timestamp: DateTime.now(),
      isActive: forceEnd ? false : activeLiveWorker.value,
      appVersion: appVersion,
      velocityKph: position.speed * 3.6, // Convert m/s to kph
      heading: position.heading,
      locationType: workerLocationType,
      location: map.LatLng(position.latitude, position.longitude),
      locationHistory: positionHistory.items,
    );

    bool success = await WzamApi.updateLiveReportLocation(liveWorkerLocation);
    if (success) {
      locationHealthMonitorService.reportUploadSuccess(_liveWorkerSessionId);
      _lastLiveWorkerLocation = position;
      lastLiveWorkerLocationUpdate.value = DateTime.now();
    }
  }

  Future<void> stopLiveWorkerSession() async {
    _sessionRequested = false;
    _availabilityRetryTimer?.cancel();
    _availabilityRetryTimer = null;
    stopListeningToLocation();
    activeLiveWorker.value = false;
    final Position? lastLocation = _lastLiveWorkerLocation;
    if (lastLocation != null) {
      await _postNewWorkerPosition(lastLocation, forceEnd: true);
    }
    currentLiveWorkerRoadEvent.value = null;
    locationHealthMonitorService.unregisterSession(_liveWorkerSessionId);
    _healthSessionWorker?.dispose();
    _healthSessionWorker = null;
    _healthSession = null;
    pushNotificationService.cancelNotification(_liveWorkerNotificationId);
    createLayers();
  }

  void stopListeningToLocation() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
    foregroundLocationService.stopLocationUpdates();
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
      _liveWorkerSessionId,
      permissionGranted: availability.permissionGranted,
      serviceEnabled: availability.serviceEnabled,
    );

    if (!availability.isAvailable) {
      loadingLiveWorker.value = false;
      if (showUnavailableDialog) {
        _showLocationUnavailableDialog(availability);
      }
      _ensureAvailabilityRetryTimer();
      return;
    }

    _availabilityRetryTimer?.cancel();
    _availabilityRetryTimer = null;
    loadingLiveWorker.value = true;
    _startingLocationListener = true;
    try {
      await startListeningToLocation();
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
        ? 'Location permission is required to start live reporting. Please enable location permission in app settings.'
        : 'Location services are disabled on this device. Please enable location services to start live reporting.';

    Get.dialog(
      AlertDialog(
        title: const Text('Live Reporting Unavailable'),
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
        sessionId: _liveWorkerSessionId,
        staleThreshold: Duration(seconds: 30),
        notificationId: _liveWorkerNotificationId,
        offlineTitle: 'Device is offline',
        offlineBody:
            'Live reporting is unavailable. It will resume when the device is back online.',
        recoveredTitle: 'Device is back online',
        recoveredBody: 'Live reporting has continued',
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
    if (snapshot.lastLocationUpdate != null) {
      lastLiveWorkerLocationUpdate.value = snapshot.lastLocationUpdate;
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
        lastLocationUpdate: lastLiveWorkerLocationUpdate.value,
        reason: locationHealthReason.value,
      ),
      timestampLabel: 'Last Location Update',
    );
  }

  RoadEvent_RoadEventActiveStatus getRoadEventStatus(RoadEvent event) {
    DateTime now = DateTime.now();
    int startDateSeconds = event.startDate.seconds.toInt();
    int? endDateSeconds =
        event.hasEndDate() ? event.endDate.seconds.toInt() : null;
    int nowSeconds = now.millisecondsSinceEpoch ~/ 1000;
    if (startDateSeconds <= nowSeconds &&
        (endDateSeconds == null || endDateSeconds >= nowSeconds)) {
      return RoadEvent_RoadEventActiveStatus.ROAD_EVENT_ACTIVE_STATUS_ACTIVE;
    } else if (endDateSeconds != null && endDateSeconds < nowSeconds) {
      return RoadEvent_RoadEventActiveStatus.ROAD_EVENT_ACTIVE_STATUS_INACTIVE;
    } else {
      return RoadEvent_RoadEventActiveStatus.ROAD_EVENT_ACTIVE_STATUS_UNKNOWN;
    }
    
  }

  Icon getEventIcon(RoadEvent_RoadEventActiveStatus status) {
    IconData iconData;
    Color iconColor;

    switch (status) {
      case RoadEvent_RoadEventActiveStatus.ROAD_EVENT_ACTIVE_STATUS_ACTIVE:
        iconData = Icons.construction;
        iconColor = primaryColor;
        break;
      case RoadEvent_RoadEventActiveStatus.ROAD_EVENT_ACTIVE_STATUS_INACTIVE:
        iconData = Icons.construction;
        iconColor = inactiveColor;
        break;
      case RoadEvent_RoadEventActiveStatus.ROAD_EVENT_ACTIVE_STATUS_UNKNOWN:
      default:
        iconData = Icons.close;
        iconColor = inactiveColor;
        break;
    }

    return Icon(
      iconData,
      color: iconColor,
      size: 30.0,
    );
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
