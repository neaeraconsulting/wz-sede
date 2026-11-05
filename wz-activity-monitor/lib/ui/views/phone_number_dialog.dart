import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:get/get.dart';
import 'package:wzam/controllers/login_controller.dart';
import 'package:wzam/services/auth_service.dart';
import 'package:wzam/services/wzam_api.dart';
import 'package:wzam/ui/pages/login.dart';

class PhoneNumberDialog extends StatefulWidget {
  const PhoneNumberDialog({
    super.key,
    this.allowCancel = false,
  });

  final bool allowCancel;

  @override
  State<PhoneNumberDialog> createState() => _PhoneNumberDialogState();
}

class _PhoneNumberDialogState extends State<PhoneNumberDialog> {
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final phoneNumber =
        _phoneNumberController.text.replaceAll(RegExp(r'\D'), '');
    final updated = await WzamApi.updatePhoneNumber(phoneNumber);
    if (!mounted) return;

    if (!updated) {
      setState(() {
        _isSubmitting = false;
        _errorMessage = 'Unable to save your phone number. Please try again.';
      });
      return;
    }

    final authService = Get.find<AuthService>();
    final refreshStatus = await authService.refreshToken();
    if (!mounted) return;

    final accessToken = await authService.getAccessToken();
    final refreshedPhoneNumber = accessToken == null
        ? null
        : authService.getPhoneNumberFromToken(accessToken);

    if (refreshStatus != 200 ||
        refreshedPhoneNumber == null ||
        refreshedPhoneNumber.isEmpty) {
      setState(() {
        _isSubmitting = false;
        _errorMessage =
            'Your phone number was saved, but login could not be completed. Please try again.';
      });
      return;
    }

    Get.back(result: true);
  }

  Future<void> _logout() async {
    await Get.find<LoginController>().logout();
    Get.offAll(() => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add your phone number'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('A phone number is required to continue.'),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                PhoneInputFormatter(defaultCountryCode: 'US'),
              ],
              decoration: const InputDecoration(
                labelText: 'Phone number',
                hintText: '(123) 456 7890',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    !RegExp(r'^\(\d{3}\) \d{3} \d{4}$').hasMatch(value)) {
                  return 'Enter a valid phone number: (123) 456 7890';
                }
                return null;
              },
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting
              ? null
              : widget.allowCancel
                  ? () => Get.back(result: false)
                  : _logout,
          child: Text(widget.allowCancel ? 'Cancel' : 'Logout'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Submit'),
        ),
      ],
    );
  }
}
