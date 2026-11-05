

import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:wzam/controllers/recording_controller.dart';
import 'package:flutter/material.dart';
import 'package:wzam/controllers/settings_controller.dart';
import 'package:wzam/models/voice_command_status.dart';
import 'package:wzam/models/wzdx_extensions.dart';
import 'package:wzam/ui/pages/recording/widgets/offline_lock_overlay.dart';
import 'package:wzam/ui/styles/app_colors.dart';
import 'package:wzam/ui/styles/screen_size.dart';
import 'package:wzam/ui/styles/spacing.dart';
import 'package:wzam/ui/styles/text_styles.dart';
import 'package:wzam/ui/styles/widgets/location_health_banner.dart';

String workerImageAsset(BuildContext context, {required bool workersPresent}) {
  final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
  if (workersPresent) {
    return isDarkMode
        ? 'assets/images/workers_present_dark_mode.png'
        : 'assets/images/workers_present.png';
  }
  return isDarkMode
      ? 'assets/images/workers_not_present_dark_mode.png'
      : 'assets/images/workers_not_present.png';
}

Widget recordingNoMapPage(RecordingController controller, BuildContext context) {
  SettingsController settingsController = Get.find<SettingsController>();
  return Obx(() {
    final bool offline = controller.notGettingLocationUpdates.value;
    return Stack(
      children: [
        AbsorbPointer(
          absorbing: offline,
          child: Stack(
            children: [
              Container(
                width: screenWidth(context),
                height: screenHeight(context),
                color: Get.isDarkMode ? darkGrey : lightGrey,
              ),
              startWorkZoneButton(context, controller),
              ...controller.inWorkZone.value
                  ? inWorkZoneScreen(context, controller)
                  : outOfWorkZoneScreen(context, controller),
              if (settingsController.voiceCommandState.value)
                ...voiceCommandAndLocation(context, controller)
              else
                ...enableVoiceAndLocationBox(context, controller),
            ],
          ),
        ),
        if (offline) buildRecordingOfflineLockOverlay(context, controller),
      ],
    );
  });
}

Widget startWorkZoneButton(BuildContext context, RecordingController controller) {
    return Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: ElevatedButton(
        onPressed: () {
          controller.inWorkZone.value
            ? controller.stopWorkZoneRecording()
            : controller.startWorkZoneRecording();
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: controller.inWorkZone.value ? Colors.red : Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
        child: Text(controller.inWorkZone.value ? 'Exit Work Zone' : 'Start Work Zone',
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
      ),
    );
  }

List<Widget> inWorkZoneScreen(
      BuildContext context, RecordingController controller) {
    double height = screenHeight(context);
    double iconHeight = height * 0.185;
    double buttonSize = iconHeight * 0.4;
    return [
      //Workers Present Button
      Positioned(
        top: 120,
        left: 10,
        width: screenWidth(context) * .5,
        child: Container(
          width: screenWidth(context) * .5,
          height: iconHeight + 15,
        color: Theme.of(context).cardColor,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0),
            onPressed: () {
              controller.toggleWorkersPresent();
            },
          child: controller.workersPresent.value
              ? Image.asset(workerImageAsset(context, workersPresent: true),
                  height: iconHeight)
              : Image.asset(workerImageAsset(context, workersPresent: false),
                  height: iconHeight),
            ),
          ),
      ),

      //Speed Limit Button
      Positioned(
        top: 120,
        right: 10,
        width: screenWidth(context) * .5,
        child: Container(
          height: iconHeight + 15,
        color: Theme.of(context).cardColor,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Stack(alignment: Alignment.center, children: [
              Image.asset('assets/images/speed_limit.png', height: iconHeight),
              Text("${controller.currentSpeedLimit.value}",
                style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            ]),
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero, shape: const CircleBorder()),
                  onPressed: () {
                    controller.speedLimitChanging(5);
                  },
                  child: Icon(Icons.add, size: buttonSize)
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, shape: const CircleBorder()),
                onPressed: () {
                  controller.speedLimitChanging(-5);
                },
                child: Icon(Icons.remove, size: buttonSize),
              ),
            ]),
          ]),
        ),
      ),

      //Second Row - Lane Management Buttons
      Positioned(
        top: 175 + iconHeight,
        child: Container(
            width: screenWidth(context),
            height: 70,
          color: Theme.of(context).cardColor,
            child: Obx(
              () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [...createLaneButtons(controller, iconHeight)]),
            )),
      ),

      //Top Row - Lane Management Label
      Positioned(
          top: 135 + iconHeight,
          child: Container(
            width: screenWidth(context),
            height: 30,
          color: Theme.of(context).dividerColor,
            child: Text("Lane Management",
                style: styleThree.copyWith(
                  color: Theme.of(context).cardColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 19),
                textAlign: TextAlign.center),
          )),

      //Top Grey Bar
      Positioned(
          top: 90,
          child: Container(
            width: screenWidth(context),
            height: 30,
          color: Theme.of(context).dividerColor,
          )),

      //Location Display
      Positioned(
        bottom: 20,
        left: 0,
        right: 0,
        child: Center(
        child: Obx(
          () => SizedBox(
            width: screenWidth(context) * 0.92,
            child: LocationHealthBanner(
              model: controller.locationStatusBanner,
              fontSize: screenWidth(context) < 420 ? 14 : 16,
              compact: screenWidth(context) < 420,
            ),
          ),
        ),
      ),
    ),
    ];
  }

  List<Widget> createLaneButtons(RecordingController controller, double iconHeight) {
    List<Widget> laneButtons = [];
    for (int i = 0; i < controller.lanes.value.length; i++) {
      laneButtons.add(ElevatedButton(
        onPressed: controller.inWorkZone.value
            ? () {
                controller.toggleLaneStatus(i);
              }
            : null,
        style: ElevatedButton.styleFrom(
            backgroundColor: controller.lanes.value[i].status.color,
            padding: EdgeInsets.zero,
            shape: const CircleBorder()),
        child: controller.lanes.value[i].status.image(scale: 1),
      ));
    }
    return laneButtons;
  }

