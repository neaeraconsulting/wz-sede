import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:wzam/app_config.dart';
import 'package:wzam/controllers/mile_marker_controller.dart';
import 'package:wzam/controllers/road_event_map_controller.dart';
import 'package:wzam/models/position_extensions.dart';
import 'package:wzam/ui/pages/settings.dart';
import 'package:wzam/ui/styles/app_colors.dart';
import 'package:wzam/ui/styles/screen_size.dart';

class RoadEventList extends StatelessWidget {
  final int? selectedProjectId;
  final int? selectedRoadEventId;
  const RoadEventList(
      {this.selectedProjectId, this.selectedRoadEventId, super.key});

  @override
  Widget build(BuildContext context) {
    RoadEventMapController controller = Get.put(RoadEventMapController());
    final mileMarkerController = Get.find<MileMarkerController>();
    final mapController = MapController();

    return FutureBuilder(
        future: controller.initialize(
            selectedProjectId: selectedProjectId,
            selectedRoadEventId: selectedRoadEventId),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Road Event Selection'),
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
              title: const Text('Select Road Event'),
            ),
            body: Stack(
              children: [
                _map(context, controller, mapController, mileMarkerController,
                    MediaQuery.of(context).orientation),
                // Button in the top-right corner
                Positioned(
                  top: 16,
                  right: 16,
                  left: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: controller.selectedRoadEvent.value != null
                                ? () {
                                    Get.back(
                                      result: controller.completeRoadEventsList
                                          .firstWhereOrNull((e) =>
                                              e.id ==
                                              controller.selectedRoadEvent.value)
                                          ?.roadEvent,
                                    );
                                  }
                                : null, // Disable the button if selectedRoadEvent is null
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(4), // Rounded corners
                              ),
                              backgroundColor:
                                  controller.selectedRoadEvent.value != null
                                      ? Colors.orange // Enabled state color
                                      : Colors.grey, // Disabled state color
                            ),
                            child: const Text(
                              'Confirm Selection',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => Container(
                          decoration: BoxDecoration(
                            color: Colors.white, // White background
                            borderRadius:
                                BorderRadius.circular(4), // Rounded corners
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.my_location),
                            padding: EdgeInsets.zero,
                            onPressed: controller.locationService
                                        .currentPosition.value !=
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
                            color: controller.locationService.currentPosition
                                        .value !=
                                    null
                                ? primaryColor // Enabled state color
                                : Colors.grey, // Disabled state color
                          ),
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
                                'Road Events',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          // List of road events
                          Obx(
                            () => SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  final roadEvent =
                                      controller.roadEventMap.elementAt(index);

                                  return Obx(
                                    () => Container(
                                      decoration: BoxDecoration(
                                        color: controller
                                                    .selectedRoadEvent.value ==
                                                roadEvent.id
                                            ? primaryColor.withValues(alpha: 0.2)
                                            : null, // Highlight background for selected event
                                        border: controller
                                                    .selectedRoadEvent.value ==
                                                roadEvent.id
                                            ? Border.all(
                                                color: primaryColor,
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
                                          "${roadEvent.id}: ${roadEvent.roadEvent.name}",
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(roadEvent
                                                .roadEvent.description),
                                            Text(
                                              '${DateFormat.yMMMd().format(roadEvent.startDate)} - ${DateFormat.yMMMd().format(roadEvent.endDate)}',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[800]),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          controller.selectedRoadEvent.value =
                                              roadEvent
                                                  .id; // Update selected road event
                                          controller.mapController?.fitCamera(
                                              CameraFit.bounds(
                                                  bounds: roadEvent.bounds!,
                                                  maxZoom: 14,
                                                  padding: const EdgeInsets.all(
                                                      40))); // Fit map to selected road event bounds
                                        },
                                      ),
                                    ),
                                  );
                                },
                                childCount: controller.roadEventMap.length,
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
          );
        });
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
