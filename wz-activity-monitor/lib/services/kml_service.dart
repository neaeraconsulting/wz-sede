

import 'package:get/get.dart';
import 'package:wzam/models/recording.dart';
import 'package:wzam/services/web_file_picker.dart';
import 'package:geoxml/geoxml.dart';
import 'package:flutter/material.dart';
import 'package:wzam/ui/styles/theme_setting.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:wzam/ui/views/assign_kml_dialog.dart';

class KmlService extends GetxService {

  Future<void> selectAndUploadKmlFile(Recording recording, int numLanes, int speedLimit) async {
    BrowserSelectedFile? file = await pickFileFromSystem(acceptedExtensions: ['kml']);
    if (file != null) {
      String kmlString = String.fromCharCodes(file.bytes);
      print("Selected KML file content: $kmlString");
      Map<String, List<dynamic>> kmlData = await decodeKml(kmlString);
      List<Wpt> waypoints = kmlData['waypoints'] as List<Wpt>;
      List<Rte> routes = kmlData['routes'] as List<Rte>;
      List<Trk> tracks = kmlData['tracks'] as List<Trk>;
      Get.dialog(
        AssignKmlDialog(
            waypoints: waypoints,
            routes: routes,
            tracks: tracks,
            recording: recording,
            numLanes: numLanes,
            speedLimit: speedLimit,
        ),
        barrierDismissible: false,
      );
    } else {
      // No file was selected, handle accordingly if needed.
    }
  }

  Future<Map<String, List<dynamic>>> decodeKml(String kmlString) async {
    GeoXml geoData = await GeoXml.fromKmlString(kmlString);
    List<Wpt> waypoints = geoData.wpts;
    List<Rte> routes = geoData.rtes;
    List<Trk> tracks = geoData.trks;

    return {
      'waypoints': waypoints,
      'routes': routes,
      'tracks': tracks,
    };
  }

  Map<String, List<dynamic>> convertToFlutterMapWidgets(List<Wpt> waypoints, List<Rte> routes, List<Trk> tracks) {
    List<Marker> markers = [];
    List<Polyline> polylines = [];
    for (var wpt in waypoints) {
      print("Waypoint: ${wpt.name}, Lat: ${wpt.lat}, Lon: ${wpt.lon}");
      // You can create a Marker for each waypoint and add it to your Flutter Map.
      Marker marker = Marker (  
        point: LatLng(wpt.lat ?? 0.0, wpt.lon ?? 0.0),
        child: IconButton(
          icon: Icon(Icons.location_on),
          color: Colors.red,
          iconSize: 30,
          onPressed: () {
            Get.dialog(AlertDialog(
              title: Text(wpt.name ?? "Waypoint"),
              content: Text("Latitude: ${wpt.lat}, Longitude: ${wpt.lon}"),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text("Close"),
                ),
              ],
            ));
          },
        ),
      );
      markers.add(marker);
    }

    for (var rte in routes) {
      print("Route: ${rte.name}, Number of points: ${rte.rtepts.length}");
      List<LatLng> points = rte.rtepts.map((pt) => LatLng(pt.lat ?? 0.0, pt.lon ?? 0.0)).toList();
      Polyline polyline = Polyline(
        points: points,
        strokeWidth: 4.0,
        color: Colors.blue,
      );
      polylines.add(polyline);
    }
    return {
      'markers': markers,
      'polylines': polylines,
    };
  }

}