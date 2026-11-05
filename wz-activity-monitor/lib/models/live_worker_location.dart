// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:wzam/models/date_time_json_converter.dart';
import 'package:wzam/models/lat_lng_json_converter.dart';

part 'live_worker_location.g.dart';

@JsonSerializable()
class LiveWorkerLocation {
  @JsonKey(name: 'road_event_id')
  final int roadEventId;
  // required, ID of report associated with the live position.
  // This ID is only present in the datahub response,
  // so the device must sync with the cloud to start a live report

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

  @JsonKey(name: 'location_type')
  final WorkerLocationType locationType;
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

  LiveWorkerLocation({
    required this.roadEventId,
    required this.workerId,
    required this.timestamp,
    required this.isActive,
    required this.appVersion,
    required this.velocityKph,
    required this.heading,
    required this.locationType,
    required this.location,
    required this.locationHistory,
  });

  factory LiveWorkerLocation.fromJson(Map<String, dynamic> json) =>
      _$LiveWorkerLocationFromJson(json);

  Map<String, dynamic> toJson() => _$LiveWorkerLocationToJson(this);
}

enum WorkerLocationType {
  @JsonValue('worker')
  WORKER,
  @JsonValue('flagger')
  FLAGGER,
  @JsonValue('mobile-operator')
  MOBILE_OPERATOR,
}
