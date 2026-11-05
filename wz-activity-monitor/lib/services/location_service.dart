import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:wzam/services/auth_service.dart';

class LocationService extends GetxService {
  // Static variables
  final Logger _logger = Logger();
  final LocationSettings _locationSettings = const LocationSettings(
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

  int timesLocationPermissionRequested = 0;

  LocationService(
      {bool mocked = false,
      double latitude = 0,
      double longitude = 0,
      Position? mockedLocation}) {
    Geolocator.checkPermission().then((v) => _permission = v);

    // Need to initialize late to add onListen and onCancel methods
    _locationController = StreamController<Position>.broadcast(
      onListen: _startLocationUpdatesWithPermissions,
      onCancel: stopLocationUpdates,
    );
  }

  Future<bool> _startLocationUpdatesWithPermissions() async {
    await requestPermission();

    if (await _isPermissionGranted() && _serviceEnabled) {
      _startLocationUpdates();
      return true;
    }
    return false;
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
    timesLocationPermissionRequested++;
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
              child: const Text('OK'),
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

  void _startLocationUpdates() async {
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
