import 'package:flutter_map/flutter_map.dart';

class MarkerData {
  final List<Marker>? marker;
  final Polyline? polyline;
  final Polygon? polygon;

  MarkerData({
    required this.marker,
    required this.polyline,
    required this.polygon,
  });
}