import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:wzam/app_config.dart';
import 'package:wzam/controllers/dashboard_controller.dart';
import 'package:wzam/controllers/mile_marker_controller.dart';
import 'package:wzam/ui/styles/screen_size.dart';

class DashboardMapWidget extends StatefulWidget {
  const DashboardMapWidget({
    super.key,
    required this.dashboardController,
    required this.mileMarkerController,
    required this.onMapCenterChanged,
  });

  final DashboardController dashboardController;
  final MileMarkerController mileMarkerController;
  final ValueChanged<LatLng> onMapCenterChanged;

  @override
  State<DashboardMapWidget> createState() => _DashboardMapWidgetState();
}

class _DashboardMapWidgetState extends State<DashboardMapWidget> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth(context),
      height: screenHeight(context),
      child: Obx(
        () => FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: AppConfig.defaultMapCenter,
            initialZoom: 8,
            onMapReady: () {
              widget.dashboardController.mapController = _mapController;
            },
            onMapEvent: (event) {
              widget.dashboardController.currentZoom.value = event.camera.zoom;
              widget.onMapCenterChanged(event.camera.center);
            },
            onTap: (tapPosition, point) {
              widget.dashboardController.handleMapTap();
            },
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://api.mapbox.com/styles/v1/mapbox/satellite-streets-v11/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}',
              additionalOptions: {
                'accessToken': AppConfig.mapboxAccessToken,
                'id': 'mapbox.satellite',
              },
            ),
            widget.mileMarkerController.getMilepostLayer(),
            widget.dashboardController.polygonLayer.value,
            widget.dashboardController.currentZoom.value >= 10.0
                ? widget.dashboardController.polylineLayer.value
                : widget.dashboardController.roadEventPolylineLayer.value,
            widget.dashboardController.currentZoom.value >= 10.0
                ? widget.dashboardController.markerLayer.value
                : const MarkerLayer(markers: []),
          ],
        ),
      ),
    );
  }
}
