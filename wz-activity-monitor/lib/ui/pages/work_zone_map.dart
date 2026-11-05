import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wzam/app_config.dart';
import 'package:wzam/controllers/mile_marker_controller.dart';
import 'package:wzam/controllers/work_zone_map_controller.dart';
import 'package:wzam/models/mappable_road_event.dart';
import 'package:wzam/models/position_extensions.dart';
import 'package:wzam/ui/pages/settings.dart';
import 'package:wzam/ui/styles/app_colors.dart';
import 'package:wzam/ui/styles/screen_size.dart';
import 'package:wzam/ui/styles/spacing.dart';
import 'package:wzam/ui/styles/widgets/location_health_banner.dart';
import 'package:wzam/ui/styles/widgets/wzam_text.dart';
import 'package:wzam/ui/views/stop_live_worker_dialog.dart';

class WorkZoneMap extends StatelessWidget {
  const WorkZoneMap({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WorkZoneMapController>();
    final mileMarkerController = Get.find<MileMarkerController>();
    final mapController = MapController();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (!controller.activeLiveWorker.value) {
          controller.stopListeningToLocation();
          Get.back();
        } else {
          bool shouldPop = await Get.dialog(stopLiveWorker());
          if (shouldPop) {
            controller.stopLiveWorkerSession();
            Get.back();
          }
        }
      },
      child: FutureBuilder(
          future: controller.initialize(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Work Zone Map'),
                  actions: [
                    IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
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
                  title: const Text('Work Zone Map'),
                  actions: [
                    IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          Get.to(() => SettingsPage());
                        }),
                  ],
                ),
                body: Obx(
                  () => SafeArea(
                    child: Stack(
                      children: [
                        _map(
                            context,
                            controller,
                            mapController,
                            mileMarkerController,
                            MediaQuery.of(context).orientation),
                        !controller.activeLiveWorker.value
                            ? reportDrawer(controller)
                            : Container(),
                        Positioned(
                          top: 10,
                          left: 10,
                          right: controller.activeLiveWorker.value ? 60 : null,
                          child: controller.activeLiveWorker.value
                              ? SizedBox(
                                  width: screenWidth(context) * 0.70,
                                  child: liveWorkerDisplay(context, controller),
                                )
                              : Obx(() => Container(
                                    width: controller.showFilters.value
                                        ? 225
                                        : 120,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: lightGrey.withValues(alpha: 0.9),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            controller.showFilters.value =
                                                !controller.showFilters.value;
                                          },
                                          child: Row(
                                            children: [
                                              Text("Filters",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: textPrimaryColor)),
                                              Expanded(child: Container()),
                                              Icon(
                                                controller.showFilters.value
                                                    ? Icons.keyboard_arrow_down
                                                    : Icons.keyboard_arrow_left,
                                                color: textPrimaryColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                        ...(controller.showFilters.value
                                            ? filters(controller)
                                            : [Container()]),
                                      ],
                                    ),
                                  )),
                        ),
                        controller.activeLiveWorker.value
                            ? Positioned(
                                top: 10,
                                right: 10,
                                child: mapTrackingButton(controller),
                              )
                            : Container(),
                        controller.activeLiveWorker.value
                            ? Positioned(
                                bottom: 30,
                                right: 30,
                                left: 30,
                                child: stopLiveWorkerButton(controller),
                              )
                            : Container(),
                        Obx(() => controller.loadingLiveWorker.value
                            ? const Center(child: CircularProgressIndicator())
                            : Container()),
                      ],
                    ),
                  ),
                ));
          }),
    );
  }

  Widget _map(
      BuildContext context,
      WorkZoneMapController controller,
      MapController mapController,
      MileMarkerController mileMarkerController,
      Orientation orientation) {
    return Obx(() => SizedBox(
          width: screenWidth(context),
          height: screenHeight(context),
          child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                  initialCenter: controller
                          .locationService.currentPosition.value
                          ?.getLatLng() ??
                      AppConfig.defaultMapCenter,
                  initialZoom: 17,
                  onMapReady: () {
                    controller.mapController = mapController;
                  },
                  onMapEvent: (event) {
                    controller.currentZoom.value = event.camera.zoom;
                    if (event is MapEventMoveStart) {
                      if (controller.isMapFollowingWorker.value) {
                        controller.isMapFollowingWorker.value = false;
                      }
                    }
                  }),
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
                controller.polygonLayer.value,
                controller.polylineLayer.value,
                controller.markerLayer.value,
              ]),
        ));
  }

  Widget reportDrawer(WorkZoneMapController controller) {
    return DraggableScrollableSheet(
      initialChildSize: 0.12, // Initial height (12% of screen height)
      minChildSize: 0.04, // Minimum height
      maxChildSize: 0.45, // Maximum height
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).dialogTheme.backgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              // Drag handle
              SliverToBoxAdapter(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    height: 4,
                    width: 40,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              // Title
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Road Events',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // List of road events
              Obx(
                () => SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    MappableRoadEvent roadEvent =
                        controller.mappableRoadEvents[index];
                    return Obx(() => Container(
                          decoration: BoxDecoration(
                            color: controller.selectedRoadEvent.value ==
                                    roadEvent.id
                                ? Color.alphaBlend(
                                    primaryColor.withValues(alpha: 0.1),
                                    Theme.of(context).scaffoldBackgroundColor,
                                  )
                                : Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: controller.selectedRoadEvent.value ==
                                      roadEvent.id
                                  ? primaryColor
                                  : Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          child: ListTile(
                            title: Text(roadEvent.roadEvent.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("ID: ${roadEvent.id}",
                                    style: TextStyle(
                                        color: Theme.of(context).hintColor)),
                                Text(
                                  roadEvent.roadEvent.hasEndDate()
                                      ? "${DateFormat.yMd().add_jm().format(roadEvent.startDate)} - ${DateFormat.yMd().add_jm().format(roadEvent.endDate)}"
                                      : DateFormat.yMd()
                                          .add_jm()
                                          .format(roadEvent.startDate),
                                  style: TextStyle(
                                      color: Theme.of(context).hintColor),
                                ),
                                Text(
                                    "Description: ${roadEvent.roadEvent.hasDescription() ? roadEvent.roadEvent.description : "None"}",
                                    style: TextStyle(
                                        color: Theme.of(context).hintColor)),
                              ],
                            ),
                            // Allow Users to toggle field device visibility. TODO: implement
                            // trailing: IconButton(
                            //   onPressed: () {
                            //     roadEvent.showFieldDevices.value = !roadEvent.showFieldDevices.value;
                            //     controller.updateFieldDeviceMarkers(roadEvent);
                            //   },
                            //   icon: Icon(roadEvent.showFieldDevices.value ? Icons.visibility : Icons.visibility_off, color: roadEvent.showFieldDevices.value ? primaryColor : Theme.of(context).iconTheme.color),
                            // ),
                            onTap: () {
                              controller.selectRoadEvent(index);
                            },
                          ),
                        ));
                  },
                  childCount: controller
                      .mappableRoadEvents.length, // Number of road events
                )),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> filters(WorkZoneMapController controller) {
    return [
      verticalSpaceSmall,
      WZAMText.body("Status", style: TextStyle(color: textPrimaryColor)),
      InkWell(
        onTap: () async {
          // Toggle the checkbox value when the text is tapped
          controller.showInactive.value = !controller.showInactive.value;
          await controller.filter();
        },
        child: Row(
          children: [
            Obx(() => Checkbox(
                  value: controller.showInactive.value,
                  visualDensity: VisualDensity.compact,
                  onChanged: (val) async {
                    controller.showInactive.value = val ?? false;
                    await controller.filter();
                  },
                )),
            Text("Inactive", style: TextStyle(color: textPrimaryColor)),
          ],
        ),
      ),
      InkWell(
        onTap: () async {
          // Toggle the checkbox value when the text is tapped
          controller.showActive.value = !controller.showActive.value;
          await controller.filter();
        },
        child: Row(
          children: [
            Obx(() => Checkbox(
                  value: controller.showActive.value,
                  visualDensity: VisualDensity.compact,
                  onChanged: (val) async {
                    controller.showActive.value = val ?? false;
                    await controller.filter();
                  },
                )),
            Text("Active", style: TextStyle(color: textPrimaryColor)),
          ],
        ),
      ),
      InkWell(
        onTap: () async {
          // Toggle the checkbox value when the text is tapped
          controller.showUnknown.value = !controller.showUnknown.value;
          await controller.filter();
        },
        child: Row(
          children: [
            Obx(() => Checkbox(
                  value: controller.showUnknown.value,
                  visualDensity: VisualDensity.compact,
                  onChanged: (val) async {
                    controller.showUnknown.value = val ?? false;
                    await controller.filter();
                  },
                )),
            Text("Unknown", style: TextStyle(color: textPrimaryColor)),
          ],
        ),
      ),

      // Add your date filter widgets here
      WZAMText.body("Area Type", style: TextStyle(color: textPrimaryColor)),
      InkWell(
        onTap: () async {
          // Toggle the checkbox value when the text is tapped
          controller.showStatic.value = !controller.showStatic.value;
          await controller.filter();
        },
        child: Row(
          children: [
            Obx(() => Checkbox(
                  value: controller.showStatic.value,
                  visualDensity: VisualDensity.compact,
                  onChanged: (val) async {
                    controller.showStatic.value = val ?? false;
                    await controller.filter();
                  },
                )),
            Text("Static", style: TextStyle(color: textPrimaryColor)),
          ],
        ),
      ),
      InkWell(
        onTap: () async {
          // Toggle the checkbox value when the text is tapped
          controller.showMoving.value = !controller.showMoving.value;
          await controller.filter();
        },
        child: Row(
          children: [
            Obx(() => Checkbox(
                  value: controller.showMoving.value,
                  visualDensity: VisualDensity.compact,
                  onChanged: (val) async {
                    controller.showMoving.value = val ?? false;
                    await controller.filter();
                  },
                )),
            Text("Moving", style: TextStyle(color: textPrimaryColor)),
          ],
        ),
      ),
      InkWell(
        onTap: () async {
          // Toggle the checkbox value when the text is tapped
          controller.showPlanned.value = !controller.showPlanned.value;
          await controller.filter();
        },
        child: Row(
          children: [
            Obx(() => Checkbox(
                  value: controller.showPlanned.value,
                  visualDensity: VisualDensity.compact,
                  onChanged: (val) async {
                    controller.showPlanned.value = val ?? false;
                    await controller.filter();
                  },
                )),
            Text("Planned Moving Area",
                style: TextStyle(color: textPrimaryColor)),
          ],
        ),
      ),
    ];
  }

  Widget liveWorkerDisplay(
      BuildContext context, WorkZoneMapController controller) {
    final bool compact = screenWidth(context) < 420;
    return LocationHealthBanner(
      model: controller.locationStatusBanner,
      fontSize: compact ? 12 : 14,
      padding: const EdgeInsets.all(14.0),
      compact: compact,
    );
  }

  Widget mapTrackingButton(WorkZoneMapController controller) {
    return GestureDetector(
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.0),
            color: Theme.of(Get.context!)
                .scaffoldBackgroundColor
                .withValues(alpha: 0.8),
          ),
          child: Icon(controller.isMapFollowingWorker.value
              ? Icons.my_location
              : Icons.location_searching),
        ),
        onTap: () {
          controller.isMapFollowingWorker.value =
              !controller.isMapFollowingWorker.value;
          controller.updateMap();
        });
  }

  Widget stopLiveWorkerButton(WorkZoneMapController controller) {
    return ElevatedButton(
      onPressed: () {
        controller.stopLiveWorkerSession();
      },
      child: const Text("Stop Live Worker Session"),
    );
  }
}
