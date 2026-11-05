import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:get/get.dart';
import 'package:wzam/controllers/registration_controller.dart';
import 'package:wzam/ui/pages/settings.dart';
import 'package:wzam/ui/styles/spacing.dart';
import 'package:wzam/ui/styles/widgets/wzam_input.dart';

class RegistrationPage extends StatelessWidget {
  final RegistrationController _controller =
      Get.put(RegistrationController(), permanent: false);
  RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    Rx<String?> passwordConfirmationErrorMessage = Rx<String?>(null);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Get.to(() => SettingsPage());
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AutofillGroup(
              // This is necessary to get the email and password to autofill together
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/wzam_abr.png', scale: 3),
                    verticalSpaceLarge,
                    WZAMInputField(
                      controller: _controller.emailController,
                      placeholder: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validateInput: _controller.validateEmail,
                      autofillHints: const [AutofillHints.newUsername],
                    ),
                    verticalSpaceMedium,
                    WZAMInputField(
                      controller: _controller.passwordController,
                      placeholder: 'Password',
                      validateInput: (value) {
                        String? passwordError =
                            _controller.validatePassword(value);

                        if (_controller
                            .passwordConfirmationController.text.isNotEmpty) {
                          // Re-validate confirmation whenever the main password changes.
                          passwordConfirmationErrorMessage.value = value !=
                                  _controller
                                      .passwordConfirmationController.text
                              ? 'Password confirmation does not match'
                              : null;
                        }
                        // return the validation result for the password field
                        return passwordError;
                      },
                      password: true,
                      autofillHints: const [AutofillHints.password],
                    ),
                    verticalSpaceMedium,
                    WZAMInputField(
                        controller: _controller.passwordConfirmationController,
                        placeholder: 'Confirm Password',
                        validateInput: (value) =>
                            value != _controller.passwordController.text
                                ? 'Password confirmation does not match'
                                : null,
                        errorMessage: passwordConfirmationErrorMessage,
                        password: true),
                    verticalSpaceMedium,
                    WZAMInputField(
                      controller: _controller.firstNameController,
                      keyboardType: TextInputType.name,
                      placeholder: 'First Name',
                      textCapitalization: TextCapitalization.words,
                    ),
                    verticalSpaceMedium,
                    WZAMInputField(
                      controller: _controller.lastNameController,
                      keyboardType: TextInputType.name,
                      placeholder: 'Last Name',
                      textCapitalization: TextCapitalization.words,
                    ),
                    verticalSpaceMedium,
                    WZAMInputField(
                      controller: _controller.phoneNumberController,
                      placeholder: 'Phone Number',
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        PhoneInputFormatter(
                          defaultCountryCode:
                              'US', // Set your default country code
                        ),
                      ],
                      validateInput: _controller.validatePhone,
                    ),
                    verticalSpaceMedium,
                    WZAMInputField(
                      controller: _controller.messageController,
                      placeholder: 'Organization or Reason',
                      keyboardType: TextInputType.text,
                    ),
                    verticalSpaceSmall,
                    Obx(() {
                      final isLoading = _controller.isLoading.value;
                      if (isLoading) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: CircularProgressIndicator(),
                        );
                      }
                      final errorMessage = _controller.errorMessage.value;
                      return errorMessage == null
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                errorMessage,
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ));
                    }),
                    verticalSpaceLarge,
                    SizedBox(
                      child: Obx(() => ElevatedButton(
                            onPressed: _controller.isFormValid.value
                                ? _controller.registerUser
                                : null, // Disable button if form is invalid
                            child: const Text('Create Account',
                                style: TextStyle(
                                  fontSize: 18,
                                )),
                          )),
                    ),
                    Obx(
                      () => _controller.isWyoGovEmail.value
                          ? const Padding(
                              padding: EdgeInsets.only(top: 16.0),
                              child: Text(
                                'Wyo.gov users should log in with their ETS credentials and do not need to register.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
