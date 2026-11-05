import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:wzam/app_config.dart';
import 'package:wzam/main.dart';
import 'package:wzam/models/fixed_length_queue.dart';
import 'package:wzam/models/mobile_vehicle_location.dart';
import 'package:wzam/services/auth_service.dart';
import 'package:wzam/services/foreground_location_service.dart';
import 'package:wzam/services/location_health_monitor_service.dart';
import 'package:wzam/services/location_service.dart';
import 'package:wzam/services/push_notification_service.dart';
import 'package:wzam/services/wzam_api.dart';
import 'package:latlong2/latlong.dart' as map;

class MobileVehicleMapController extends GetxController
    with WidgetsBindingObserver {
  // Controllers and Services
  MapController? mapController;
  LocationService locationService = Get.find<LocationService>();
  ForegroundLocationService foregroundLocationService =
      Get.find<ForegroundLocationService>();
  AuthService authService = Get.find<AuthService>();
  List<StreamSubscription> subscriptions = [];

  // Marker Data
  Rx<Marker?> userMarker = Rx<Marker?>(null);

  // Layers
  Rx<MarkerLayer> markerLayer = const MarkerLayer(markers: <Marker>[]).obs;

  Rx<MobileVehicleOperationType> operationType =
      MobileVehicleOperationType.PLOWING.obs;
  Rx<String> licensePlate = "".obs;

  StreamSubscription<Position>? _locationSubscription;
  Rx<DateTime?> lastLiveWorkerLocationUpdate = Rx<DateTime?>(null);
  Position? lastLiveWorkerLocation;
  FixedLengthQueue<map.LatLng> positionHistory =
      FixedLengthQueue<map.LatLng>(10);
  Rx<Marker?> liveMarker = Rx<Marker?>(null);

  RxBool loadingMobileVehicle = false.obs;
  RxDouble currentZoom = 18.0.obs;

  RxBool isMapFollowingVehicle = true.obs;

  Rx<Widget> mobileVehicleActiveMarker = Rx<Widget>(Image.asset('assets/images/mobile_vehicle_live_icon_active.png'));
  Rx<Widget> mobileVehicleInactiveMarker = Rx<Widget>(Image.asset('assets/images/mobile_vehicle_live_icon_inactive.png'));

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

  static const String _mobileVehicleSessionId = 'mobile_vehicle';
  static const int _mobileVehicleNotificationId = 202;

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _locationSubscription?.cancel();
    _availabilityRetryTimer?.cancel();
    _healthSessionWorker?.dispose();
    locationHealthMonitorService.unregisterSession(_mobileVehicleSessionId);
    pushNotificationService.cancelNotification(_mobileVehicleNotificationId);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _sessionRequested) {
      _attemptStartLocationListener();
    }
  }

  Future<void> initialize() async {
    // Initializing road event update stream
    subscriptions.forEach((subscription) => subscription.cancel());
    subscriptions.clear();

    // move to user location
    moveToUserLocation();
  }

  void moveToUserLocation() {
    if (isMapFollowingVehicle.value) {
      mapController?.move(
        userMarker.value?.point ?? AppConfig.defaultMapCenter,
        currentZoom.value,
      );
    }
  }

  Future<void> startMobileVehicleSession(
      MobileVehicleOperationType initialOperationType,
      String initialLicensePlate) async {
    operationType.value = initialOperationType;
    licensePlate.value = initialLicensePlate;
    _sessionRequested = true;
    _initializeHealthSession();
    await _attemptStartLocationListener(showUnavailableDialog: true);
  }

  void getMobileVehicleMarker(MobileVehicleMapController controller) {
    MobileVehicleOperationType operationType = controller.operationType.value;
    switch (operationType) {
      case MobileVehicleOperationType.PLOWING:
        mobileVehicleActiveMarker.value = Image.asset('assets/images/mobile_vehicle_live_icon_active.png');
        mobileVehicleInactiveMarker.value = Image.asset('assets/images/mobile_vehicle_live_icon_inactive.png');
        break;
      case MobileVehicleOperationType.STRIPING:
        mobileVehicleActiveMarker.value = Image.asset('assets/images/mobile_vehicle_paint_active.png');
        mobileVehicleInactiveMarker.value = Image.asset('assets/images/mobile_vehicle_paint_inactive.png');
        break;
      case MobileVehicleOperationType.MOWING:
        mobileVehicleActiveMarker.value = Image.asset('assets/images/mobile_vehicle_mowing_active.png');
        mobileVehicleInactiveMarker.value = Image.asset('assets/images/mobile_vehicle_mowing_inactive.png');
        break;
      default: 
        mobileVehicleActiveMarker.value = Image.asset('assets/images/mobile_vehicle_live_icon_active.png');
        mobileVehicleInactiveMarker.value = Image.asset('assets/images/mobile_vehicle_live_icon_inactive.png');
        break;
    }
  }

  Future<void> startListeningToLocation() async {
    if (_locationSubscription != null) {
      return;
    }
    foregroundLocationService.startLocationUpdates();
    _locationSubscription =
        foregroundLocationService.locationStream.listen((Position position) {
      locationHealthMonitorService.reportLocationAvailability(
        _mobileVehicleSessionId,
        permissionGranted: true,
        serviceEnabled: true,
      );
      locationHealthMonitorService
          .reportLocationUpdate(_mobileVehicleSessionId);
      loadingMobileVehicle.value = false;
      handleUserPositionUpdate(position);
    }, onError: (_) {
      locationHealthMonitorService.markOffline(
          _mobileVehicleSessionId, LocationHealthReason.staleLocationUpdates);
    }, onDone: () {
      locationHealthMonitorService.markOffline(
          _mobileVehicleSessionId, LocationHealthReason.staleLocationUpdates);
      _locationSubscription = null;
      if (_sessionRequested) {
        _ensureAvailabilityRetryTimer();
      }
    });
  }

  void handleUserPositionUpdate(Position position) {
    if (lastLiveWorkerLocation == null) {
      _postNewWorkerPosition(position);
      return;
    }

    // Check if the position has changed significantly
    double distance = Geolocator.distanceBetween(
      lastLiveWorkerLocation!.latitude,
      lastLiveWorkerLocation!.longitude,
      position.latitude,
      position.longitude,
    );
    // If the distance is greater than 50 meters, update the position
    if (distance > AppConfig.liveReportMinPositionChangeMeters) {
      _postNewWorkerPosition(position);
      positionHistory.add(map.LatLng(position.latitude, position.longitude));
    } else {
      DateTime currentTime = DateTime.now();
      if (lastLiveWorkerLocationUpdate.value != null &&
          currentTime.difference(lastLiveWorkerLocationUpdate.value!) >
              AppConfig.liveReportMinUpdatePeriod) {
        _postNewWorkerPosition(position);
      }
    }
  }

  Future<void> _postNewWorkerPosition(Position position,
      {bool forceEnd = false}) async {
    lastLiveWorkerLocation = position;
    lastLiveWorkerLocationUpdate.value = DateTime.now();
    String appVersion = await getAppVersion();
    MobileVehicleLocation mobileVehicleLocation = MobileVehicleLocation(
      roadEventId: null,
      workerId: await authService.getUserId() ?? "",
      timestamp: DateTime.now(),
      isActive: forceEnd ? false : true,
      appVersion: appVersion,
      velocityKph: position.speed * 3.6, // Convert m/s to kph
      heading: position.heading,
      operationType: operationType.value,
      location: map.LatLng(position.latitude, position.longitude),
      locationHistory: positionHistory.items,
      licensePlate: '',
    );

    updateMap();
    bool success = await WzamApi.updateMobileVehicleLocation(mobileVehicleLocation);
    if (success) {
      locationHealthMonitorService.reportUploadSuccess(_mobileVehicleSessionId);
      lastLiveWorkerLocationUpdate.value = DateTime.now();
    }
  }

  void updateMap() {
    if (mapController == null ||
        isMapFollowingVehicle.value == false ||
        lastLiveWorkerLocation == null) {
      return;
    }
    mapController!.move(
      map.LatLng(
          lastLiveWorkerLocation!.latitude, lastLiveWorkerLocation!.longitude),
      currentZoom.value,
    );
  }

  Future<void> stopLiveWorkerSession() async {
    _sessionRequested = false;
    _availabilityRetryTimer?.cancel();
    _availabilityRetryTimer = null;
    final Position? lastLocation = lastLiveWorkerLocation;
    if (lastLocation != null) {
      await _postNewWorkerPosition(lastLocation, forceEnd: true);
    }
    locationHealthMonitorService.unregisterSession(_mobileVehicleSessionId);
    _healthSessionWorker?.dispose();
    _healthSessionWorker = null;
    _healthSession = null;
    pushNotificationService.cancelNotification(_mobileVehicleNotificationId);
    stopListeningToLocation();
  }

  void stopListeningToLocation() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
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
      _mobileVehicleSessionId,
      permissionGranted: availability.permissionGranted,
      serviceEnabled: availability.serviceEnabled,
    );

    if (!availability.isAvailable) {
      loadingMobileVehicle.value = false;
      if (showUnavailableDialog) {
        _showLocationUnavailableDialog(availability);
      }
      _ensureAvailabilityRetryTimer();
      return;
    }

    _availabilityRetryTimer?.cancel();
    _availabilityRetryTimer = null;
    loadingMobileVehicle.value = true;
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
        ? 'Location permission is required to start mobile vehicle reporting. Please enable location permission in app settings.'
        : 'Location services are disabled on this device. Please enable location services to start mobile vehicle reporting.';

    Get.dialog(
      AlertDialog(
        title: const Text('Mobile Vehicle Reporting Unavailable'),
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
        sessionId: _mobileVehicleSessionId,
        staleThreshold: Duration(seconds: 30),
        notificationId: _mobileVehicleNotificationId,
        offlineTitle: 'Device is offline',
        offlineBody:
            'Mobile vehicle reporting is unavailable. It will resume when the device is back online.',
        recoveredTitle: 'Device is back online',
        recoveredBody: 'Mobile vehicle reporting has continued',
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
      timestampLabel: 'Last Sync',
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
