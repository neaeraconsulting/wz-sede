import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:wzam/models/generated/road_event.pb.dart';
import 'package:wzam/models/marker_data.dart';
import 'package:wzam/models/wrappers/road_event_wrapper.dart';
import 'package:wzam/services/protobuf_utils.dart';

class MappableRoadEvent {
  final int id;
  final int projectId;
  final DateTime startDate;
  final DateTime endDate;
  final RoadEvent roadEvent;
  late LatLng centerPoint;
  LatLngBounds? bounds;
  MarkerData markers;
  RxBool showFieldDevices = false.obs;


  MappableRoadEvent(
      {required this.id,
      required this.projectId,
      required this.startDate,
      required this.endDate,
      required this.roadEvent,
      required this.markers,
      required this.centerPoint});

  // Custom constructor using an initializer list
  MappableRoadEvent.fromRoadEvent(
      RoadEventWrapper roadEventWrapper, this.markers)
      : id = roadEventWrapper.roadEvent.id.toInt(),
        projectId = roadEventWrapper.roadEvent.projectId.toInt(),
        startDate =
            ProtobufUtils.fromTimestamp(roadEventWrapper.roadEvent.startDate),
        endDate =
            ProtobufUtils.fromTimestamp(roadEventWrapper.roadEvent.endDate),
        roadEvent = roadEventWrapper.roadEvent {
    _initializeBoundsAndCenter(roadEvent);
  }

  void _initializeBoundsAndCenter(RoadEvent roadEvent) {
    // Custom logic to generate markers from the RoadEvent
    switch (roadEvent.whichGeometry()) {
      case RoadEvent_Geometry.polygon:
        // compute centerpoint of polygon
        centerPoint = roadEvent.polygon.coordinates.coordinates
            .map((p) => LatLng(p.latitude, p.longitude))
            .reduce((a, b) => LatLng((a.latitude + b.latitude) / 2,
                (a.longitude + b.longitude) / 2));
        bounds = getBounds(roadEvent.polygon.coordinates.coordinates
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList());
        return;
      case RoadEvent_Geometry.lineString:
        centerPoint = roadEvent.lineString.coordinates.coordinates
            .map((p) => LatLng(p.latitude, p.longitude))
            .reduce((a, b) => LatLng((a.latitude + b.latitude) / 2,
                (a.longitude + b.longitude) / 2));
        bounds = getBounds(roadEvent.lineString.coordinates.coordinates
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList());
        return;
      case RoadEvent_Geometry.point:
        centerPoint = LatLng(roadEvent.point.coordinates.latitude,
            roadEvent.point.coordinates.longitude);
        bounds = getBounds([
          LatLng(roadEvent.point.coordinates.latitude,
              roadEvent.point.coordinates.longitude)
        ]);
        return;
      default:
        break;
    }
    return;
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
