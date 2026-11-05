import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:wzam/app_config.dart';
import 'package:wzam/controllers/mile_marker_controller.dart';
import 'package:wzam/controllers/recording_controller.dart';
import 'package:wzam/models/position_extensions.dart';
import 'package:wzam/models/voice_command_status.dart';
import 'package:wzam/models/wzdx_extensions.dart';
import 'package:wzam/ui/pages/recording/widgets/offline_lock_overlay.dart';
import 'package:wzam/ui/styles/app_colors.dart';
import 'package:wzam/ui/styles/screen_size.dart';
import 'package:wzam/ui/styles/spacing.dart';
import 'package:wzam/ui/styles/text_styles.dart';

Widget recordingMapPage(RecordingController controller, MapController mapController, MileMarkerController mileMarkerController, BuildContext context) {
  return Obx(() {
    final bool offline = controller.notGettingLocationUpdates.value;
    return Stack(
      children: [
        AbsorbPointer(
          absorbing: offline,
          child: Stack(
            children: [
              _map(context, controller, controller.mapController,
                  mileMarkerController, MediaQuery.of(context).orientation),
              ...mapButtons(context, controller),
              ...controller.inWorkZone.value
                  ? inWorkZoneScreen(context, controller)
                  : outOfWorkZoneScreen(context, controller),
            ],
          ),
        ),
        if (offline) buildRecordingOfflineLockOverlay(context, controller),
      ],
    );
  });
}

Widget _map(BuildContext context, RecordingController controller,
      MapController mapController, MileMarkerController mileMarkerController, Orientation orientation) {
    return Obx(() => Positioned(
          top: 0,
          width: screenWidth(context),
          height: screenHeight(context) * 0.7,
          child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: controller.locationService.currentPosition.value
                        ?.getLatLng() ??
                    AppConfig.defaultMapCenter,
                initialZoom: 17,
                onMapReady: () {
                  controller.mapController = mapController;
                  controller.startListeningToLocation();
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://api.mapbox.com/styles/v1/mapbox/satellite-streets-v11/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}",
                  additionalOptions: {
                    'accessToken': AppConfig.mapboxAccessToken,
                    'id': 'mapbox.satellite',
                  },
                ),
                mileMarkerController.getMilepostLayer(),
                controller.polylineLayer.value,
                controller.markerLayer.value,
              ]),
        ));
}

List<Widget> mapButtons(
      BuildContext context, RecordingController controller) {
    return [
      Positioned(
          right: 10,
          top: 15,
          child: Column(children: [
            ElevatedButton(
              onPressed: () {
                controller.mapZoom.value = controller.mapZoom.value + 1;
                controller.updateMap();
              },
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Theme.of(context).cardColor,
                  fixedSize: const Size(40, 40),
                  minimumSize: const Size(40, 40)),
              child: const Icon(Icons.add, size: 20),
            ),
            verticalSpaceTiny,
            ElevatedButton(
              onPressed: () {
                controller.mapZoom.value = controller.mapZoom.value - 1;
                controller.updateMap();
              },
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Theme.of(context).cardColor,
                  fixedSize: const Size(40, 40),
                  minimumSize: const Size(40, 40)),
              child: const Icon(Icons.remove),
            ),
          ])),
      Positioned(
          left: 10,
          top: 15,
          child: controller.voiceCommandService.settingsController
                .voiceCommandState.value
            ? FloatingActionButton.large(
                onPressed: () {
                  controller.voiceCommandService.startVoiceCommand();
                },
                tooltip: 'Listen For Voice Command',
                child: Obx(() =>
                    controller.voiceCommandService.status.value.icon),
              )
            : const SizedBox()),
    ];
}

