import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wzam/controllers/mile_marker_controller.dart';
import 'package:wzam/controllers/recording_controller.dart';
import 'package:wzam/controllers/settings_controller.dart';
import 'package:wzam/models/recording.dart';
import 'package:wzam/ui/pages/home.dart';
import 'package:wzam/ui/pages/recording/recording_page_map.dart';
import 'package:wzam/ui/pages/recording/recording_page_no_map.dart';
import 'package:wzam/ui/pages/settings.dart';

class WorkZoneRecordingTwo extends StatelessWidget {
  final RecordingController controller =
      Get.put(RecordingController(), permanent: false);
  final Recording recordingMetadata;
  final int numLanes;
  final int speedLimitMph;
  WorkZoneRecordingTwo(this.recordingMetadata, this.numLanes, this.speedLimitMph,
      {super.key});

  @override
  Widget build(BuildContext context) {
    SettingsController settingsController = Get.find<SettingsController>();
    final mileMarkerController = Get.find<MileMarkerController>();
    controller.startListeningToLocation();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (!controller.inWorkZone.value) {
          controller.onClose();
          Get.offAll(() => Home());
        } else {
          bool? shouldPop = await Get.dialog(stopLiveRecording());
          if (shouldPop != null && shouldPop) {
            controller.stopWorkZoneRecording(save: false);
            Get.back();
          }
        }
      },
      child: FutureBuilder(
          future:
              controller.initialize(recordingMetadata, numLanes, speedLimitMph),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Work Zone Recording'),
                  actions: [
                    IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          controller.onClose();
                          Get.to(() => SettingsPage());
                        }),
                  ],
                ),
                body: const Stack(
                  children: [
                    Center(child: CircularProgressIndicator()),
                  ],
                ),
              );
            }
            return Scaffold(
              appBar: AppBar(
                title: const Text('Work Zone Recording'),
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.maybePop(context);
                    }),
                actions: [
                  IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        controller.onClose();
                        Get.to(() => SettingsPage());
                      }),
                ],
              ),
              body: Obx(
                () => SafeArea(
                  child: settingsController.showRecordingMap.value
                      ? recordingMapPage(controller, controller.mapController, mileMarkerController, context)
                      : recordingNoMapPage(controller, context),
                ),
              ),
            );
          }),
    );
  }
}

AlertDialog stopLiveRecording() {
  return AlertDialog(
    title: const Text("Stop Live Recording"),
    content: const Text(
        "Are you sure you want to stop the live recording? This data will be lost."),
    actions: [
      TextButton(
        onPressed: () => Get.back(result: false),
        child: const Text("Cancel"),
      ),
      TextButton(
        onPressed: () => Get.back(result: true),
        child: const Text("Stop"),
      ),
    ],
  );
}


  