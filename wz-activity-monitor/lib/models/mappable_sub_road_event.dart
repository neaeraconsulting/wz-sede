import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as map;
import 'package:wzam/models/base_layer_type_extension.dart';
import 'package:wzam/models/generated/road_sub_event.pb.dart';
import 'package:wzam/models/marker_data.dart';
import 'package:wzam/models/pair.dart';
import 'package:wzam/models/speed_reduction_layer_type_extension.dart';
import 'package:wzam/models/worker_presence_layer_type_extension.dart';
import 'package:wzam/models/wrappers/road_sub_event_wrapper.dart';
import 'package:wzam/services/geometry_service.dart';

class MappableRoadSubEvent {
  final int id;
  final int projectId;
  final List<RoadSubEventWrapper> roadSubEventWrappers;
  late MarkerData markers;


  MappableRoadSubEvent(
      {required this.id,
      required this.projectId,
      required this.roadSubEventWrappers,
      required this.markers});

  // Custom constructor using an initializer list
  MappableRoadSubEvent.fromRoadSubEvent(
      RoadSubEventWrapper roadSubEventWrapper, this.markers)
      : id = roadSubEventWrapper.roadSubEvent.id.toInt(),
        projectId = roadSubEventWrapper.roadSubEvent.projectId.toInt(),
        roadSubEventWrappers = [roadSubEventWrapper];

  MappableRoadSubEvent.fromRoadSubEventTwo(RoadSubEventWrapper roadSubEventWrapper,
      {void Function(String)? onMarkerTap, MarkerData? markerData})
      : id = roadSubEventWrapper.roadSubEvent.id.toInt(),
        projectId = roadSubEventWrapper.roadSubEvent.projectId.toInt(),
        roadSubEventWrappers = [roadSubEventWrapper]{
      if (markerData != null) {
        markers = markerData;
      } else {
        markers = _createMarker(roadSubEventWrapper, onMarkerTap ?? ((_) {}));
      }
  }


  MarkerData _createMarker(RoadSubEventWrapper roadSubEventWrapper, void Function(String) onTap) {
    RoadSubEvent subEvent = roadSubEventWrapper.roadSubEvent;
    List<Marker> marker = [];
    Polyline? polyline;
    Polygon? polygon;
    if (subEvent.whichGeometry() == RoadSubEvent_Geometry.point) {
      marker.add(createSubRoadEventMarker(subEvent, onTap, subEvent.point.coordinates));
    } else if (subEvent.whichGeometry() == RoadSubEvent_Geometry.lineString) {
      try {
        Pair<Polyline, Marker> subRoadMarkerInfo =
            createSubRoadPolyline(subEvent, onTap);
        polyline = subRoadMarkerInfo.first;
        marker.add(subRoadMarkerInfo.last);
      } catch (e) {
        print("Error creating sub road polyline: $e");
      }
    } else if (subEvent.whichGeometry() == RoadSubEvent_Geometry.polygon) {
      //polygon = createRoadPolygon(subEvent);
    }
    return MarkerData(marker: marker.isNotEmpty ? marker : null, polyline: polyline, polygon: polygon);
  }

  Marker createSubRoadEventMarker(RoadSubEvent roadSubEvent, void Function(String)? onTap, var coordinates) {
    Widget markerIcon = const Icon(Icons.bug_report);
    if (roadSubEvent.hasBaseLayer()) {
      markerIcon = roadSubEvent.baseLayer.icon;
    }
    if (roadSubEvent.hasWorkerPresenceLayer()) {
      markerIcon = roadSubEvent.workerPresenceLayer.icon;
    }
    if (roadSubEvent.hasSpeedReductionLayer()) {
      markerIcon = roadSubEvent.speedReductionLayer.icon;
    }
    return Marker(
        width: 35.0,
        height: 35.0,
        rotate: true,
        point: map.LatLng(coordinates.latitude, coordinates.longitude),
        child: GestureDetector(  
          onTap: () {
            onTap!(roadSubEvent.id.toString());
          },
          child: markerIcon,
        ) 
    );
  }

  Pair<Polyline, Marker> createSubRoadPolyline(RoadSubEvent roadSubEvent, void Function(String)? onMarkerTap) {
    List<Color> randomColor = [
      Colors.yellow,
      const Color.fromARGB(255, 204, 183, 0),
      const Color.fromARGB(255, 252, 206, 0),
      const Color.fromARGB(255, 255, 220, 63),
    ];
    Random random = Random();
    List<map.LatLng> sidePoints = GeometryService.getSideLineCoordinates(roadSubEvent.lineString.coordinates.coordinates);
    Polyline polyline = Polyline(
      points: sidePoints,
      color: randomColor[random.nextInt(randomColor.length)],
      strokeWidth: 4,
      hitValue: [roadSubEvent.id.toInt(), true],
    );
    map.LatLng coordinates = sidePoints[sidePoints.length ~/ 2];
    if (sidePoints.length == 4) {
      double averageLat = (sidePoints[1].latitude + sidePoints[2].latitude)/2;
      double averageLng = (sidePoints[1].longitude + sidePoints[2].longitude)/2;
      coordinates = map.LatLng(averageLat, averageLng);
    }
    Marker marker = createSubRoadEventMarker(roadSubEvent, onMarkerTap, coordinates);
    return Pair(polyline, marker);
  }
}
