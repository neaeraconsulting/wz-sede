import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wzam/app_config.dart';
import 'package:wzam/services/app_version_service.dart';
import 'package:wzam/ui/pages/update_required_page.dart';

class AppUpdateService extends GetxService {
  final RxnString minimumVersion = RxnString();
  final RxnString latestVersion = RxnString();
  final RxBool isBelowMinimum = false.obs;
  final RxBool isBehindLatest = false.obs;
  final RxBool isChecking = false.obs;
  final Rxn<DateTime> lastCheckedAt = Rxn<DateTime>();

  Timer? _timer;
  bool _hardUpdateTriggered = false;

  Future<AppUpdateService> init() async {
    await refreshVersionPolicy();
    _startPeriodicChecks();
    return this;
  }

  void _startPeriodicChecks() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(hours: 6), (_) async {
      await refreshVersionPolicy();
    });
  }

  Future<void> refreshVersionPolicy() async {
    if (isChecking.value) return;
    isChecking.value = true;

    try {
      final appVersionService = Get.find<AppVersionService>();
      final String appSemver = await appVersionService
          .getSemver()
          .timeout(const Duration(seconds: 3), onTimeout: () => '0.0.0');

      final response = await http
          .get(
            Uri.parse(AppConfig.versionCheckEndpoint),
            headers: {
              'Content-Type': 'application/json',
              'X-App-Version': appSemver,
            },
          )
          .timeout(
        const Duration(seconds: 5),
            onTimeout: () => http.Response('Timeout', 408),
          );

      if (response.statusCode == 426) {
        await enforceHardUpdate();
        return;
      }

      if (response.statusCode != 200) {
        return;
      }

      final dynamic decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return;
      }

      final String? newMinimumVersion = decoded['minimum_version'] as String?;
      final String? newLatestVersion = decoded['latest_version'] as String?;

      if (!_isSemver(newMinimumVersion) || !_isSemver(newLatestVersion)) {
        return;
      }

      minimumVersion.value = newMinimumVersion;
      latestVersion.value = newLatestVersion;
      lastCheckedAt.value = DateTime.now();

      final bool belowMinimum =
          _compareSemver(appSemver, newMinimumVersion!) < 0;
      final bool behindLatest = _compareSemver(appSemver, newLatestVersion!) < 0;

      isBelowMinimum.value = belowMinimum;
      isBehindLatest.value = behindLatest;

      if (belowMinimum) {
        await enforceHardUpdate();
      }
    } on SocketException catch (_) {
      // Ignore transient network failures for soft reminders.
    } on FormatException catch (_) {
      // Ignore malformed version payloads and fail open.
    } catch (e) {
      // Fail open on any other error (HTTP client, TLS, etc.) so startup continues.
      debugPrint('AppUpdateService: version check failed: $e');
    } finally {
      isChecking.value = false;
    }
  }

  Future<void> enforceHardUpdate() async {
    if (_hardUpdateTriggered) {
      return;
    }

    _hardUpdateTriggered = true;
    isBelowMinimum.value = true;
    isBehindLatest.value = true;

    Get.offAll(() => const UpdateRequiredPage());
  }

  bool _isSemver(String? value) {
    return value != null && RegExp(r'^\d+\.\d+\.\d+$').hasMatch(value);
  }

  int _compareSemver(String left, String right) {
    final List<int> leftParts = left.split('.').map(int.parse).toList();
    final List<int> rightParts = right.split('.').map(int.parse).toList();

    for (int i = 0; i < 3; i++) {
      if (leftParts[i] < rightParts[i]) return -1;
      if (leftParts[i] > rightParts[i]) return 1;
    }

    return 0;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
