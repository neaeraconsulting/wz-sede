import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wzam/services/store_launcher_service.dart';

class UpdateAvailableDialog extends StatelessWidget {
  final String latestVersion;

  const UpdateAvailableDialog({super.key, required this.latestVersion});

  @override
  Widget build(BuildContext context) {
    final StoreLauncherService storeLauncherService =
        Get.find<StoreLauncherService>();

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.system_update_alt),
          SizedBox(width: 8),
          Text('Update Available'),
        ],
      ),
      content: Text(
        'Version $latestVersion is available. Would you like to update now?',
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Continue'),
        ),
        FilledButton(
          onPressed: () async {
            Get.back();
            final bool launched = await storeLauncherService.openUpdatePage();
            if (!launched) {
              Get.snackbar(
                'Update Unavailable',
                'Unable to open the app store link on this device.',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          child: const Text('Update Now'),
        ),
      ],
    );
  }
}
