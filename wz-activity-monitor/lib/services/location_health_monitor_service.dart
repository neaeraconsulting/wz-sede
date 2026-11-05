import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wzam/services/push_notification_service.dart';

enum LocationHealthReason {
  none,
  staleLocationUpdates,
  connectivityLost,
  permissionDenied,
  locationServiceDisabled,
  permissionUnavailable,
}

String locationHealthReasonMessage(LocationHealthReason reason) {
  switch (reason) {
    case LocationHealthReason.connectivityLost:
      return 'Offline: no network connection';
    case LocationHealthReason.permissionDenied:
      return 'Offline: location permission denied';
    case LocationHealthReason.locationServiceDisabled:
      return 'Offline: device location services disabled';
    case LocationHealthReason.permissionUnavailable:
      return 'Offline: location permission or service unavailable';
    case LocationHealthReason.staleLocationUpdates:
      return 'Offline: no recent location updates';
    case LocationHealthReason.none:
      return 'Offline';
  }
}

String locationHealthReasonGuidance(LocationHealthReason reason) {
  switch (reason) {
    case LocationHealthReason.connectivityLost:
      return 'Check cellular or Wi-Fi connectivity.';
    case LocationHealthReason.permissionDenied:
      return 'Allow location permission in app settings.';
    case LocationHealthReason.locationServiceDisabled:
      return 'Enable device location services.';
    case LocationHealthReason.permissionUnavailable:
      return 'Enable location permission and device location services.';
    case LocationHealthReason.staleLocationUpdates:
      return 'Move to an open area and keep location services active.';
    case LocationHealthReason.none:
      return '';
  }
}

class LocationHealthSnapshot {
  final bool isOffline;
  final DateTime? lastLocationUpdate;
  final LocationHealthReason reason;

  const LocationHealthSnapshot({
    required this.isOffline,
    required this.lastLocationUpdate,
    required this.reason,
  });
}

class LocationHealthBannerViewModel {
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final String primaryLine;
  final String secondaryLine;
  final bool isOffline;

  const LocationHealthBannerViewModel({
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.primaryLine,
    required this.secondaryLine,
    required this.isOffline,
  });
}

LocationHealthBannerViewModel buildLocationHealthBannerViewModel({
  required LocationHealthSnapshot snapshot,
  required String timestampLabel,
  DateTime? now,
}) {
  final DateTime effectiveNow = now ?? DateTime.now();
  final DateTime updateTime = snapshot.lastLocationUpdate ?? effectiveNow;
  final String timestamp = DateFormat.yMd().add_jm().format(updateTime);

  if (!snapshot.isOffline) {
    return LocationHealthBannerViewModel(
      icon: Icons.check_circle,
      backgroundColor: Colors.white.withValues(alpha: 0.85),
      textColor: Colors.black,
      primaryLine: 'Online: location updates are active',
      secondaryLine: '$timestampLabel: $timestamp',
      isOffline: false,
    );
  }

  switch (snapshot.reason) {
    case LocationHealthReason.connectivityLost:
      return LocationHealthBannerViewModel(
        icon: Icons.wifi_off,
        backgroundColor: Colors.orange.withValues(alpha: 0.92),
        textColor: Colors.black,
        primaryLine:
            '${locationHealthReasonMessage(snapshot.reason)}. ${locationHealthReasonGuidance(snapshot.reason)}',
        secondaryLine: '$timestampLabel: $timestamp',
        isOffline: true,
      );
    case LocationHealthReason.permissionUnavailable:
      return LocationHealthBannerViewModel(
        icon: Icons.location_off,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        textColor: Colors.white,
        primaryLine:
            '${locationHealthReasonMessage(snapshot.reason)}. ${locationHealthReasonGuidance(snapshot.reason)}',
        secondaryLine: '$timestampLabel: $timestamp',
        isOffline: true,
      );
    case LocationHealthReason.permissionDenied:
      return LocationHealthBannerViewModel(
        icon: Icons.lock_outline,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        textColor: Colors.white,
        primaryLine:
            '${locationHealthReasonMessage(snapshot.reason)}. ${locationHealthReasonGuidance(snapshot.reason)}',
        secondaryLine: '$timestampLabel: $timestamp',
        isOffline: true,
      );
    case LocationHealthReason.locationServiceDisabled:
      return LocationHealthBannerViewModel(
        icon: Icons.location_disabled,
        backgroundColor: Colors.deepOrange.withValues(alpha: 0.9),
        textColor: Colors.white,
        primaryLine:
            '${locationHealthReasonMessage(snapshot.reason)}. ${locationHealthReasonGuidance(snapshot.reason)}',
        secondaryLine: '$timestampLabel: $timestamp',
        isOffline: true,
      );
    case LocationHealthReason.staleLocationUpdates:
      return LocationHealthBannerViewModel(
        icon: Icons.gps_off,
        backgroundColor: Colors.deepOrange.withValues(alpha: 0.9),
        textColor: Colors.white,
        primaryLine:
            '${locationHealthReasonMessage(snapshot.reason)}. ${locationHealthReasonGuidance(snapshot.reason)}',
        secondaryLine: '$timestampLabel: $timestamp',
        isOffline: true,
      );
    case LocationHealthReason.none:
      return LocationHealthBannerViewModel(
        icon: Icons.warning,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        textColor: Colors.white,
        primaryLine: 'Offline',
        secondaryLine: '$timestampLabel: $timestamp',
        isOffline: true,
      );
  }
}

