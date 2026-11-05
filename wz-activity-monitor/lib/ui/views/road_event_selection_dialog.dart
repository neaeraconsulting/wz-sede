import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:wzam/app_config.dart';
import 'package:wzam/controllers/mile_marker_controller.dart';
import 'package:wzam/controllers/road_event_map_controller.dart';
import 'package:wzam/controllers/work_zone_map_controller.dart';
import 'package:wzam/models/mappable_road_event.dart';
import 'package:wzam/models/live_worker_location.dart';
import 'package:wzam/models/position_extensions.dart';
import 'package:wzam/models/wrappers/road_event_wrapper.dart';
import 'package:wzam/ui/pages/recording_configuration.dart';
import 'package:wzam/ui/pages/reports/edit_report_configuration.dart';
import 'package:wzam/ui/pages/reports/report_configuration.dart';
import 'package:wzam/ui/pages/work_zone_map.dart';
import 'package:wzam/ui/styles/app_colors.dart';
import 'package:wzam/ui/styles/screen_size.dart';
import 'package:wzam/ui/styles/spacing.dart';
import 'package:wzam/ui/styles/widgets/wzam_text.dart';

class RoadEventListDialog extends StatelessWidget {
  final int? selectedProjectId;
  final int? selectedRoadEventId;
  final bool isReport;
  final bool isLiveReport;
  const RoadEventListDialog(
      {this.selectedProjectId,
      this.selectedRoadEventId,
      this.isReport = false,
      this.isLiveReport = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    RoadEventMapController controller = Get.put(RoadEventMapController());
    WorkZoneMapController workZoneMapController = Get.find<WorkZoneMapController>();
    final mileMarkerController = Get.find<MileMarkerController>();
    final mapController = MapController();

    return FutureBuilder(
        future: controller.initialize(
            selectedRoadEventId: selectedRoadEventId),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Dialog(
              child: Stack(
                children: [
                  Center(child: CircularProgressIndicator()),
                ],
              ),
            );
          }
          return Dialog(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  height: screenHeight(context) * 0.7,
                  child: Column(children: [
                    const WZAMText.styleTwo("Select a Work Zone"),
                    verticalSpaceMedium,
                    roadEventDropdownMenu(controller),
                    verticalSpaceMedium,
                    Expanded(
                      child:
                          roadEventMapView(context, controller, mapController, mileMarkerController),
                    ),
                    verticalSpaceMedium,
                    !isLiveReport ? SizedBox(
                      width: screenWidth(context) * 0.7,
                      child: Obx(() => ElevatedButton(
                            onPressed: controller.selectedRoadEvent.value !=
                                    null
                                ? () {
                                    if (controller.selectedRoadEvent.value !=
                                        null) {
                                      if (isReport) {
                                        Get.off(() => EditReportPage(existingRoadEvent: controller.roadEventWrapperList.firstWhere((event) => event.roadEvent.id == controller.selectedRoadEvent.value)));
                                      } else {
                                        Get.to(() => RecordingConfiguration(
                                            existingRoadEvent: controller
                                                .roadEventWrapperList
                                                .firstWhere((event) =>
                                                    event.roadEvent.id ==
                                                    controller.selectedRoadEvent
                                                        .value)));
                                      }
                                    }
                                  }
                                : null,
                            child: const Text('Edit Selected Work Zone'),
                          )),
                    ) : Obx(() => ElevatedButton(
                      onPressed: controller.selectedRoadEvent.value != null ? () {
                        RoadEventWrapper tempRoadEvent = controller.roadEventWrapperList.firstWhere((event) => event.roadEvent.id == controller.selectedRoadEvent.value);
                        Get.back();
                        String currentRoute = Get.currentRoute;
                        if (currentRoute == '/Home') {
                          Get.to(() => const WorkZoneMap());
                        }
                        workZoneMapController.startLiveWorkerSession(
                          tempRoadEvent.roadEvent, WorkerLocationType.WORKER,
                        );
                      } : null,
                      child: const Text('Start Live Worker Session'),
                    )),
                    verticalSpaceSmall,
                    !isLiveReport ? SizedBox(
                      width: screenWidth(context) * 0.7,
                      child: ElevatedButton(
                        onPressed: () {
                          if (isReport) {
                            Get.to(() => ReportConfigurationPage(
                                existingRoadEvent: null));
                          } else {
                            Get.to(() => RecordingConfiguration(
                                existingRoadEvent: null));
                          }
                        },
                        child: const Text('Create a new work zone'),
                      ),
                    ) : Container(),
                  ]),
                )),
          );
        });
  }

  Widget roadEventDropdownMenu(RoadEventMapController controller) {
    return Obx(
      () => DropdownMenu<int>(
        width: screenWidth(Get.context!) * 0.7,
        hintText: "Select a Road Event",
        initialSelection: controller.selectedRoadEvent.value,
        menuHeight: screenHeight(Get.context!) * 0.5,
        enableFilter: true,
        requestFocusOnTap: true,
        filterCallback: (entries, filter) {
          final String query = filter.trim().toLowerCase();
          if (query.isEmpty) {
            return entries;
          }

          return entries.where((entry) {
            final roadEvent = controller.roadEventMap.firstWhereOrNull(
              (event) => event.id == entry.value,
            );
            if (roadEvent == null) {
              return entry.label.toLowerCase().contains(query);
            }

            final String name = roadEvent.roadEvent.name.toLowerCase();
            final String description =
                roadEvent.roadEvent.description.toLowerCase();
            final String id = roadEvent.id.toString();

            return name.contains(query) ||
                description.contains(query) ||
                id.contains(query) ||
                entry.label.toLowerCase().contains(query);
          }).toList();
        },
        dropdownMenuEntries: controller.roadEventMap.map((roadEvent) {
          String name = roadEvent.roadEvent.name.trim();
          if (name.length > 30) {
            name = "${name.substring(0, 30)}...";
          }
          final String description = roadEvent.roadEvent.description.trim();
          final String label = "$name (${roadEvent.id})";

          return DropdownMenuEntry<int>(
            value: roadEvent.id,
            label: label,
            trailingIcon: description.isNotEmpty
                ? GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _showDescriptionDialog(
                      controller: controller,
                      roadEvent: roadEvent,
                      title: '$name (${roadEvent.id})',
                      description: description,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(Icons.info_outline,
                          size: 18, color: Theme.of(Get.context!).hintColor),
                    ),
                  )
                : null,
          );
        }).toList(),
        onSelected: (int? selectedId) {
          if (selectedId != null) {
            controller.selectedRoadEvent.value = selectedId;
            final selectedRoadEvent = controller.roadEventMap.firstWhereOrNull(
              (event) => event.id == selectedId,
            );
            if (selectedRoadEvent != null && selectedRoadEvent.bounds != null) {
              controller.mapController?.fitCamera(
                CameraFit.bounds(
                  bounds: selectedRoadEvent.bounds!,
                  maxZoom: 14,
                  padding: const EdgeInsets.all(40),
                ),
              );
            }
          }
        },
      ),
    );
  }

  void _showDescriptionDialog({
    required MappableRoadEvent roadEvent,
    required RoadEventMapController controller,
    required String title,
    required String description,
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () {
              controller.selectedRoadEvent.value = roadEvent.id;
              if (roadEvent.bounds != null) {
                controller.mapController?.fitCamera(
                  CameraFit.bounds(
                    bounds: roadEvent.bounds!,
                    maxZoom: 14,
                    padding: const EdgeInsets.all(40),
                  ),
                );
              }
              Get.back();
            },
            child: const Text('Select'),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget roadEventMapView(BuildContext context,
      RoadEventMapController controller, MapController mapController, MileMarkerController mileMarkerController) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Stack(
        children: [
          _map(context, controller, mapController, mileMarkerController,
              MediaQuery.of(context).orientation),
          // Button in the top-right corner
          Positioned(
            top: 16,
            right: 16,
            child: Obx(
              () => Container(
                decoration: BoxDecoration(
                  color: Colors.white, // White background
                  borderRadius: BorderRadius.circular(4), // Rounded corners
                ),
                child: IconButton(
                  icon: const Icon(Icons.my_location),
                  padding: EdgeInsets.zero,
                  onPressed: controller.locationService.currentPosition.value !=
                          null
                      ? () {
                          LatLng? userLocation = controller
                              .locationService.currentPosition.value
                              ?.getLatLng();
                          if (userLocation != null) {
                            controller.mapController?.move(
                              userLocation,
                              12, // Zoom level
                            );
                          }
                        }
                      : null, // Disable the button if currentPosition is null
                  color:
                      controller.locationService.currentPosition.value != null
                          ? primaryColor // Enabled state color
                          : Colors.purple, // Disabled state color
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _map(BuildContext context, RoadEventMapController controller,
      MapController mapController, MileMarkerController mileMarkerController, Orientation orientation) {
    return Obx(() => SizedBox(
          width: screenWidth(context),
          height: screenHeight(context),
          child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: controller.locationService.currentPosition.value
                        ?.getLatLng() ??
                    AppConfig.defaultMapCenter,
                initialZoom: 12,
                onMapReady: () {
                  controller.mapController = mapController;
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
                Obx(
                  () => controller.constructPolygonLayer(
                      controller.roadEventMap,
                      controller.selectedRoadEvent.value),
                ),
                Obx(
                  () => controller.constructPolylineLayer(
                      controller.roadEventMap,
                      controller.selectedRoadEvent.value),
                ),
                Obx(
                  () => controller.constructMarkerLayer(
                      controller.userMarker.value,
                      controller.roadEventMap,
                      controller.selectedRoadEvent.value),
                ),
              ]),
        ));
  }
}
