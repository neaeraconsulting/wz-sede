import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wzam/services/store_launcher_service.dart';

class UpdateRequiredPage extends StatelessWidget {
  const UpdateRequiredPage({super.key});

  @override
  Widget build(BuildContext context) {
    final StoreLauncherService storeLauncherService =
        Get.find<StoreLauncherService>();

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Update Application'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.system_update_alt, size: 72),
                const SizedBox(height: 16),
                const Text(
                  'A new app version is required to continue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Please update from your app store to keep using WZAM.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 220,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final bool launched =
                          await storeLauncherService.openUpdatePage();
                      if (!launched) {
                        Get.snackbar(
                          'Update Unavailable',
                          'Unable to open the app store link on this device.',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Update Application'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
