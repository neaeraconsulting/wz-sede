import 'package:flutter/material.dart';
import 'package:wzam/models/generated/field_device.pb.dart';

enum FieldDeviceType {
  arrowBoard,
  camera,
  dynamicMessageSign,
  flashingBeacon,
  hybridSign,
  locationMarker,
  trafficSensor,
  trafficSignal,
  mobileVehicle,
  fieldWorker;

  static FieldDeviceType fromFieldDevice(FieldDevice device) {
    return switch (device.whichDevice()) {
      FieldDevice_Device.arrowBoard => FieldDeviceType.arrowBoard,
      FieldDevice_Device.camera => FieldDeviceType.camera,
      FieldDevice_Device.dynamicMessageSign =>
        FieldDeviceType.dynamicMessageSign,
      FieldDevice_Device.flashingBeacon => FieldDeviceType.flashingBeacon,
      FieldDevice_Device.hybridSign => FieldDeviceType.hybridSign,
      FieldDevice_Device.locationMarker => FieldDeviceType.locationMarker,
      FieldDevice_Device.trafficSensor => FieldDeviceType.trafficSensor,
      FieldDevice_Device.trafficSignal => FieldDeviceType.trafficSignal,
      FieldDevice_Device.mobileVehicle => FieldDeviceType.mobileVehicle,
      FieldDevice_Device.fieldWorker => FieldDeviceType.fieldWorker,
      FieldDevice_Device.notSet => arrowBoard,
    };
  }
}

/// Extension to add a method that returns the associated text for each enum value.
extension FieldDeviceTypeExtension on FieldDeviceType {
  Icon get icon => switch (this) {
        FieldDeviceType.arrowBoard =>
          const Icon(Icons.arrow_back_outlined, color: Colors.orange),
        FieldDeviceType.camera =>
          const Icon(Icons.camera_alt_outlined, color: Colors.blue),
        FieldDeviceType.dynamicMessageSign =>
          const Icon(Icons.message_outlined, color: Colors.green),
        FieldDeviceType.flashingBeacon =>
          const Icon(Icons.lightbulb_outline, color: Colors.yellow),
        FieldDeviceType.hybridSign =>
          const Icon(Icons.signpost_outlined, color: Colors.purple),
        FieldDeviceType.locationMarker =>
          const Icon(Icons.location_on_outlined, color: Colors.red),
        FieldDeviceType.trafficSensor =>
          const Icon(Icons.sensor_door_outlined, color: Colors.teal),
        FieldDeviceType.trafficSignal =>
          const Icon(Icons.traffic_outlined, color: Colors.pink),
        FieldDeviceType.mobileVehicle =>
          const Icon(Icons.directions_car_outlined, color: Colors.brown),
        FieldDeviceType.fieldWorker =>
          const Icon(Icons.person_outlined, color: Colors.grey),
      };

  Icon getIcon(FieldDevice device) {
    // TODO: Use internal data to change icon, e.g. arrow direction
    return icon;
  }

  String get name => switch (this) {
        FieldDeviceType.arrowBoard => 'Arrow Board',
        FieldDeviceType.camera => 'Camera',
        FieldDeviceType.dynamicMessageSign => 'Dynamic Message Sign',
        FieldDeviceType.flashingBeacon => 'Flashing Beacon',
        FieldDeviceType.hybridSign => 'Hybrid Sign',
        FieldDeviceType.locationMarker => 'Location Marker',
        FieldDeviceType.trafficSensor => 'Traffic Sensor',
        FieldDeviceType.trafficSignal => 'Traffic Signal',
        FieldDeviceType.mobileVehicle => 'Mobile Vehicle',
        FieldDeviceType.fieldWorker => 'Field Worker',
      };
}
