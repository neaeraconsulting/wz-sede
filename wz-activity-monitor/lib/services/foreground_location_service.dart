import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:wzam/services/auth_service.dart';

class ForegroundLocationService extends GetxService {
  // Static variables
  final Logger _logger = Logger();
  LocationSettings _locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, distanceFilter: 0);

  // Variables
  bool _serviceEnabled = false;
  late LocationPermission _permission;
  StreamSubscription<Position>? _positionStream;
  Rx<Position?> currentPosition = Rx<Position?>(null);

  // Location Stream
  late final StreamController<Position> _locationController;
  Stream<Position> get locationStream => _locationController.stream;

  AuthService authService = Get.find<AuthService>();

  RxBool isLocationPermissionsEnabled = true.obs;

  ForegroundLocationService(
      {bool mocked = false,
      double latitude = 0,
      double longitude = 0,
      Position? mockedLocation}) {
    Geolocator.checkPermission().then((v) => _permission = v);

    // Need to initialize late to add onListen and onCancel methods
    _locationController = StreamController<Position>.broadcast(
      onListen: _startLocationUpdatesWithForeground,
      onCancel: stopLocationUpdates,
    );
  }

  Future<bool> _startLocationUpdatesWithForeground() async {
    await requestPermission();

    if (await _isPermissionGranted() && _serviceEnabled) {
      isLocationPermissionsEnabled.value = true;
      enableForegroundService();
      startLocationUpdates();
      return true;
    } else {
      isLocationPermissionsEnabled.value = false;
      return false;
    }
  }

  Future<bool> _isPermissionGranted({check = true}) async {
    if (check) _permission = await Geolocator.checkPermission();
    switch (_permission) {
      case LocationPermission.denied:
      case LocationPermission.deniedForever:
        return false;
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        return true;
      case LocationPermission.unableToDetermine:
        return false;
    }
  }

  Future<bool> requestPermission() async {
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      _logger.w("Location services are disabled");
      return false;
    }
    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      if (_permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        _logger.w(
            "Location permissions are permanently denied, we cannot request permissions.");
        return false;
      }
      await Get.dialog(
        AlertDialog(
          title: const Text('Location Permissions'),
          content: const Text(
              'This application requires location permissions for accurate timing and data collection. Without it, the application\'s accuracy will be reduced.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Next'),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      );
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        _logger.w("Location permissions are denied after requesting");
        return false;
      }
    }
    /*if (_permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      _logger.w(
          "Location permissions are permanently denied, we cannot request permissions.");
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }*/
    return true;
  }

  void enableForegroundService() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      _locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 3),
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText: "Location Services are running",
            notificationTitle:
                "Location Services are running in the background",
            enableWakeLock: true,
            setOngoing: true,
            notificationIcon: AndroidResource(
              name: 'ic_notification',
              defType: 'drawable',
            ),
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      _locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 0,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: false,
      );
    } else if (kIsWeb) {
      _locationSettings = WebSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
        maximumAge: const Duration(minutes: 5),
      );
    } else {
      _locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }
  }

  void startLocationUpdates() async {
    // Start the location stream
    _positionStream?.cancel();

    _positionStream =
        Geolocator.getPositionStream(locationSettings: _locationSettings)
            .listen(_onPositionUpdate);
  }

  void _onPositionUpdate(Position position) {
    print("Position update: $position");
    _locationController.add(position);
    currentPosition.value = position;
  }

  void stopLocationUpdates() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  Future<Position?> getCurrentLocation() async {
    await requestPermission();
    if (!await _isPermissionGranted() || !_serviceEnabled) {
      _logger.w(
          "Location permissions not granted or is disabled, cannot get current location");
      return null;
    }
    currentPosition.value = await Geolocator.getCurrentPosition();
    return currentPosition.value;
  }

  bool areLocationUpdatesActive() {
    return _serviceEnabled && !(_positionStream?.isPaused ?? true);
  }
}
