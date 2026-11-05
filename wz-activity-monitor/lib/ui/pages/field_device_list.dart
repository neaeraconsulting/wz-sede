import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:wzam/app_config.dart';
import 'package:wzam/controllers/field_device_map_controller.dart';
import 'package:wzam/controllers/mile_marker_controller.dart';
import 'package:wzam/models/position_extensions.dart';
import 'package:wzam/ui/pages/settings.dart';
import 'package:wzam/ui/styles/app_colors.dart';
import 'package:wzam/ui/styles/screen_size.dart';
import 'package:wzam/ui/styles/spacing.dart';
import 'package:wzam/ui/views/field_device_filters.dart';

class FieldDeviceList extends StatelessWidget {
  final int? selectedRoadEventId;
  final List<String> selectedFieldDeviceIds;
  const FieldDeviceList(
      {this.selectedRoadEventId,
      required this.selectedFieldDeviceIds,
      super.key});

  @override
  Widget build(BuildContext context) {
    FieldDeviceMapController controller = Get.put(FieldDeviceMapController());
    final mileMarkerController = Get.find<MileMarkerController>();
    final mapController = MapController();

    return FutureBuilder(
        future:
            controller.initialize(selectedFieldDevices: selectedFieldDeviceIds),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Field Device Selection'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Get.to(() => SettingsPage());
                    },
                  ),
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
              title: const Text('Select Field Device(s)'),
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  _map(context, controller, mapController, mileMarkerController,
                      MediaQuery.of(context).orientation),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: SizedBox(
                        height: 48,
                        child: Obx(
                          () => ElevatedButton(
                            onPressed: () {
                              List<String> selectedFieldDeviceIdsTwo =
                                  controller.selectedFieldDeviceIds.toList();
                              Get.back(
                                result: selectedFieldDeviceIdsTwo,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Save Selection & Exit',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  '(${controller.selectedFieldDeviceIds.length} selected)',
                                  style: const TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                          ),
                        )),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Obx(() => IconButton(
                                icon: Icon(controller.isMapFollowingWorker.value
                                    ? Icons.my_location
                                    : Icons.location_searching),
                                padding: EdgeInsets.zero,
                                onPressed: controller.locationService
                                            .currentPosition.value !=
                                        null
                                    ? () {
                                        LatLng? userLocation = controller
                                            .locationService
                                            .currentPosition
                                            .value
                                            ?.getLatLng();
                                        if (userLocation != null) {
                                          controller.mapController?.move(
                                            userLocation,
                                            controller.currentZoom.value,
                                          );
                                          controller.isMapFollowingWorker
                                              .value = true;
                                        }
                                      }
                                    : null, // Disable the button if currentPosition is null
                                color: controller.locationService
                                            .currentPosition.value !=
                                        null
                                    ? primaryColor // Enabled state color
                                    : Colors.grey, // Disabled state color
                              )),
                        ),
                        verticalSpaceSmall,
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.filter_alt_outlined),
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Get.dialog(FieldDeviceFiltersDialog())
                                  .then((result) {
                                controller.updateMarkerLayer();
                              });
                            }, // Disable the button if currentPosition is null
                            color: primaryColor, // Disabled state color
                          ),
                        ),
                      ],
                    ),
                  ),
                  DraggableScrollableSheet(
                    initialChildSize:
                        0.12, // Initial height (12% of screen height)
                    minChildSize: 0.12, // Minimum height
                    maxChildSize: 0.6, // Maximum height
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Theme.of(context).dialogTheme.backgroundColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  height: 4,
                                  width: 40,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                ),
                              ),
                            ),
                            // Title
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Field Devices',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            // List of field devices
                            Obx(
                              () => SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    final fieldDevice = controller
                                        .mappableFieldDevices
                                        .elementAt(index);

                                    return Obx(
                                      () => Container(
                                        decoration: BoxDecoration(
                                          color: controller
                                                  .selectedFieldDeviceIds
                                                  .contains(fieldDevice.id)
                                              ? Color.alphaBlend(
                                                  primaryColor.withValues(
                                                      alpha: 0.1),
                                                  Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                                )
                                              : Theme.of(context)
                                                  .scaffoldBackgroundColor, // Highlight background for selected event
                                          border: controller
                                                  .selectedFieldDeviceIds
                                                  .contains(fieldDevice.id)
                                              ? Border.all(
                                                  color: controller
                                                          .selectedFieldDeviceIds
                                                          .contains(
                                                              fieldDevice.id)
                                                      ? primaryColor
                                                      : Colors.transparent,
                                                  width:
                                                      2) // Add border for selected event
                                              : null,
                                          borderRadius: BorderRadius.circular(
                                              8), // Optional: Add rounded corners
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 4,
                                            horizontal:
                                                8), // Add spacing between items
                                        child: ListTile(
                                          title: Text(
                                              "${fieldDevice.make} ${fieldDevice.deviceType.name}",
                                              style: TextStyle(
                                                  color: textPrimaryColor)),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('${fieldDevice.name}',
                                                  style: TextStyle(
                                                      color: textPrimaryColor)),
                                            ],
                                          ),
                                          onTap: () {
                                            controller
                                                .onObjectTap(fieldDevice.id);
                                            controller.mapController?.move(
                                                fieldDevice
                                                    .marker.marker!.first.point,
                                                controller.currentZoom.value,
                                                offset: const Offset(0, -150));
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  childCount:
                                      controller.mappableFieldDevices.length,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _map(
      BuildContext context,
      FieldDeviceMapController controller,
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
                  initialZoom: 12,
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
                controller.markerLayer.value,
              ]),
        ));
  }
}
