import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:wzam/app_config.dart';
import 'package:wzam/controllers/mile_marker_controller.dart';
import 'package:wzam/controllers/mobile_vehicle_map_controller.dart';
import 'package:wzam/models/pair.dart';
import 'package:wzam/models/position_extensions.dart';
import 'package:wzam/ui/pages/home.dart';
import 'package:wzam/ui/pages/settings.dart';
import 'package:wzam/ui/styles/screen_size.dart';
import 'package:wzam/models/wzdx_extensions.dart';
import 'package:wzam/ui/styles/spacing.dart';
import 'package:wzam/ui/styles/app_colors.dart';
import 'package:wzam/ui/styles/widgets/location_health_banner.dart';
import 'package:wzam/ui/views/stop_mobile_vehicle_dialog.dart';

class MobileVehicleMap extends StatelessWidget {
  const MobileVehicleMap({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MobileVehicleMapController());
    final mileMarkerController = Get.find<MileMarkerController>();
    final mapController = MapController();
    controller.startMobileVehicleSession(
        controller.operationType.value, controller.licensePlate.value);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        print("Back button pressed, didPop: $didPop, result: $result");
        bool shouldPop = await Get.dialog(stopMobileVehicle());
        if (shouldPop) {
          controller.stopLiveWorkerSession();
          Get.offAll(Home());
        }
      },
      child: FutureBuilder(
          future: controller.initialize(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Mobile Vehicle Map'),
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
                  title: const Text('Mobile Vehicle Map'),
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
                        Positioned(
                          top: 10,
                          left: 5,
                          child: SizedBox(
                            width: screenWidth(context) * 0.78,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                liveWorkerDisplay(context, controller),
                                verticalSpaceSmall,
                                controls(controller, context),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 30,
                          right: 30,
                          left: 30,
                          child: stopMobileVehicleButton(controller),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: mapTrackingButton(controller),
                        ),
                        Obx(() => controller.loadingMobileVehicle.value
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
      MobileVehicleMapController controller,
      MapController mapController,
      MileMarkerController mileMarkerController,
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
                initialZoom: 17,
                onMapReady: () {
                  controller.mapController = mapController;
                },
                onMapEvent: (event) {
                  controller.currentZoom.value = event.camera.zoom;
                  if (event is MapEventMoveStart) {
                    if (controller.isMapFollowingVehicle.value) {
                      controller.isMapFollowingVehicle.value = false;
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
              Obx(
                () {
                  final bool isHealthy =
                      !controller.locationStatusBanner.isOffline;
                  return MarkerLayer(markers: [
                    Marker(
                        point: controller.lastLiveWorkerLocation?.getLatLng() ??
                            AppConfig.defaultMapCenter,
                        width: 45,
                        height: 45,
                        rotate: true,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                              border: Border.all(
                                  color: isHealthy ? primaryColor : Colors.grey,
                                  width: 2.0),
                            ),
                            child: isHealthy
                                ? controller.mobileVehicleActiveMarker.value
                                : controller.mobileVehicleInactiveMarker.value,
                          ),
                        ))
                  ]);
                },
              )
            ])));
  }

  Widget liveWorkerDisplay(
      BuildContext context, MobileVehicleMapController controller) {
    final bool compact = screenWidth(context) < 420;
    return LocationHealthBanner(
      model: controller.locationStatusBanner,
      fontSize: compact ? 14 : 16,
      padding: const EdgeInsets.all(14.0),
      compact: compact,
    );
  }

  Widget mapTrackingButton(MobileVehicleMapController controller) {
    return GestureDetector(
        child: Container(
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.0),
            color: Theme.of(Get.context!)
                .scaffoldBackgroundColor
                .withValues(alpha: 0.8),
          ),
          child: Icon(controller.isMapFollowingVehicle.value
              ? Icons.my_location
              : Icons.location_searching),
        ),
        onTap: () {
          controller.isMapFollowingVehicle.value =
              !controller.isMapFollowingVehicle.value;
          controller.updateMap();
        });
  }

  Widget inputField(String labelText, Rx<String> rxValue) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Theme.of(Get.context!).scaffoldBackgroundColor,
      ),
      onChanged: (value) async {
        rxValue.value = value;
      },
    );
  }

  Widget controls(MobileVehicleMapController controller, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!)
            .scaffoldBackgroundColor
            .withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 250,
              child: dropdownField(
                  "Operation Type",
                  MobileVehicleOperationTypeExtensions.getPairs(),
                  controller.operationType,
                  context,
                  controller: controller),
            ),
            verticalSpaceSmall,
            SizedBox(
                width: 250,
                child: inputField("License Plate", controller.licensePlate)),
          ],
        ),
      ),
    );
  }

  Widget stopMobileVehicleButton(MobileVehicleMapController controller) {
    return ElevatedButton(
      onPressed: () {
        controller.stopLiveWorkerSession();
        Get.offAll(Home());
      },
      child: const Text("Stop Mobile Vehicle Session"),
    );
  }

  static Widget dropdownField<T>(String labelText,
      List<Pair<T, String>> options, Rx<T> selectedValue, BuildContext context,
      {bool lightTheme = false, MobileVehicleMapController? controller}) {
    return DropdownButtonFormField(
        initialValue: selectedValue.value,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        isExpanded: true,
        menuMaxHeight: screenHeightPercentage(context, percentage: 0.5),
        dropdownColor: lightTheme
            ? lightBackgroundColor
            : Theme.of(context).dialogTheme.backgroundColor,
        items: options
            .map((p) => DropdownMenuItem(
                  value: p.first,
                  child: Text(p.last,
                      style: lightTheme
                          ? const TextStyle(color: Colors.black)
                          : null),
                ))
            .toList(),
        onChanged: (value) async {
          selectedValue.value = value as T;
          if (controller != null) {
            controller.getMobileVehicleMarker(controller);
          }
        });
  }
}
