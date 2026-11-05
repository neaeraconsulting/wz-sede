import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:wzam/constants.dart';
import 'package:wzam/models/field_device_extensions.dart';
import 'package:wzam/models/field_device_type.dart';
import 'package:wzam/models/generated/field_device.pb.dart';
import 'package:wzam/models/generated/google/type/latlng.pb.dart' as pb;
import 'package:wzam/models/marked_location_type_extension.dart';
import 'package:wzam/models/marker_data.dart';
import 'package:wzam/models/wrappers/field_device_reading.dart';

class MappableFieldDevice {
  final String id;
  final int roadEventId;
  final int projectId;
  final DateTime lastUpdated;
  final String name;
  final String make;
  final String description;
  final FieldDeviceType deviceType;
  final FieldDevice fieldDevice;
  late MarkerData marker;
  MarkerData? selectedMarker;

  MappableFieldDevice({
    required this.id,
    required this.roadEventId,
    required this.projectId,
    required this.lastUpdated,
    required this.name,
    required this.make,
    required this.description,
    required this.deviceType,
    required this.fieldDevice,
    this.selectedMarker,
  });

  // Custom constructor using an initializer list
  MappableFieldDevice.fromFieldDevice(FieldDeviceReading fieldDeviceReading,
      {void Function(String)? onMarkerTap, MarkerData? markerData, MarkerData? selectedMarkerData})
      : id = fieldDeviceReading.device.id,
        roadEventId = fieldDeviceReading.device.roadEventId.toInt(),
        projectId = fieldDeviceReading.device.projectId.toInt(),
        lastUpdated = fieldDeviceReading.lastUpdated,
        name = fieldDeviceReading.device.coreDetails.name,
        make = fieldDeviceReading.device.coreDetails.make,
        description =
            "${fieldDeviceReading.device.coreDetails.name}, ${fieldDeviceReading.device.coreDetails.description}",
        deviceType = FieldDeviceType.fromFieldDevice(
          fieldDeviceReading.device,
        ),
        fieldDevice = fieldDeviceReading.device {
      if (markerData != null) {
        marker = markerData;
      } else {
        _initializeLayers(fieldDevice, onMarkerTap ?? ((_) {}));
      }
      if (selectedMarkerData != null) {
        selectedMarker = selectedMarkerData;
      } else {
        selectedMarker = createMarker(fieldDevice, onMarkerTap ?? ((_) {}), selected: true);
      }
  }

  // Example methods to generate markers and polylines
  void _initializeLayers(
      FieldDevice fieldDevice, void Function(String) onMarkerTap) {
    // Custom logic to generate markers from the FieldDevice
    marker = createMarker(fieldDevice, onMarkerTap);
  }

  MarkerData createMarker(FieldDevice fieldDevice, void Function(String) onTap,
      {bool selected = false}) {
    pb.LatLng point = fieldDevice.geometry.coordinates;
    Widget markerIcon;
    double width = 30.0;
    double height = 30.0;
    switch (deviceType) {
      case FieldDeviceType.arrowBoard:
        //markerIcon = fieldDevice.arrowBoard.pattern.icon;
        //markerIcon = Icon(Icons.bug_report);
        Widget arrowboardMarker = fieldDevice.arrowBoard.pattern.icon;
        //add a label underneath the arrowboardMarker
        markerIcon = Container(  
          width: 50,
          height: 50,
          child: Column(
            children: [
              Expanded(child: arrowboardMarker),
              Text(
                fieldDevice.coreDetails.make,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),

        );
        width = 50.0;
        height = 50.0;
        break;
      case FieldDeviceType.dynamicMessageSign:
        markerIcon = Image.asset(Constants.dynamicMessageSignIcon);
        break;
      case FieldDeviceType.camera:
        markerIcon = const Icon(Icons.camera_alt);
        break;
      case FieldDeviceType.fieldWorker:
        markerIcon = SvgPicture.asset(Constants.workerPositionIcon);
        break;
      case FieldDeviceType.trafficSignal:
        markerIcon = const Icon(Icons.traffic);
        break;
      case FieldDeviceType.flashingBeacon:
        markerIcon = Image.asset(Constants.flashingBeaconIcon);
        break;
      case FieldDeviceType.hybridSign:
        markerIcon = Image.asset(Constants.hybridSignIcon);
        break;
      case FieldDeviceType.locationMarker:
        Widget locationMarkerIcon = fieldDevice.locationType.icon;
        markerIcon = Container(  
          width: 50,
          height: 50,
          child: Column(
            children: [
              Expanded(child: locationMarkerIcon),
              Text(
                fieldDevice.coreDetails.make,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),

        );
        width = 60.0;
        height = 60.0;
        break;
      case FieldDeviceType.trafficSensor:
        markerIcon = Image.asset(Constants.trafficSensorIcon);
        break;
      case FieldDeviceType.mobileVehicle:
        markerIcon = const Icon(Icons.directions_car, color: Colors.black);
        break;
    }

    if (selected) {
      // Add a highlight or change the markerIcon for the selected state
      markerIcon = Container(
        width: width + 20,
        height: height + 20,
        decoration: BoxDecoration(
          color: Colors.yellow.withValues(alpha: 0.5), // Highlight color
          shape: BoxShape.circle,
        ),
        child: Center(child: markerIcon),
      );
    }
    Marker marker = Marker(
      width: width,
      height: height,
      point: LatLng(point.latitude, point.longitude),
      child: GestureDetector(
        onTap: () => onTap(fieldDevice.id),
        child: markerIcon,
      ),
    );
    return MarkerData(marker: [marker], polyline: null, polygon: null);
  }
}

