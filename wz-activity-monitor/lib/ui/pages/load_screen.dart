import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wzam/controllers/login_controller.dart';
import 'package:wzam/controllers/settings_controller.dart';
import 'package:wzam/services/audio_service.dart';
import 'package:wzam/services/app_update_service.dart';
import 'package:wzam/services/app_version_service.dart';
import 'package:wzam/services/auth_service.dart';
import 'package:wzam/services/file_storage.dart';
import 'package:wzam/services/secure_storage.dart';
import 'package:wzam/services/store_launcher_service.dart';
import 'package:wzam/services/shared_prefs.dart';
import 'package:wzam/ui/pages/login.dart';
import 'package:wzam/ui/styles/widgets/update_available_dialog.dart';

class Load extends StatelessWidget {
  const Load({super.key});

  Future _init() async {
    LoginController controller = Get.find<LoginController>();
    SharedPrefs sharedPrefs = Get.put(SharedPrefs());
    await controller.init();
    await sharedPrefs.setPrefs();

    AppVersionService appVersionService = Get.find<AppVersionService>();
    AppUpdateService appUpdateService = Get.find<AppUpdateService>();
    await appVersionService.init();
    await appUpdateService.init();

    if (appUpdateService.isBelowMinimum.value) {
      return;
    }

    if (appUpdateService.isBehindLatest.value) {
      final String? latestVersion = appUpdateService.latestVersion.value;
      if (latestVersion != null) {
        final String? lastSeen = await sharedPrefs.getLastSeenUpdateVersion();
        if (lastSeen != latestVersion) {
          await sharedPrefs.saveLastSeenUpdateVersion(latestVersion);
          await Get.dialog(
            UpdateAvailableDialog(latestVersion: latestVersion),
            barrierDismissible: false,
          );
        }
      }
    }

    await _handleLoginRedirect();
  }

  Future<void> _handleLoginRedirect() async {
    bool didRedirect = false;
    try {
      LoginController controller = Get.find<LoginController>();
      controller.usernameController.text =
          await controller.authService.getUsername();
      controller.passwordController.text =
          await controller.authService.getPassword();
      if (await controller.authService.isAccessTokenValid()) {
        await controller.onLogin(updateCredentials: false);
        didRedirect = true;
        return;
      }

      if (await controller.authService.isRefreshTokenValid()) {
        int responseCode = await controller.authService.refreshToken();
        if (responseCode == 200) {
          // If the refresh was successful, navigate to the home page (tokens are already cached)
          await controller.onLogin(updateCredentials: false);
          didRedirect = true;
          return;
        }
      }

      if (controller.passwordController.text.isNotEmpty &&
          controller.usernameController.text.isNotEmpty) {
        int responseCode = await controller.authService.authenticateUser(
          controller.usernameController.text,
          controller.passwordController.text,
        );
        if (responseCode == 200) {
          // If login is successful, navigate to the home page
          await controller.onLogin(updateCredentials: false);
          didRedirect = true;
          return;
        }
      }
    } finally {
      // If not logged in, navigate to the login page
      if (!didRedirect) {
        Get.offAll(LoginPage());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(SecureStorage());
    Get.put(AuthService());
    Get.put(LoginController());
    Get.put(SettingsController());
    Get.put(FileStorageService());
    Get.put(AudioService());
    Get.put(StoreLauncherService(), permanent: true);
    Get.put(AppVersionService(), permanent: true);
    Get.put(AppUpdateService(), permanent: true);
    return FutureBuilder(
        future: _init(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/load_screen.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: const Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        });
  }
}
