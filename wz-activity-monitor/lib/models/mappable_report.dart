import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:wzam/models/report.dart';

class MappableReport {
  final int id;
  final DateTime? startDate;
  final DateTime? endDate;
  final ReportWithId report;
  late LatLng centerPoint;
  LatLngBounds? bounds;
  Marker? marker;
  Polyline? polyline;
  Polygon? polygon;

  MappableReport(
      {required this.id,
      required this.startDate,
      required this.endDate,
      required this.report,
      required this.marker,
      required this.polyline,
      required this.polygon,
      required this.centerPoint});

  // Custom constructor using an initializer list
  MappableReport.fromRoadEvent(this.report, {void Function(int)? onMarkerTap})
      : id = report.id.toInt(),
        startDate = report.startDate,
        endDate = report.endDate {
    _initializeLayers(report, onMarkerTap ?? ((_) {}));
  }

  // Example methods to generate markers and polylines
  void _initializeLayers(Report report, void Function(int) onMarkerTap) {
    // Custom logic to generate markers from the Report
    switch (report.geometryType) {
      case GeometryType.polygon:
        polygon = createPolygon(report.geometry);
        // compute centerpoint of polygon
        centerPoint = report.geometry.reduce((a, b) => LatLng(
            (a.latitude + b.latitude) / 2, (a.longitude + b.longitude) / 2));
        bounds = getBounds(report.geometry);
        return;
      case GeometryType.linestring:
        polyline = createPolyline(report.geometry);
        centerPoint = report.geometry.reduce((a, b) => LatLng(
            (a.latitude + b.latitude) / 2, (a.longitude + b.longitude) / 2));
        bounds = getBounds(report.geometry);
        return;
      case GeometryType.multipoint:
        marker = createMarker(report.geometry[0], onMarkerTap);
        centerPoint = report.geometry[0];
        bounds = getBounds([report.geometry[0]]);
        return;
    }
  }

  Polygon createPolygon(List<LatLng> points, {bool selected = false}) {
    return Polygon(
      color: selected ? Colors.blue.withAlpha(50) : Colors.orange.withAlpha(70),
      borderColor: selected ? Colors.blue : Colors.orange,
      hitValue: id,
      points: points,
    );
  }

  Polyline createPolyline(List<LatLng> points, {bool selected = false}) {
    return Polyline(
      color: selected ? Colors.blue : const Color.fromARGB(255, 0, 255, 8),
      strokeWidth: 6,
      hitValue: id,
      points: points,
    );
  }

  Marker createMarker(LatLng point, void Function(int) onTap,
      {bool selected = false}) {
    return Marker(
      child: GestureDetector(
        onTap: () => onTap(id),
        child: Icon(Icons.warning_rounded,
            color: selected ? Colors.blue : Colors.orange,
            size: selected ? 30 : 20),
      ),
      point: point,
    );
  }

  LatLngBounds getBounds(List<LatLng> coordinates) {
    if (coordinates.isEmpty) {
      return LatLngBounds(const LatLng(0, 0), const LatLng(0, 0));
    } else if (coordinates.length == 1) {
      return LatLngBounds(coordinates.first, coordinates.first);
    }
    double minLat =
        coordinates.map((c) => c.latitude).reduce((a, b) => a < b ? a : b);
    double maxLat =
        coordinates.map((c) => c.latitude).reduce((a, b) => a > b ? a : b);
    double minLng =
        coordinates.map((c) => c.longitude).reduce((a, b) => a < b ? a : b);
    double maxLng =
        coordinates.map((c) => c.longitude).reduce((a, b) => a > b ? a : b);
    return LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng));
  }
}
