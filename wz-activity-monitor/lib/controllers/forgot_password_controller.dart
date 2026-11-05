import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wzam/services/auth_service.dart';
import 'package:wzam/ui/pages/login.dart';

class ForgotPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  final AuthService _authService = Get.find<AuthService>();

  final RxBool isLoading = false.obs;
  final RxBool isStep2 = false.obs;
  final Rx<String?> errorMessage = Rx<String?>(null);
  final Rx<String?> infoMessage = Rx<String?>(null);

  Future<void> submitEmail() async {
    isLoading.value = true;
    errorMessage.value = null;

    final code = await _authService.forgotPassword(emailController.text.trim());

    isLoading.value = false;

    if (code == 408) {
      errorMessage.value = 'Request timed out - check your connection';
      return;
    }

    // Always advance to step 2 regardless of whether the email exists,
    // to prevent user enumeration.
    infoMessage.value =
        'If an account with that email exists, a verification code has been sent.';
    isStep2.value = true;
  }

  Future<void> submitReset() async {
    isLoading.value = true;
    errorMessage.value = null;

    final code = await _authService.resetPassword(
      email: emailController.text.trim(),
      code: otpController.text.trim(),
      newPassword: newPasswordController.text,
    );

    isLoading.value = false;

    switch (code) {
      case 200:
      case 201:
      case 202:
      case 204:
        Get.offAll(() => LoginPage());
        break;
      case 408:
        errorMessage.value = 'Request timed out - check your connection';
        break;
      default:
        errorMessage.value = 'Invalid code or the code has expired';
        break;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    super.onClose();
  }
}
