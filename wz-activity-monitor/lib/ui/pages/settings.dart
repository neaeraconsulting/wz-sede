import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wzam/app_config.dart';
import 'package:wzam/controllers/login_controller.dart';
import 'package:wzam/controllers/settings_controller.dart';
import 'package:wzam/services/app_update_service.dart';
import 'package:wzam/services/store_launcher_service.dart';
import 'package:wzam/ui/pages/change_password_page.dart';
import 'package:wzam/ui/pages/voice_overlay.dart';
import 'package:wzam/ui/styles/spacing.dart';
import 'package:wzam/ui/styles/widgets/wzam_app_bar.dart';
import 'package:wzam/ui/views/phone_number_dialog.dart';
import 'package:wzam/ui/views/support_request_dialog.dart';

class SettingsPage extends StatelessWidget {
  final SettingsController controller = Get.find<SettingsController>();
  final LoginController loginController = Get.find<LoginController>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: controller.initialize(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          usernameController.text = controller.username.value;
          passwordController.text = controller.password.value;
          return Scaffold(
              appBar: const WZAMAppBar(
                title: "Settings Page",
                settings: true,
              ),
              body: Obx(
                () => Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ListView(
                      children: loginController.loggedIn.value
                          ? [
                              _accountSection(),
                              verticalSpaceMedium,
                              _logoutButton(),
                              verticalSpaceMedium,
                              _appearanceSection(),
                              verticalSpaceMedium,
                              _voiceCommandSection(),
                              verticalSpaceMedium,
                              _feedbackSection(context),
                              verticalSpaceMedium,
                              _versionSection(),
                              verticalSpaceMedium,
                              _dangerZoneSection(),
                            ]
                          : [
                              _appearanceSection(),
                              verticalSpaceMedium,
                              _feedbackSection(context),
                              verticalSpaceMedium,
                              _versionSection(),
                            ]),
                ),
              ));
        });
  }

  Widget _accountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headerElement(
          "Account",
          Icons.person,
          trailing: Obx(() {
            final label = controller.accountSourceLabel;
            if (label == null) return const SizedBox.shrink();
            return Chip(
              label: Text(label),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
            );
          }),
        ),
        TextField(
          decoration: const InputDecoration(labelText: 'Username'),
          controller: usernameController,
          readOnly: true,
          onChanged: (value) async {
            if (value != controller.username.value) {
              controller.settingsChanged.value = true;
            }
          },
        ),
        verticalSpaceMedium,
        TextField(
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
          controller: passwordController,
          readOnly: true,
          onChanged: (value) async {
            if (value != controller.password.value) {
              controller.settingsChanged.value = true;
            }
          },
        ),
        if (controller.canChangePassword.value) ...[
          verticalSpaceMedium,
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () {
                Get.to(() => const ChangePasswordPage());
              },
              icon: const Icon(Icons.lock_outline),
              label: const Text('Change Password'),
            ),
          ),
          verticalSpaceMedium,
        ],
        Obx(
          () => Text(
            'Phone Number: ${controller.phoneNumber.value.isEmpty ? 'Not set' : controller.phoneNumber.value}',
          ),
        ),
        verticalSpaceSmall,
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () async {
              final updated = await Get.dialog<bool>(
                const PhoneNumberDialog(allowCancel: true),
                barrierDismissible: false,
              );
              if (updated == true) {
                await controller.refreshPhoneNumber();
              }
            },
            icon: const Icon(Icons.phone),
            label: const Text('Change Phone Number'),
          ),
        ),
        verticalSpaceMedium,
      ],
    );
  }

  Widget _appearanceSection() {
    return Column(
      children: [
        _headerElement("Appearance", Icons.image),
        _appearanceSettings(),
      ],
    );
  }

  Widget _appearanceSettings() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            SwitchListTile(
                title: const Text("Dark Mode"),
                value: controller.darkModeState.value,
                onChanged: (value) {
                  controller.switchModeState();
                }),
            SwitchListTile(
                title: const Text("Show Map while Recording"),
                value: controller.showRecordingMap.value,
                onChanged: (value) {
                  controller.switchShowRecordingMapState(value);
                }),
          ],
        ));
  }

  Widget _dangerZoneSection() {
    return Column(
      children: [
        _dangerZoneHeaderElement("Danger Zone", Icons.warning_rounded),
        _dangerZoneSettings(),
      ],
    );
  }

  Widget _versionSection() {
    final AppUpdateService appUpdateService = Get.find<AppUpdateService>();
    final StoreLauncherService storeLauncherService =
        Get.find<StoreLauncherService>();
    final bool isDev = AppConfig.apiBaseUrl.contains('/dev/');

    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final packageInfo = snapshot.data!;
          return Column(
            children: [
              Column(
                children: [
                  Row(children: [
                    const Icon(Icons.info_outline, color: Colors.orange),
                    const SizedBox(width: 10),
                    Text(
                      'App Version: ${packageInfo.version}+${packageInfo.buildNumber}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (isDev) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'DEV',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ]),
                  const Divider(height: 20, thickness: 1),
                ],
              ),
              Obx(
                () => appUpdateService.isBehindLatest.value &&
                        !appUpdateService.isBelowMinimum.value
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
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
                          icon: const Icon(Icons.system_update_alt),
                          label: const Text('Update Application'),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          );
        }
        return Column(
          children: [
            _headerElement("App Version", Icons.info_outline),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
        );
      },
    );
  }

  Widget _feedbackSection(BuildContext context) {
    return Column(
      children: [
        _headerElement("Feedback", Icons.feedback),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ElevatedButton.icon(
            onPressed: () {
              Get.dialog(SupportRequestDialog());
            },
            icon: const Icon(Icons.feedback),
            label: const Text("Provide Feedback"),
          ),
        ),
      ],
    );
  }

  Widget _dangerZoneSettings() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                // Show a GetX confirmation dialog
                Get.defaultDialog(
                  title: "Confirm Deletion",
                  middleText:
                      "Are you sure you want to delete all local reports and recordings? This action cannot be undone.",
                  textCancel: "Cancel",
                  textConfirm: "Delete",
                  confirmTextColor: Colors.white,
                  onCancel: () {
                    // Do nothing if canceled
                  },
                  onConfirm: () {
                    controller.clearLocalReportRecordingData();
                    Get.back(); // Close the dialog
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700], // Change color to match theme
                textStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
              child: const Text("Delete Local Reports + Recordings"),
            ),
            ElevatedButton(
              onPressed: () async {
                // Show a GetX confirmation dialog
                Get.defaultDialog(
                  title: "Confirm Deletion",
                  middleText:
                      "Are you sure you want to clear the local cache database, containing cached projects, road events, and field devices? This action cannot be undone.",
                  textCancel: "Cancel",
                  textConfirm: "Delete",
                  confirmTextColor: Colors.white,
                  onCancel: () {
                    // Do nothing if canceled
                  },
                  onConfirm: () {
                    controller.clearDb();
                    Get.back(); // Close the dialog
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700], // Change color to match theme
                textStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
              child: const Text("Clear Local Message Cache"),
            ),
            ElevatedButton(
              onPressed: () async {
                // Show a GetX confirmation dialog
                Get.defaultDialog(
                  title: "Confirm Deletion",
                  middleText:
                      "This will delete your user account, and you will have to re-register to log into the application again",
                  textCancel: "Cancel",
                  textConfirm: "Delete",
                  confirmTextColor: Colors.white,
                  onCancel: () {
                    // Do nothing if canceled
                  },
                  onConfirm: () {
                    controller.deleteUserAccount();
                    Get.back(); // Close the dialog
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700], // Change color to match theme
                textStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
              child: const Text("Delete Account"),
            ),
          ],
        ));
  }

  ElevatedButton _logoutButton() {
    return ElevatedButton(
      onPressed: () async {
        await controller.logout();
      },
      child: const Text("Logout"),
    );
  }

  Widget _headerElement(String sectionTitle, IconData icon,
      {Widget? trailing}) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.orange), //change color to match theme
            const SizedBox(width: 10),
            Text(sectionTitle,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing,
            ],
          ],
        ),
        const Divider(height: 20, thickness: 1),
      ],
    );
  }

  Widget _dangerZoneHeaderElement(String sectionTitle, IconData icon) {
    return Column(
      children: [
        Row(children: [
          Icon(icon, color: Colors.red[700]), //change color to match theme
          const SizedBox(width: 10),
          Text(sectionTitle,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.red[700])),
        ]),
        Divider(height: 20, thickness: 1, color: Colors.red[700]),
      ],
    );
  }

  Widget _voiceCommandSection() {
    return Column(
      children: [
        _headerElementWithExtraIcon("Voice Commands", Icons.mic, Icons.help,
            () {
          Get.dialog(AlertDialog(
            title: const Text('Test Voice Commands (Used in Recording)'),
            content: const VoiceOverlay(),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Get.back(); // Close the dialog
                },
                child: const Text('Exit'),
              ),
            ],
          ));
        }),
        _voiceCommandSettings(),
      ],
    );
  }

  Widget _voiceCommandSettings() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            SwitchListTile(
                title: const Text("Voice Commands Enabled"),
                value: controller.voiceCommandState.value,
                onChanged: (value) {
                  controller.switchVoiceCommandState(value);
                }),
          ],
        ));
  }

  Widget _headerElementWithExtraIcon(String sectionTitle, IconData icon,
      IconData extraIcon, Function() onTap) {
    return Column(
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Align items to the edges
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.orange), // Change color to match theme
                const SizedBox(width: 10),
                Text(
                  sectionTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            IconButton(
                icon: Icon(extraIcon, color: Colors.orange),
                onPressed: () {
                  onTap();
                }),
          ],
        ),
        const Divider(height: 20, thickness: 1),
      ],
    );
  }
}
