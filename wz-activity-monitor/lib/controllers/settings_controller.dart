import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wzam/controllers/login_controller.dart';
import 'package:wzam/controllers/notification_controller.dart';
import 'package:wzam/services/file_storage.dart';
import 'package:wzam/services/secure_storage.dart';
import 'package:wzam/services/sembast_service.dart';
import 'package:wzam/services/shared_prefs.dart';
import 'package:wzam/ui/pages/login.dart';

class SettingsController extends GetxController {
  SettingsController();
  SharedPrefs sharedPrefs = SharedPrefs();
  SecureStorage secureStorage = SecureStorage();
  LoginController loginController = Get.find<LoginController>();

  Rx<bool> darkModeState = Get.isDarkMode.obs;
  Rx<bool> voiceCommandState = true.obs;
  Rx<bool> showRecordingMap = false.obs;

  RxString username = ''.obs;
  RxString password = ''.obs;
  RxString phoneNumber = ''.obs;
  RxBool settingsChanged = false.obs;
  RxBool canChangePassword = false.obs;
  Rx<String?> authSource = Rx<String?>(null);

  String? get accountSourceLabel {
    switch (authSource.value) {
      case 'keycloak':
        return 'Local';
      case 'ldap':
        return 'ETS';
      default:
        return null;
    }
  }

  initialize() async {
    voiceCommandState.value =
        await sharedPrefs.getVoiceCommandsEnabled() ?? true;
    showRecordingMap.value =
        await sharedPrefs.getShowRecordingMapEnabled() ?? false;
    username.value = await secureStorage.getUsername();
    password.value = await secureStorage.getPassword();
    final accessToken = await loginController.authService.getAccessToken();
    phoneNumber.value = accessToken == null
        ? ''
        : loginController.authService.getPhoneNumberFromToken(accessToken) ??
            '';
    authSource.value = accessToken == null
        ? null
        : loginController.authService
            .getAuthSourceFromToken(accessToken)
            ?.toLowerCase();
    canChangePassword.value = authSource.value == 'keycloak';
    bool? darkMode = await sharedPrefs.getDarkModeFromPrefs();
    if (darkMode != null) {
      if (darkMode) {
        Get.changeThemeMode(ThemeMode.dark);
        darkModeState.value = true;
      } else {
        Get.changeThemeMode(ThemeMode.light);
        darkModeState.value = false;
      }
    } else {
      Get.changeThemeMode(ThemeMode.system);
      darkModeState.value = Get.isDarkMode;
    }
  }

  Future<void> refreshPhoneNumber() async {
    final accessToken = await loginController.authService.getAccessToken();
    phoneNumber.value = accessToken == null
        ? ''
        : loginController.authService.getPhoneNumberFromToken(accessToken) ??
            '';
  }

  Future logout() async {
    await loginController.logout();
    Get.offAll(() => LoginPage());
  }

  @override
  void onInit() async {
    await initialize();
    super.onInit();
  }

  void switchModeState() async {
    darkModeState.value = !darkModeState.value;
    if (darkModeState.value) {
      Get.changeThemeMode(ThemeMode.dark);
      await sharedPrefs.saveDarkModeToPrefs(darkModeState.value);
    } else {
      Get.changeThemeMode(ThemeMode.light);
      await sharedPrefs.saveDarkModeToPrefs(darkModeState.value);
    }
  }

  void switchVoiceCommandState(bool value) async {
    voiceCommandState.value = value;
    await sharedPrefs.saveVoiceCommandsEnabled(value);
  }

  void switchShowRecordingMapState(bool value) async {
    showRecordingMap.value = value;
    await sharedPrefs.saveShowRecordingMapEnabled(value);
  }

  void clearLocalReportRecordingData() async {
    FileStorageService fileService = Get.find<FileStorageService>();
    await fileService.clearLocalReports();
    await fileService.clearLocalRecordings();
    await fileService.refreshLocalUploadState();
  }

  void clearDb() async {
    SembastService sembastService = Get.find<SembastService>();
    sembastService.removeAllBoxes();
  }

  void deleteUserAccount() async {
    loginController.authService.deleteUserAccount().then((statusCode) {
      if (statusCode == 200 || statusCode == 204) {
        NotificationController().queueNotification(
            'Success', 'User account deleted successfully',
            severity: NotificationSeverity.success);
        Get.snackbar('Success', 'User account deleted successfully',
            snackPosition: SnackPosition.BOTTOM);
        logout();
      } else {
        NotificationController().queueNotification(
            'Error', 'Failed to delete user account: $statusCode');
      }
    }).catchError((error) {
      NotificationController().queueNotification(
          'Error', 'An error occurred while deleting the account');
    });
  }
}
