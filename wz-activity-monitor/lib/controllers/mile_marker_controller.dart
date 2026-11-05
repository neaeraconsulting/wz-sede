import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:wzam/controllers/mile_marker_painter.dart';

class MileMarkerController extends GetxController {
  var markers = <Marker>[].obs;
  var geojsonData = <dynamic>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    print('Initializing MileMarkerController');
    try {
      isLoading.value = true;

      // Load the GeoJSON file from assets
      final String jsonString =
          await rootBundle.loadString('assets/maps/formatted_markers.geojson');

      // Parse the JSON string
      final Map<String, dynamic> geoJson = json.decode(jsonString);

      // Extract features and call loadGeoJson
      final List<dynamic> features = (geoJson['features'] ?? []).where((marker) => marker['properties'] != null && marker['properties']['label'] != null && marker['properties']['label'] != "0").toList();
      geojsonData.value = features;
      loadGeoJson(features);
    } catch (e) {
      print('Error loading mile markers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void loadGeoJson(List<dynamic> features) {
    markers.value = features.map((f) {
      return Marker(
        width: 30,
        height: 30,
        point: LatLng(
            f['geometry']['coordinates'][1], f['geometry']['coordinates'][0]),
        child: _buildMilepostWidget(f['properties']['label']),
      );
    }).toList();
  }

  Widget _buildMilepostWidget(String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.green, width: 2),
        borderRadius: BorderRadius.circular(2),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
      ),
    );
  }

  MobileLayerTransformer getMilepostLayer() {
    return MobileLayerTransformer(
      child: Builder(
        builder: (context) {
          final camera = MapCamera.of(context);
          const minZoom = 11.0;
          if (camera.zoom < minZoom) {
            return const SizedBox.shrink();
          }
          return CustomPaint(
            painter: MilepostPainter(
              geojsonData,
              camera,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}
