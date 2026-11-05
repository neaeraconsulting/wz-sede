import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wzam/app_config.dart';
import 'package:wzam/services/auth_service.dart';
import 'package:wzam/ui/views/support_request_dialog.dart';

class RequestAccessPageController extends GetxController {
  RxList<String> supportEmails = RxList<String>([AppConfig.adminEmailAddress]);
  final AuthService authService = Get.find<AuthService>();

  RequestAccessPageController() {
    init();
  }

  void init() async {
    List<String>? emails = await authService.getAccessRequestEmails();
    if (emails != null && emails.isNotEmpty) {
      supportEmails.value = [...emails];
    }
  }
}

class RequestAccessPage extends StatelessWidget {
  final String supportEmail = AppConfig.adminEmailAddress;
  final RequestAccessPageController controller =
      Get.put(RequestAccessPageController());

  RequestAccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Access Required'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'You are logged in, but you need to request access to proceed further.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Get.dialog(SupportRequestDialog(initialSubject: 'Requesting Access'));
                    },
                    child: const Text("Contact Support"),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.help_outline),
                    tooltip: "Show support email addresses",
                    onPressed: () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text("Request Access"),
                          content: Obx(
                            () => Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    "Send an email to one or more of these administrators and specify that you are requesting access to the WZAM mobile application. "
                                    "Include the requested role (User or Administrator) in your message.",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                SizedBox(
                                  height: 200,
                                  child: SingleChildScrollView(
                                    child: Column(children: [
                                      ...controller.supportEmails
                                          .map((email) => Row(
                                                children: [
                                                  Expanded(
                                                    child: SelectableText(
                                                      email,
                                                      style: const TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(Icons.copy,
                                                        size: 18),
                                                    tooltip:
                                                        "Copy to clipboard",
                                                    onPressed: () {
                                                      Clipboard.setData(
                                                          ClipboardData(
                                                              text: email));
                                                    },
                                                  ),
                                                ],
                                              ))
                                    ]),
                                  ),
                                )
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                final allEmails =
                                    controller.supportEmails.join(';');
                                Clipboard.setData(
                                    ClipboardData(text: allEmails));
                              },
                              child: const Text("Copy All"),
                            ),
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text("Close"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
