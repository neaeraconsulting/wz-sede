import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wzam/controllers/login_controller.dart';
import 'package:wzam/services/auth_service.dart';
import 'package:wzam/ui/pages/forgot_password_page.dart';
import 'package:wzam/ui/pages/registration_page.dart';
import 'package:wzam/ui/pages/settings.dart';
import 'package:wzam/ui/styles/screen_size.dart';
import 'package:wzam/ui/styles/spacing.dart';
import 'package:wzam/ui/styles/widgets/wzam_input.dart';

class LoginPage extends StatelessWidget {
  final LoginController _controller = Get.find<LoginController>();
  final AuthService authController = Get.find<AuthService>();
  LoginPage({super.key});

  final profileName = TextEditingController();
  final profileKeycloak = TextEditingController();
  final profileCimms = TextEditingController();
  final profileRealm = TextEditingController();
  final profileClient = TextEditingController();
  final profileClientSecret = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.init();
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
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
            child: Column(
              children: [
                AutofillGroup(
                  // This is necessary to get the email and password to autofill together
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/wzam_abr.png', scale: 3),
                        verticalSpaceLarge,
                        WZAMInputField(
                          controller: _controller.usernameController,
                          keyboardType: TextInputType.emailAddress,
                          placeholder: 'Username',
                          autofillHints: const [
                            AutofillHints.email,
                            AutofillHints.username
                          ],
                        ),
                        verticalSpaceMedium,
                        WZAMInputField(
                          controller: _controller.passwordController,
                          placeholder: 'Password',
                          password: true,
                          autofillHints: const [AutofillHints.password],
                        ),
                        verticalSpaceSmall,
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            'Wyo.gov users should log in with their ETS credentials and do not need to register.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        verticalSpaceSmall,
                        SizedBox(
                          width: screenWidthPercentage(context, percentage: 0.75),
                          child: InkWell(
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            onTap: () => Get.to(() => RegistrationPage()),
                          ),
                        ),
                        SizedBox(
                          width: screenWidthPercentage(context, percentage: 0.75),
                          child: InkWell(
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            onTap: () => Get.to(() => ForgotPasswordPage()),
                          ),
                        ),
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
                          width: screenWidthPercentage(context, percentage: 0.5),
                          child: ElevatedButton(
                            child: const Text('Log In'),
                            onPressed: () async {
                              await _controller.login();
                            },
                          ),
                        ),
                        Obx(
                          () => (_controller.hasSavedTokens.value &&
                                  _controller.didTimeOut.value)
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: SizedBox(
                                    width: screenWidthPercentage(context,
                                        percentage: 0.5),
                                    child: ElevatedButton(
                                      // This button allows an offline device with expired credentials
                                      // to continue past the login page. This does not pose significant
                                      // security risks, as the user will not be able to retrieve or
                                      // upload to the Datahub without regenerating their credentials
                                      child: const Text('Continue offline'),
                                      onPressed: () async {
                                        await _controller.onLogin(
                                            updateCredentials: false);
                                      },
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        )
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
