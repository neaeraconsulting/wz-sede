import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wzam/app_config.dart';

class StoreLauncherService extends GetxService {
  Future<bool> openUpdatePage() async {
    final Uri? preferredUri = _getPreferredStoreUri();
    final Uri? fallbackUri = _getFallbackStoreUri();

    if (preferredUri != null && await launchUrl(preferredUri)) {
      return true;
    }

    if (fallbackUri != null && await launchUrl(fallbackUri)) {
      return true;
    }

    return false;
  }

  Uri? _getPreferredStoreUri() {
    if (kIsWeb) {
      return Uri.tryParse(AppConfig.androidStoreWebUrl);
    }

    if (Platform.isAndroid) {
      return Uri.tryParse('market://details?id=${AppConfig.androidApplicationId}');
    }

    if (Platform.isIOS) {
      return Uri.tryParse(AppConfig.iosStoreUrl);
    }

    return null;
  }

  Uri? _getFallbackStoreUri() {
    if (kIsWeb) {
      return Uri.tryParse(AppConfig.androidStoreWebUrl);
    }

    if (Platform.isAndroid) {
      return Uri.tryParse(AppConfig.androidStoreWebUrl);
    }

    if (Platform.isIOS) {
      return Uri.tryParse(AppConfig.iosStoreUrl);
    }

    return null;
  }
}
