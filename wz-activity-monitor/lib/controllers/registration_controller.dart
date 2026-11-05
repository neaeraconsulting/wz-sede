import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wzam/models/user_registration_request.dart';
import 'package:wzam/services/auth_service.dart';
import 'package:wzam/services/secure_storage.dart';
import 'package:wzam/services/wzam_api.dart';
import 'package:wzam/ui/pages/login.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class RegistrationController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();
  final TextEditingController messageController = TextEditingController();

  AuthService authService = Get.find<AuthService>();
  SecureStorage secureStorage = Get.find<SecureStorage>();

  Rx<bool> isLoading = false.obs;
  Rx<bool> profileEntered = false.obs;
  Rx<bool> loggedIn = false.obs;
  Rx<String?> errorMessage = Rx<String?>(null);
  Rx<bool> isFormValid = false.obs;
  Rx<bool> isWyoGovEmail = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(updateIsFormValid);
    phoneNumberController.addListener(updateIsFormValid);
    firstNameController.addListener(updateIsFormValid);
    lastNameController.addListener(updateIsFormValid);
    passwordController.addListener(updateIsFormValid);
    passwordConfirmationController.addListener(updateIsFormValid);
    messageController.addListener(updateIsFormValid);
  }

  String? validateEmail(String value) {
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value)) {
      return "Enter a valid email address";
    }
    return null;
  }

  String? validatePhone(String value) {
    // PhoneInputFormatter formats like '(123) 456 7890'
    final phoneRegex = RegExp(r'^\(\d{3}\) \d{3} \d{4}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Enter a valid phone number: (123) 456 7890';
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.length < 8) {
      return 'Must be at least 8 characters long.';
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Must include at least 1 lowercase letter.';
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Must include at least 1 uppercase letter.';
    }
    if (!RegExp(r'[@$!%*?&0-9]').hasMatch(password)) {
      return 'Must include at least 1 symbol (e.g., @, \$, !, %, *, ?, &).';
    }
    return null; // Password is valid
  }

  void updateIsFormValid() {
    isWyoGovEmail.value =
        emailController.text.toLowerCase().contains('@wyo.gov');
    isFormValid.value = checkIsFormValid();
  }

  bool checkIsFormValid() {
    print("Checking form valid");
    // Check if all required fields are not empty
    if (emailController.text.isEmpty ||
        firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        passwordController.text.isEmpty ||
        passwordConfirmationController.text.isEmpty ||
        messageController.text.isEmpty) {
      print("Something empty");
      return false;
    }
    if (validateEmail(emailController.text) != null) {
      print("invalid email");
      return false;
    }
    if (validatePhone(phoneNumberController.text) != null) {
      print("invalid phone - must be a valid phone number or blank");
      return false;
    }
    if (validatePassword(passwordController.text) != null) {
      print("invalid password");
      return false;
    }

    if (passwordController.text != passwordConfirmationController.text) {
      print("invalid confirmation password");
      return false;
    }
    return true;
  }

  Future<void> registerUser() async {
    String phoneNumberFormatted = phoneNumberController.text
        .replaceAll(' ', '')
        .replaceAll('(', '')
        .replaceAll(')', '');
    
    // Get platform string
    String platformString;
    if (kIsWeb) {
      platformString = 'Web';
    } else {
      if (Platform.isAndroid) {
        platformString = 'Android';
      } else if (Platform.isIOS) {
        platformString = 'iOS';
      } else if (Platform.isWindows) {
        platformString = 'Windows';
      } else if (Platform.isMacOS) {
        platformString = 'macOS';
      } else if (Platform.isLinux) {
        platformString = 'Linux';
      } else {
        platformString = 'Unknown';
      }
    }
    
    UserRegistrationRequest userRequest = UserRegistrationRequest(
        email: emailController.text,
        username: emailController.text,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        password: passwordController.text,
        phoneNumber: phoneNumberFormatted,
        message: messageController.text,
        platform: platformString);
    String? apiErrorMessage = await WzamApi.registerNewUser(userRequest);
    if (apiErrorMessage == null) {
      await authService.setUsername(emailController.text);
      await authService.setPassword(passwordController.text);
      Get.offAll(LoginPage());
    } else {
      errorMessage.value = apiErrorMessage;
    }
    // save username and password
  }
}
