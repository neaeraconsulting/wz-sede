import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wzam/controllers/dashboard_controller.dart';
import 'package:wzam/controllers/mile_marker_controller.dart';
import 'package:wzam/controllers/reports_controller.dart';
import 'package:wzam/controllers/view_recordings_controller.dart';
import 'package:wzam/controllers/work_zone_map_controller.dart';
import 'package:wzam/services/audio_service.dart';
import 'package:wzam/services/auth_service.dart';
import 'package:wzam/services/cache_service.dart';
import 'package:wzam/services/foreground_location_service.dart';
import 'package:wzam/services/location_service.dart';
import 'package:wzam/services/push_notification_service.dart';
import 'package:wzam/services/secure_storage.dart';
import 'package:wzam/services/sembast_service.dart';
import 'package:wzam/services/voice_commands/speech_service.dart';
import 'package:wzam/services/voice_commands/voice_command_service.dart';
import 'package:wzam/services/wake_word_detection/wake_word_service.dart';
import 'package:wzam/ui/pages/dashboard/dashboard.dart';
import 'package:wzam/ui/pages/home.dart';
import 'package:wzam/ui/pages/request_access_page.dart';
import 'package:wzam/ui/views/phone_number_dialog.dart';

class LoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final testController = TextEditingController();

  AuthService authService = Get.put(AuthService());
  SecureStorage secureStorage = Get.find<SecureStorage>();

  Rx<bool> isLoading = false.obs;
  Rx<bool> profileEntered = false.obs;
  Rx<bool> loggedIn = false.obs;
  Rx<bool> didTimeOut = false.obs;
  Rx<bool> hasSavedTokens = false.obs;
  Rx<String?> errorMessage = Rx<String?>(null);

  LoginController();

  Future<void> init() async {
    Get.clearRouteTree();
    hasSavedTokens.value = await authService.getAccessToken() != null;
  }

  Future login() async {
    bool success = false;
    isLoading.value = true;
    errorMessage.value = null;

    try {
      await authService
          .authenticateUser(usernameController.text, passwordController.text)
          .then((code) {
        switch (code) {
          case 200:
            success = true;
            didTimeOut.value = false;
            break;
          case 401:
            errorMessage.value = 'Invalid username or password';
            didTimeOut.value = false;
            break;
          case 403:
            errorMessage.value = 'Access Denied - Contact Admin';
            didTimeOut.value = false;
            break;
          case 408:
            errorMessage.value = 'Request Timed Out - Check Connection';
            didTimeOut.value = true;
            break;
          default:
            errorMessage.value = 'Unknown error: $code';
            didTimeOut.value = false;
            break;
        }
      });
      if (success) {
        errorMessage.value = null;
        await onLogin();
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      didTimeOut.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> validateTokenRoles() async {
    String? accessToken = await authService.getAccessToken();
    if (accessToken != null) {
      List<String> roles = authService.getRolesFromToken(accessToken);
      if (roles.contains('ROLE_USER') || roles.contains('ROLE_ADMIN')) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<String?> getPhoneNumberFromToken() async {
    String? accessToken = await authService.getAccessToken();
    if (accessToken != null) {
      return authService.getPhoneNumberFromToken(accessToken);
    }
    return null;
  }

  Future onLogin({bool updateCredentials = true}) async {
    if (updateCredentials) {
      await authService.setPassword(passwordController.text);
      await authService.setUsername(usernameController.text);
    }
    // Verify phone number is set
    String? phoneNumber = await getPhoneNumberFromToken();
    if (phoneNumber == null || phoneNumber.isEmpty) {
      final submitted = await Get.dialog<bool>(
        const PhoneNumberDialog(),
        barrierDismissible: false,
      );
      if (submitted != true) return;

      phoneNumber = await getPhoneNumberFromToken();
      if (phoneNumber == null || phoneNumber.isEmpty) return;
    }
    // check that token contains ROLE_USER, ROLE_OPERATOR, or ROLE_ADMIN
    bool valid = await validateTokenRoles();
    if (valid) {
      await _onLoginAuthorized();
    } else {
      Get.to(RequestAccessPage());
    }
  }

  Future _onLoginAuthorized() async {
    Get.put(LocationService());
    Get.put(ForegroundLocationService());
    print("MobileVehicleMapController initialized in LoginController");
    Get.put(AudioService());
    Get.put(SpeechService());
    Get.put(WakeWordService(), permanent: true);
    Get.put(VoiceCommandService());
    Get.put(MileMarkerController(), permanent: true);
    Get.put(SembastService());
    Get.put(CacheService());
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      PushNotificationService pushNotificationService =
        Get.put(PushNotificationService());
        pushNotificationService.init();
        ViewRecordingsController viewRecordingsController =
        Get.put(ViewRecordingsController(), permanent: true);
        viewRecordingsController.loadInRecordings();
        viewRecordingsController.unUploadedRecordings.isNotEmpty
            ? pushNotificationService.showSimpleNotification(
                title: 'Local Reports or Recordings',
                body:
                    'You have local reports or recordings that need to be uploaded.',
                payload: 'Local Reports or Recordings',
                id: 1,
              )
            : null;
    }
    // PushNotificationService pushNotificationService =
    //     Get.put(PushNotificationService());
    // pushNotificationService.init();
    loggedIn.value = true;
    (!kIsWeb && (Platform.isAndroid || Platform.isIOS))
        ? Get.offAll(() => Home())
        : Get.offAll(() => const Dashboard());
    //Get.offAll(() => Home());
    Get.put(ReportsController(), permanent: true);
    Get.put(WorkZoneMapController(), permanent: true);
    Get.put(DashboardController(), permanent: true);
  }

  Future logout() async {
    await authService.logoutUser();
    await authService.clear();
    usernameController.clear();
    passwordController.clear();
    loggedIn.value = false;
  }
}
