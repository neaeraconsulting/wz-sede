import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wzam/controllers/settings_controller.dart';
import 'package:wzam/models/support_request.dart';
import 'package:wzam/services/wzam_api.dart';

class SupportRequestDialog extends StatelessWidget {
  final String? initialSubject;
  final String? initialMessage;

  SupportRequestDialog({
    super.key,
    this.initialSubject,
    this.initialMessage,
  });

  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Set initial values if provided
    if (initialSubject != null) {
      subjectController.text = initialSubject!;
    }
    if (initialMessage != null) {
      messageController.text = initialMessage!;
    }

    return AlertDialog(
      title: const Text('Submit Feedback'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Please describe your issue or feature request',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                hintText: 'Brief summary',
                border: OutlineInputBorder(),
              ),
              maxLength: 100,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              decoration: const InputDecoration(
                labelText: 'Message',
                hintText: 'Detailed description',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 6,
              maxLength: 1000,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: () async {
            final subject = subjectController.text.trim();
            final message = messageController.text.trim();

            // Validate inputs
            if (subject.isEmpty) {
              Get.snackbar(
                'Missing Information',
                'Please enter a subject',
                backgroundColor: Colors.orange,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
              return;
            }

            if (message.isEmpty) {
              Get.snackbar(
                'Missing Information',
                'Please enter a message',
                backgroundColor: Colors.orange,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
              return;
            }

            // Close dialog
            Get.back();

            // Show loading indicator
            Get.dialog(
              const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Submitting support request...'),
                      ],
                    ),
                  ),
                ),
              ),
              barrierDismissible: false,
            );

            try {
              // Get username from settings
              final SettingsController settingsController = Get.find<SettingsController>();
              final username = settingsController.username.value;

              // Create and submit support request
              final supportRequest = SupportRequest(
                username: username,
                subject: subject,
                message: message,
              );

              await WzamApi.submitSupportRequest(supportRequest);

              // Close loading indicator
              Get.back();

              // Show success message
              Get.snackbar(
                'Success',
                'Your support request has been submitted. Our team will respond soon.',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 4),
                icon: const Icon(Icons.check_circle, color: Colors.white),
              );
            } catch (e) {
              // Close loading indicator
              Get.back();

              // Show error message
              Get.snackbar(
                'Error',
                'Failed to submit support request. Please try again later.',
                backgroundColor: Colors.red,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 4),
                icon: const Icon(Icons.error, color: Colors.white),
              );

              print('Error submitting support request: $e');
            }
          },
          icon: const Icon(Icons.send),
          label: const Text('Submit'),
        ),
      ],
    );
  }
}
