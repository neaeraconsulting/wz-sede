import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:wzam/app_config.dart';
import 'package:wzam/controllers/report_location_selection_controller.dart';
import 'package:wzam/models/position_extensions.dart';
import 'package:wzam/ui/styles/app_colors.dart';
import 'package:wzam/ui/styles/screen_size.dart';
import 'package:wzam/ui/styles/text_styles.dart';

//This is the map that pops up while making a report to place the workers location
class ReportLocationSelection extends StatelessWidget {
  
  final RxList<LatLng>? points;
  const ReportLocationSelection(this.points, {super.key}); 

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReportLocationSelectionController());
    controller.initialize(points ?? RxList<LatLng>([]));
    final mapController = MapController();
          return Scaffold(
            appBar: AppBar(
              title: const Text('Work Zone Area Selection'),
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  _map(context, controller, mapController,
                      MediaQuery.of(context).orientation),
                  Positioned(
                    top: 10,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                        width: screenWidth(context) - 40,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'Tap on the map to select the location of the work zone area',
                              style: styleThree.copyWith(color: textPrimaryColor),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 20,
                    right: 20,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 40),
                      child: Column(
                            children: [
                              Obx(() => ElevatedButton(
                                      onPressed: controller.points.isNotEmpty
                                          ? () {
                                              controller.clearReportZonePoints();
                                            }
                                          : null,
                                      child: const Text('Clear Report Zone'),
                                    )),
                              ElevatedButton(
                                onPressed: () {
                                  controller.saveReportLocationPoint();
                                },
                                child: const Text('Save Report Zone'),
                              ),
                            ],
                          ),
                    ),
                  ),
                  Obx(() => controller.isLoading.value
                      ? const Center(
                            child: CircularProgressIndicator(),
                          )
                      : const SizedBox.shrink())
                ],
              ),
            ),
    );
  }

  Widget _map(
      BuildContext context,
      ReportLocationSelectionController controller,
      MapController mapController,
      Orientation orientation) {
    return Obx(() => SizedBox(
          width: screenWidth(context),
          height: screenHeight(context),
          child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: controller.locationService.currentPosition.value
                        ?.getLatLng() ??
                    AppConfig.defaultMapCenter,
                initialZoom:
                    controller.locationService.currentPosition.value != null
                        ? 20
                        : 8,
                onMapReady: () {
                  controller.mapController = mapController;
                },
                onTap: (TapPosition position, LatLng latlng) {
                  controller.changeOrAddMarker(position, latlng);
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
                controller.polygonLayer.value,
                controller.polylineLayer.value,
                controller.markerLayer.value,
              ]),
        ));
  }
}
