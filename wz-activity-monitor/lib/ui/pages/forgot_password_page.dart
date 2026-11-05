import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wzam/controllers/forgot_password_controller.dart';
import 'package:wzam/ui/styles/spacing.dart';
import 'package:wzam/ui/styles/widgets/wzam_input.dart';
import 'package:wzam/ui/views/support_request_dialog.dart';

class ForgotPasswordPage extends StatelessWidget {
  final ForgotPasswordController _controller =
      Get.put(ForgotPasswordController(), permanent: false);

  ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Obx(() {
              final isStep2 = _controller.isStep2.value;
              final isLoading = _controller.isLoading.value;
              final errorMessage = _controller.errorMessage.value;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/wzam_abr.png', scale: 3),
                  verticalSpaceLarge,
                  if (!isStep2) ...[
                    const Text(
                      'Enter your email address and we\'ll send you a code to reset your password.',
                      textAlign: TextAlign.center,
                    ),
                    verticalSpaceMedium,
                    WZAMInputField(
                      controller: _controller.emailController,
                      placeholder: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                    ),
                  ] else ...[
                    Obx(() {
                      final info = _controller.infoMessage.value;
                      return info != null
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Text(
                                info,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.green),
                              ),
                            )
                          : const SizedBox.shrink();
                    }),
                    WZAMInputField(
                      controller: _controller.otpController,
                      placeholder: '6-digit code',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                    ),
                    verticalSpaceMedium,
                    WZAMInputField(
                      controller: _controller.newPasswordController,
                      placeholder: 'New Password',
                      password: true,
                      autofillHints: const [AutofillHints.newPassword],
                    ),
                    verticalSpaceSmall,
                    InkWell(
                      onTap: () => Get.dialog(SupportRequestDialog(
                        initialSubject: 'Password Reset Help',
                        initialMessage:
                            'I am having trouble resetting my password.',
                      )),
                      child: const Text(
                        'Contact Support',
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                  if (isLoading) ...[
                    verticalSpaceMedium,
                    const CircularProgressIndicator(),
                  ] else ...[
                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          errorMessage,
                          style: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    verticalSpaceLarge,
                    ElevatedButton(
                      onPressed: isStep2
                          ? _controller.submitReset
                          : _controller.submitEmail,
                      child: Text(isStep2 ? 'Reset Password' : 'Send Code'),
                    ),
                  ],
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