class LocationHealthSessionConfig {
  final String sessionId;
  final Duration staleThreshold;
  final int notificationId;
  final String offlineTitle;
  final String offlineBody;
  final String recoveredTitle;
  final String recoveredBody;

  const LocationHealthSessionConfig({
    required this.sessionId,
    required this.staleThreshold,
    required this.notificationId,
    required this.offlineTitle,
    required this.offlineBody,
    required this.recoveredTitle,
    required this.recoveredBody,
  });
}

class LocationHealthSessionHandle {
  final String sessionId;
  final Rx<LocationHealthSnapshot> snapshot;

  LocationHealthSessionHandle({
    required this.sessionId,
    required this.snapshot,
  });
}

class _SessionRuntime {
  final LocationHealthSessionConfig config;
  final Rx<LocationHealthSnapshot> snapshot;
  bool permissionGranted = true;
  bool locationServiceEnabled = true;
  bool outageNotificationSent = false;
  bool hasReceivedLocationUpdate = false;
  Timer? staleTimer;

  _SessionRuntime(this.config)
      : snapshot = Rx<LocationHealthSnapshot>(
          const LocationHealthSnapshot(
            isOffline: false,
            lastLocationUpdate: null,
            reason: LocationHealthReason.none,
          ),
        );
}

class LocationHealthMonitorService extends GetxService
  with WidgetsBindingObserver {
  final PushNotificationService _pushNotificationService =
      Get.find<PushNotificationService>();

  final Map<String, _SessionRuntime> _sessions = {};
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _hasConnectivity = true;
  Timer? _permissionHealthTimer;
  static const Duration _permissionHealthPollInterval =
      Duration(seconds: 10);

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _initializeConnectivity();
    _refreshPermissionAndServiceStateForAllSessions();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivitySubscription?.cancel();
    _permissionHealthTimer?.cancel();
    for (final session in _sessions.values) {
      session.staleTimer?.cancel();
    }
    _sessions.clear();
    super.onClose();
  }

  Future<void> _initializeConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    _hasConnectivity = !results.contains(ConnectivityResult.none);

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((results) {
      _hasConnectivity = !results.contains(ConnectivityResult.none);
      _refreshPermissionAndServiceStateForAllSessions();
      _evaluateAllSessions();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshPermissionAndServiceStateForAllSessions();
      _evaluateAllSessions();
    }
  }

  LocationHealthSessionHandle registerSession(LocationHealthSessionConfig config) {
    final existing = _sessions[config.sessionId];
    if (existing != null) {
      existing.staleTimer?.cancel();
      _sessions.remove(config.sessionId);
    }

    final runtime = _SessionRuntime(config);
    _sessions[config.sessionId] = runtime;
    _ensurePermissionHealthTimer();
    _refreshPermissionAndServiceStateForAllSessions();
    _armStaleTimer(runtime);
    _evaluateSession(runtime);

    return LocationHealthSessionHandle(
      sessionId: config.sessionId,
      snapshot: runtime.snapshot,
    );
  }

  void unregisterSession(String sessionId) {
    final runtime = _sessions.remove(sessionId);
    runtime?.staleTimer?.cancel();
    if (_sessions.isEmpty) {
      _permissionHealthTimer?.cancel();
      _permissionHealthTimer = null;
    }
  }

  void reportPermissionState(String sessionId, bool permissionEnabled) {
    reportLocationAvailability(
      sessionId,
      permissionGranted: permissionEnabled,
      serviceEnabled: permissionEnabled,
    );
  }

  void reportLocationAvailability(
    String sessionId, {
    required bool permissionGranted,
    required bool serviceEnabled,
  }) {
    final runtime = _sessions[sessionId];
    if (runtime == null) return;

    runtime.permissionGranted = permissionGranted;
    runtime.locationServiceEnabled = serviceEnabled;
    _evaluateSession(runtime);
  }

  void reportLocationUpdate(String sessionId, {DateTime? at}) {
    final runtime = _sessions[sessionId];
    if (runtime == null) return;

    final now = at ?? DateTime.now();
    runtime.hasReceivedLocationUpdate = true;
    runtime.snapshot.value = LocationHealthSnapshot(
      isOffline: runtime.snapshot.value.isOffline,
      lastLocationUpdate: now,
      reason: runtime.snapshot.value.reason,
    );
    _armStaleTimer(runtime);
    _evaluateSession(runtime);
  }

  void reportUploadSuccess(String sessionId, {DateTime? at}) {
    reportLocationUpdate(sessionId, at: at);
  }

  void markOffline(String sessionId, LocationHealthReason reason) {
    final runtime = _sessions[sessionId];
    if (runtime == null) return;
    _setOffline(runtime, reason);
  }

  void _evaluateAllSessions() {
    for (final runtime in _sessions.values) {
      _evaluateSession(runtime);
    }
  }

  void _ensurePermissionHealthTimer() {
    if (_permissionHealthTimer != null) {
      return;
    }
    _permissionHealthTimer =
        Timer.periodic(_permissionHealthPollInterval, (_) {
      _refreshPermissionAndServiceStateForAllSessions();
      _evaluateAllSessions();
    });
  }

  Future<void> _refreshPermissionAndServiceStateForAllSessions() async {
    if (_sessions.isEmpty) {
      return;
    }

    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    final LocationPermission permission = await Geolocator.checkPermission();
    final bool permissionGranted = permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;

    for (final runtime in _sessions.values) {
      runtime.permissionGranted = permissionGranted;
      runtime.locationServiceEnabled = serviceEnabled;
    }
  }

  void _evaluateSession(_SessionRuntime runtime) {
    if (!runtime.locationServiceEnabled) {
      _setOffline(runtime, LocationHealthReason.locationServiceDisabled);
      return;
    }

    if (!runtime.permissionGranted) {
      _setOffline(runtime, LocationHealthReason.permissionDenied);
      return;
    }

    if (!_hasConnectivity) {
      _setOffline(runtime, LocationHealthReason.connectivityLost);
      return;
    }

    final lastUpdate = runtime.snapshot.value.lastLocationUpdate;
    if (lastUpdate == null && !runtime.hasReceivedLocationUpdate) {
      return;
    }
    if (lastUpdate == null ||
        DateTime.now().difference(lastUpdate) > runtime.config.staleThreshold) {
      _setOffline(runtime, LocationHealthReason.staleLocationUpdates);
      return;
    }

    _setHealthy(runtime);
  }

  void _armStaleTimer(_SessionRuntime runtime) {
    runtime.staleTimer?.cancel();
    runtime.staleTimer = Timer(runtime.config.staleThreshold, () {
      _evaluateSession(runtime);
    });
  }

  void _setOffline(_SessionRuntime runtime, LocationHealthReason reason) {
    final current = runtime.snapshot.value;
    runtime.snapshot.value = LocationHealthSnapshot(
      isOffline: true,
      lastLocationUpdate: current.lastLocationUpdate,
      reason: reason,
    );

    if (!runtime.outageNotificationSent) {
      runtime.outageNotificationSent = true;
      _pushNotificationService.showSimpleNotification(
        title: runtime.config.offlineTitle,
        body: runtime.config.offlineBody,
        payload: runtime.config.sessionId,
        id: runtime.config.notificationId,
      );
    }
  }

  void _setHealthy(_SessionRuntime runtime) {
    final current = runtime.snapshot.value;
    runtime.snapshot.value = LocationHealthSnapshot(
      isOffline: false,
      lastLocationUpdate: current.lastLocationUpdate,
      reason: LocationHealthReason.none,
    );

    if (runtime.outageNotificationSent) {
      runtime.outageNotificationSent = false;
      _pushNotificationService.showSimpleNotification(
        title: runtime.config.recoveredTitle,
        body: runtime.config.recoveredBody,
        payload: runtime.config.sessionId,
        id: runtime.config.notificationId,
      );
    }
  }
}
