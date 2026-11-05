// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:wzam/models/date_time_json_converter.dart';
import 'package:wzam/models/lat_lng_json_converter.dart';

part 'mobile_vehicle_location.g.dart';

@JsonSerializable()
class MobileVehicleLocation {
  @JsonKey(name: 'road_event_id')
  final int? roadEventId;

  @JsonKey(name: 'worker_id')
  final String workerId;
  // keycloak ID of the user submitting the live report

  @JsonKey(
      name: 'timestamp',
      fromJson: DateTimeJsonConverter.fromJson,
      toJson: DateTimeJsonConverter.toJson)
  final DateTime timestamp;

  @JsonKey(name: 'is_active')
  final bool isActive;
  // whether the work is active, false if the user is driving to the work area

  @JsonKey(name: 'app_version')
  String appVersion;
  // version of the app that submitted the live report

  @JsonKey(name: 'license_plate')
  String licensePlate;
  // License plate of the vehicle to be associated with AVL data

  @JsonKey(name: 'operation_type')
  final MobileVehicleOperationType operationType;
  // defines how the datahub handles the submitted location

  @JsonKey(name: 'velocity_kph')
  final double velocityKph;
  @JsonKey(name: 'heading')
  final double heading;

  @JsonKey(
      name: 'location',
      fromJson: LatLngJsonConverter.fromJson,
      toJson: LatLngJsonConverter.toJson)
  final LatLng location;
  // list of long, lat
  @JsonKey(
      name: 'location_history',
      fromJson: LatLngJsonConverter.fromJsonList,
      toJson: LatLngJsonConverter.toJsonList)
  final List<LatLng> locationHistory;

  MobileVehicleLocation({
    required this.roadEventId,
    required this.workerId,
    required this.timestamp,
    required this.isActive,
    required this.appVersion,
    required this.licensePlate,
    required this.velocityKph,
    required this.heading,
    required this.operationType,
    required this.location,
    required this.locationHistory,
  });

  factory MobileVehicleLocation.fromJson(Map<String, dynamic> json) =>
      _$MobileVehicleLocationFromJson(json);

  Map<String, dynamic> toJson() => _$MobileVehicleLocationToJson(this);
}

enum MobileVehicleOperationType {
  @JsonValue('striping')
  STRIPING,
  @JsonValue('plowing')
  PLOWING,
  @JsonValue('mowing')
  MOWING,
  @JsonValue('general-active')
  GENERAL_ACTIVE,
  @JsonValue('general-inactive')
  GENERAL_INACTIVE,
}