List<Widget> outOfWorkZoneScreen(
      BuildContext context, RecordingController controller) {
  double iconHeight = screenHeight(context) * 0.185;
    return [
      //Workers Present Button
      Positioned(
        top: 120,
        left: 10,
        width: screenWidth(context) * .50,
        child: Container(
          width: screenWidth(context) * .65,
          height: iconHeight + 15,
        color: Theme.of(context).cardColor,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  padding: EdgeInsets.zero),
              onPressed: () {},
              child: Opacity(
                opacity: 0.5,
              child: Image.asset(
                  workerImageAsset(context, workersPresent: true),
                    height: iconHeight),
              )),
        ),
      ),

      //Speed Limit Button
      Positioned(
        top: 120,
        right: 10,
        width: screenWidth(context) * .5,
        child: Container(
          height: iconHeight + 15,
        color: Theme.of(context).cardColor,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Stack(alignment: Alignment.center, children: [
              Opacity(
                opacity: 0.5,
                child: Image.asset('assets/images/speed_limit.png', height: iconHeight),
              ),
              Text("${controller.currentSpeedLimit.value}",
                style: TextStyle(
                    color: Theme.of(context).dividerColor,
                    fontSize: 40,
                    fontWeight: FontWeight.bold)),
            ]),
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero, shape: const CircleBorder()),
                  onPressed: null,
                  child: const Opacity(
                    opacity: 0.5,
                    child: Icon(Icons.add, size: 50),
                  )),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, shape: const CircleBorder()),
                onPressed: null,
                child: const Opacity(
                  opacity: 0.5,
                  child: Icon(Icons.remove, size: 50),
                ),
              ),
            ]),
          ]),
        ),
      ),

      //Second Row - Lane Management Buttons
      Positioned(
        top: 175 + iconHeight,
        child: Container(
            width: screenWidth(context),
            height: 70,
          color: Theme.of(context).cardColor,
            child: Obx(
              () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [...createLaneButtons(controller, iconHeight)]),
            )),
      ),

      //Top Row - Lane Management Label
      Positioned(
          top: 135 + iconHeight,
          child: Container(
            width: screenWidth(context),
            height: 30,
          color: Theme.of(context).dividerColor,
            child: Text("Lane Management",
                style: styleThree.copyWith(
                  color: Theme.of(context).cardColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 19),
                textAlign: TextAlign.center),
          )),

      //Top Grey Bar
      Positioned(
          top: 90,
          child: Container(
            width: screenWidth(context),
            height: 30,
          color: Theme.of(context).dividerColor,
          )),
    ];
  }

  List<Widget> voiceCommandAndLocation(BuildContext context, RecordingController controller) {
    double iconHeight = screenHeight(context) * 0.185;
    double buttonSize = iconHeight * 0.6;
    return [
      Positioned(  
        top: 135 + (iconHeight  * 2),
        left: 0,
        right: 0,
        child: Center(
          child: Container(
            width: screenWidth(context) * 0.8,
            height: iconHeight * 1.65,
            decoration: BoxDecoration(
              border: Border.all(color: controller.voiceCommandService.status.value == VoiceCommandStatus.listeningForCommand ? Colors.green : darkGrey, width: 2),
            ),
            child: controller.voiceCommandService.status.value == VoiceCommandStatus.listeningForCommand  
              ? Padding(
                padding: EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.mic_rounded, size: buttonSize * 0.5, color: Colors.green),
                          Text("Listening for Command...", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          horizontalSpaceSmall
                        ],
                      ),
                      verticalSpaceMedium,
                      controller.inWorkZone.value ? controller.workersPresent.value ? speechOption("'End Workers'") : speechOption("'Workers Present'") : speechOption("'Start Work Zone'"),
                      controller.inWorkZone.value ? speechOption("'Close/Open Lane #'") : Container(),
                      controller.inWorkZone.value ? speechOption("'Speed Limit #'") : Container(),
                    ],
                  ),
                ),
              )
              : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      controller.voiceCommandService.startVoiceCommand();
                    },
                    child: Obx(() =>Container(
                      decoration: BoxDecoration(
                        color: controller.voiceCommandService.status.value == VoiceCommandStatus.listeningForCommand ? Colors.blue : Colors.green,
                        shape: BoxShape.circle,
                      ),
                      width: buttonSize + 15,
                      height: buttonSize + 15,
                      child: Icon(Icons.mic_rounded, size: buttonSize, color: Colors.white),
                    ))
                  ),
                  verticalSpaceLarge,
                  const Text(  
                    "'Hey Work Zone'",
                      style: TextStyle(
                        fontSize: 30, fontStyle: FontStyle.italic),
                  ),
                ]
              ),
          ),
        ),
      ),

      //Location Display
      Positioned(
        bottom: 20,
        left: 0,
        right: 0,
        child: Center(
        child: Obx(
          () => SizedBox(
            width: screenWidth(context) * 0.92,
            child: LocationHealthBanner(
              model: controller.locationStatusBanner,
              fontSize: screenWidth(context) < 420 ? 14 : 16,
              compact: screenWidth(context) < 420,
            ),
          ),
        ),
      ),
    ),
    ];
  }

  Widget speechOption(String command) {
    return SizedBox(
      width: screenWidth(Get.context!) * 0.7,
      child: ElevatedButton(  
        onPressed: () {
          
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: mediumGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(command, style: const TextStyle(fontSize: 24, fontStyle: FontStyle.italic)),
      ),
    );
  }

  List<Widget> enableVoiceAndLocationBox(BuildContext context, RecordingController controller) {
    SettingsController settingsController = Get.find<SettingsController>();
    return [
      Positioned(  
        top: 420,
        left: 0,
        right: 0,
        child: Center(
          child: Container(
            width: screenWidth(context) * 0.8,
            height: 270,
            decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(  
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Enable Voice Commands", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Switch(
                      value: settingsController.voiceCommandState.value,
                      onChanged: (value) {
                        settingsController.switchVoiceCommandState(value);
                      },
                    ),
                  ]
                ),
                verticalSpaceMedium,
                Row(  
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Switch to Map View", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Switch(
                      value: settingsController.showRecordingMap.value,
                      onChanged: (value) {
                        settingsController.switchShowRecordingMapState(value);
                      },
                    ),
                  ]
                ),
              ]
            ),
          ),
        ),
      ),

      //Location Display
      Positioned(
        bottom: 20,
        left: 0,
        right: 0,
        child: Center(
        child: Obx(
          () => SizedBox(
            width: screenWidth(context) * 0.92,
            child: LocationHealthBanner(
              model: controller.locationStatusBanner,
              fontSize: screenWidth(context) < 420 ? 14 : 16,
              compact: screenWidth(context) < 420,
            ),
          ),
        ),
      ),
    ),
    ];
  }