List<Widget> outOfWorkZoneScreen(
      BuildContext context, RecordingController controller) {
    return [
      //Bottom Line Left
      Positioned(
        bottom: 0,
        left: 0,
        width: screenWidth(context) * .30,
        child: Container(
          width: screenWidth(context) * .65,
          height: 100,
        color: Theme.of(context).cardColor,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  padding: EdgeInsets.zero),
              onPressed: () {},
              child: Opacity(
                opacity: 0.5,
                child: Image.asset('assets/images/workers_present.png',
                    height: 90),
              )),
        ),
      ),

      //Bottom Line Middle
      Positioned(
        bottom: 0,
        left: screenWidth(context) * .30,
        width: screenWidth(context) * .35,
        child: Container(
          height: 100,
        color: Theme.of(context).cardColor,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Stack(alignment: Alignment.center, children: [
              Opacity(
                opacity: 0.5,
                child: Image.asset('assets/images/speed_limit.png', scale: 2),
              ),
              Text("${controller.currentSpeedLimit.value}",
                  style: styleThree.copyWith(
                      color: darkGrey, fontWeight: FontWeight.w600)),
            ]),
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero, shape: const CircleBorder()),
                  onPressed: null,
                  child: const Opacity(
                    opacity: 0.5,
                    child: Icon(Icons.add, size: 20),
                  )),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, shape: const CircleBorder()),
                onPressed: null,
                child: const Opacity(
                  opacity: 0.5,
                  child: Icon(Icons.remove, size: 20),
                ),
              ),
            ]),
          ]),
        ),
      ),

      //Bottom Line Right
      Positioned(
          bottom: 0,
          right: 0,
          width: screenWidth(context) * .35,
          child: Container(
            height: 100,
            color: controller.updatingMap
                ? Theme.of(context).colorScheme.primary
              : Theme.of(context).cardColor,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  disabledBackgroundColor: Colors.transparent),
              onPressed: controller.updatingMap
                  ? () {
                      controller.inWorkZone.value
                          ? controller.stopWorkZoneRecording()
                          : controller.startWorkZoneRecording();
                    }
                  : null,
              child: Text(
                  controller.updatingMap
                      ? 'Start Work Zone'
                      : 'Recording Completed',
                  style: styleThree.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 19,
                    color: Theme.of(context).colorScheme.onSurface),
                  textAlign: TextAlign.center),
            ),
          )),

      //Second Row
      Positioned(
        bottom: 130,
        child: Container(
            width: screenWidth(context),
            height: 70,
          color: Theme.of(context).cardColor,
            child: Obx(
              () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [...createLaneButtons(controller)]),
            )),
      ),

      //Top Row - label
      Positioned(
          bottom: 200,
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

      //Bottom Row - label
      Positioned(
          bottom: 100,
          child: Container(
            width: screenWidth(context),
            height: 30,
          color: Theme.of(context).dividerColor,
          )),
    ];
  }

  List<Widget> inWorkZoneScreen(
      BuildContext context, RecordingController controller) {
    return [
      //Bottom Line Left
      Positioned(
        bottom: 0,
        left: 0,
        width: screenWidth(context) * .30,
        child: Container(
          width: screenWidth(context) * .65,
          height: 100,
        color: Theme.of(context).cardColor,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                padding: EdgeInsets.zero),
            onPressed: controller.inWorkZone.value
                ? () {
                    controller.toggleWorkersPresent();
                  }
                : null,
            child: controller.workersPresent.value
                ? Image.asset('assets/images/workers_present.png', height: 90)
                : Image.asset('assets/images/workers_not_present.png',
                    height: 90),
          ),
        ),
      ),

      //Bottom Line Middle
      Positioned(
        bottom: 0,
        left: screenWidth(context) * .30,
        width: screenWidth(context) * .35,
        child: Container(
          height: 100,
        color: Theme.of(context).cardColor,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Stack(alignment: Alignment.center, children: [
              Image.asset('assets/images/speed_limit.png', scale: 2),
              Text("${controller.currentSpeedLimit.value}",
                  style: styleThree.copyWith(
                      fontWeight: FontWeight.w600, color: textPrimaryColor)),
            ]),
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, shape: const CircleBorder()),
                onPressed: () {
                  controller.speedLimitChanging(5);
                },
              child: Icon(Icons.add,
                  size: 20, color: Theme.of(context).scaffoldBackgroundColor),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, shape: const CircleBorder()),
                onPressed: () {
                  controller.speedLimitChanging(-5);
                },
              child: Icon(Icons.remove,
                  size: 20, color: Theme.of(context).scaffoldBackgroundColor),
              ),
            ]),
          ]),
        ),
      ),

      //Bottom Line Right
      Positioned(
          bottom: 0,
          right: 0,
          width: screenWidth(context) * .35,
          child: Container(
            height: 100,
            color: Theme.of(context).colorScheme.primary,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, elevation: 0),
              onPressed: () {
                controller.inWorkZone.value
                    ? controller.stopWorkZoneRecording()
                    : controller.startWorkZoneRecording();
              },
              child: Text('End Work Zone',
                  style: styleThree.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center),
            ),
          )),

      //Second Row
      Positioned(
        bottom: 130,
        child: Container(
            width: screenWidth(context),
            height: 70,
          color: Theme.of(context).cardColor,
            child: Obx(
              () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [...createLaneButtons(controller)]),
            )),
      ),

      //Top Row - label
      Positioned(
          bottom: 200,
          child: Container(
            width: screenWidth(context),
            height: 30,
          color: Theme.of(context).dividerColor,
            child: Text("Lane Management",
                style: styleThree.copyWith(
                  color: Theme.of(context).cardColor,
                  fontWeight: FontWeight.w600),
                textAlign: TextAlign.center),
          )),

      //Bottom Row - label
      Positioned(
          bottom: 100,
          child: Container(
            width: screenWidth(context),
            height: 30,
          color: Theme.of(context).dividerColor,
          )),
    ];
  }

List<Widget> createLaneButtons(RecordingController controller) {
    List<Widget> laneButtons = [];
    for (int i = 0; i < controller.lanes.value.length; i++) {
      laneButtons.add(ElevatedButton(
        onPressed: controller.inWorkZone.value
            ? () {
                controller.toggleLaneStatus(i);
              }
            : null,
        //child: controller.lanesOpened[i] ? Text('Lane ${i+1} Open') : Text('Lane ${i+1} Closed'),
        style: ElevatedButton.styleFrom(
            backgroundColor: controller.lanes.value[i].status.color,
            padding: EdgeInsets.zero,
            shape: const CircleBorder()),
        child: controller.lanes.value[i].status.image(scale: 1),
        //style: controller.lanesOpened[i] ? ElevatedButton.styleFrom(backgroundColor: Colors.green) : ElevatedButton.styleFrom(backgroundColor: Colors.grey[600]),
      ));
    }
    return laneButtons;
}
