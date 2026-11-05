import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:wzam/controllers/notification_controller.dart';
import 'package:wzam/models/position_extensions.dart';
import 'package:wzam/services/location_service.dart';

import '../ui/styles/app_colors.dart';

//This controller is used to manage the report location selection map and the report location point
class ReportLocationSelectionController extends GetxController {
  late MapController? mapController;
  LocationService locationService = Get.find<LocationService>();
  Rx<MarkerLayer> markerLayer = const MarkerLayer(markers: <Marker>[]).obs;
  Rx<PolylineLayer> polylineLayer =
      const PolylineLayer(polylines: <Polyline>[]).obs;
  Rx<PolygonLayer> polygonLayer = const PolygonLayer(polygons: <Polygon>[]).obs;
  RxList<LatLng> points = <LatLng>[].obs;
  RxList<LatLng> borderPoints = <LatLng>[].obs;
  RxInt selectedPoint = (-1).obs;
  RxDouble lineWidth = 0.0.obs;
  RxBool isLoading = true.obs;

  Future<void> initialize(RxList<LatLng> initialPoints) async {
    isLoading.value = true;
    await locationService.getCurrentLocation();
    borderPoints = <LatLng>[].obs;
    points.clear();
    if (initialPoints.isNotEmpty) {
      points.addAll(initialPoints);
    }
    _updateMarkerLayer();
    _loadPolylineLayer();
    _loadPolygonLayer();
    _moveMapToReportBounds();
    isLoading.value = false;
  }

  Marker _createUserMaker(Position position) {
    return Marker(
        point: position.getLatLng(),
        child: Image.asset('assets/images/location_with_border.png',
            width: 25.0, height: 25.0),
        rotate: true);
  }

  void changeOrAddMarker(TapPosition position, LatLng point) {
    if (selectedPoint.value != -1) {
        _editPointInPolylineLayer(point);
      selectedPoint.value = -1;
    } else {
        _addPointToPolylineLayer(point);
    }
    _updateMarkerLayer();
  }

  void _updateMarkerLayer() {
    List<Marker> markers = <Marker>[];
    Position? position = locationService.currentPosition.value;
    if (position != null) {
      markers.add(_createUserMaker(position));
    }
    for (LatLng point in points) {
      markers.add(Marker(
          point: point,
          child: GestureDetector(
                onTap: () {
                  selectedPoint.value = points.indexOf(point);
                  _updateMarkerLayer();
                },
                child: points.indexOf(point) == selectedPoint.value
                        ? selectedDot()
                        : standardDot(),
              )));
    }
    markerLayer.value = MarkerLayer(markers: markers);
  }

  void _moveMapToReportBounds() {
    if (points.isEmpty || mapController == null) {
      return;
    }
    if (points.length == 1) {
      // For a single point, move camera to that point with a fixed zoom
      mapController?.move(points.first, 15.0); // Adjust zoom level as needed
    } else {
      // For multiple points, fit to bounds
      LatLngBounds bounds = LatLngBounds.fromPoints(points);
      CameraFit cameraFit = CameraFit.bounds(
          bounds: bounds,
          padding:
              const EdgeInsets.symmetric(horizontal: 15.0, vertical: 50.0));
      mapController?.fitCamera(cameraFit);
    }
  }

  void _loadPolylineLayer() {
    if (points.isNotEmpty) {
      Polyline reportZonePolyline = Polyline(
        points: points,
        strokeWidth: 5.0,
        color: primaryColor,
      );
      polylineLayer.value =
          PolylineLayer(polylines: <Polyline>[reportZonePolyline]);
    }
  }

  void _loadPolygonLayer() {
    if (points.isNotEmpty) {
        List<Polygon> borderZones = _generateLineBorderShape(points);
        polygonLayer.value = PolygonLayer(polygons: borderZones);
    }
  }

  Widget selectedDot() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1.0),
      ),
      child: Icon(Icons.circle, color: primaryColor, size: 25.0),
    );
  }

  Widget standardDot() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(color: Colors.transparent, width: 2.0),
      ),
      child: Icon(Icons.circle, color: primaryColor, size: 20.0),
    );
  }

  void _addPointToPolylineLayer(LatLng point) {
      points.add(point);
    Polyline reportZonePolyline = Polyline(
      points: points,
      strokeWidth: 5.0,
      color: primaryColor,
    );
    polylineLayer.value =
        PolylineLayer(polylines: <Polyline>[reportZonePolyline]);
  }

  void _editPointInPolylineLayer(LatLng point) {
      points[selectedPoint.value] = point;
    Polyline reportZonePolyline = Polyline(
      points: points,
      strokeWidth: 5.0,
      color: primaryColor,
    );
    polylineLayer.value =
        PolylineLayer(polylines: <Polyline>[reportZonePolyline]);
  }

  List<Polygon> _generateLineBorderShape(List<LatLng> points) {
    double widthInMeters = lineWidth.value;
    double widthInDegreesLat =
        widthInMeters / 111320.0; // Approximate conversion factor for latitude
    double widthInDegreesLon = widthInMeters /
        (111320.0 *
            cos(points[0].latitude *
                (pi / 180.0))); // Approximate conversion factor for longitude
    List<Polygon> borderZones = <Polygon>[];
    for (int i = 0; i < points.length - 1; i++) {
      double x1 = points[i].latitude;
      double y1 = points[i].longitude;
      double x2 = points[i + 1].latitude;
      double y2 = points[i + 1].longitude;
      double angle = (x1 == x2)
          ? pi / 2
          : (y1 == y2)
              ? 0.0
              : atan((y2 - y1) / (x2 - x1));
      double angle1 = angle + (pi / 2);
      double angle2 = angle - (pi / 2);
      double offsetX = widthInDegreesLat;
      double offsetY = widthInDegreesLon;
      double x3 = x1 + (offsetX / 2) * cos(angle1);
      double y3 = y1 + (offsetY / 2) * sin(angle1);
      double x4 = x1 + (offsetX / 2) * cos(angle2);
      double y4 = y1 + (offsetY / 2) * sin(angle2);
      double x5 = x3 + (x2 - x1);
      double y5 = y3 + (y2 - y1);
      double x6 = x4 + (x2 - x1);
      double y6 = y4 + (y2 - y1);
      Polygon reportZonePolygon = Polygon(
        points: [
          LatLng(x3, y3),
          LatLng(x5, y5),
          LatLng(x6, y6),
          LatLng(x4, y4)
        ],
        color: primaryColor.withValues(alpha: 0.5),
      );
      borderZones.add(reportZonePolygon);
    }
    return borderZones;
  }

  void clearReportZonePoints() {
    points.clear();
    _updateMarkerLayer();
    polylineLayer.value = const PolylineLayer(polylines: <Polyline>[]);
    polygonLayer.value = const PolygonLayer(polygons: <Polygon>[]);
  }

  void saveReportLocationPoint() {
    if (points.length < 2) {
      NotificationController().queueNotification('Invalid Location Line',
          'Please select at least two points for the report location line');
      return;
    }
    Get.back(result: points);
  }
}
