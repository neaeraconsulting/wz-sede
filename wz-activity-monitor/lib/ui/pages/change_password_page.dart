import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wzam/services/auth_service.dart';
import 'package:wzam/ui/styles/widgets/wzam_app_bar.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final RxBool _isSubmitting = false.obs;
  final RxBool _showNewPassword = false.obs;
  final RxBool _showConfirmPassword = false.obs;
  late final Future<bool> _canChangePasswordFuture;

  @override
  void initState() {
    super.initState();
    _canChangePasswordFuture = _checkCanChangePassword();
  }

  Future<bool> _checkCanChangePassword() async {
    final authService = Get.find<AuthService>();
    final accessToken = await authService.getAccessToken();
    return accessToken != null &&
        authService.getAuthSourceFromToken(accessToken)?.toLowerCase() ==
            'keycloak';
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a new password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  Future<void> _showSnackBar({
    required String message,
    required Color backgroundColor,
  }) async {
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    await messenger
        .showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: backgroundColor,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        )
        .closed;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _isSubmitting.value = true;
    final authService = Get.find<AuthService>();

    final statusCode = await authService.changePassword(
      newPassword: _newPasswordController.text.trim(),
    );

    _isSubmitting.value = false;

    if (statusCode == 200 ||
        statusCode == 201 ||
        statusCode == 202 ||
        statusCode == 204) {
      await authService.setPassword(_newPasswordController.text.trim());
      await _showSnackBar(
        message: 'Password changed successfully',
        backgroundColor: Colors.green.shade700,
      );
      if (!mounted) return;
      Get.back();
      return;
    }

    String errorMessage;
    switch (statusCode) {
      case 400:
        errorMessage = 'Invalid password format. Please review requirements.';
        break;
      case 401:
      case 403:
        errorMessage = 'Your session has expired. Please sign in again.';
        break;
      case 408:
        errorMessage =
            'Request timed out. Check your connection and try again.';
        break;
      default:
        errorMessage = 'Failed to change password (code: $statusCode)';
    }

    await _showSnackBar(
      message: errorMessage,
      backgroundColor: Colors.red.shade700,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WZAMAppBar(
        title: 'Change Password',
        settings: true,
      ),
      body: FutureBuilder<bool>(
        future: _canChangePasswordFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                  'Unable to verify whether password changes are allowed.'),
            );
          }
          if (snapshot.data != true) {
            return const Center(
              child:
                  Text('Password changes are not available for this account.'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Obx(
                    () => TextFormField(
                      controller: _newPasswordController,
                      obscureText: !_showNewPassword.value,
                      onChanged: (_) {
                        if (_confirmPasswordController.text.isNotEmpty) {
                          _formKey.currentState?.validate();
                        }
                      },
                      autofillHints: const [AutofillHints.newPassword],
                      decoration: InputDecoration(
                        labelText: 'New password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showNewPassword.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            _showNewPassword.toggle();
                          },
                        ),
                      ),
                      validator: _validateNewPassword,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_showConfirmPassword.value,
                      decoration: InputDecoration(
                        labelText: 'Confirm new password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showConfirmPassword.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            _showConfirmPassword.toggle();
                          },
                        ),
                      ),
                      validator: (value) {
                        final validation = _validateNewPassword(value);
                        if (validation != null) return validation;
                        if (value != _newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Obx(
                    () => ElevatedButton(
                      onPressed: _isSubmitting.value ? null : _submit,
                      child: _isSubmitting.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Update Password'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
