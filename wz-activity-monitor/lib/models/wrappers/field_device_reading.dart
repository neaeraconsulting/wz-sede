import 'package:json_annotation/json_annotation.dart';
import 'package:wzam/models/generated/field_device.pb.dart';
import 'package:wzam/models/datahub/route_and_measure.dart';

class FieldDeviceReading {
  @JsonKey(name: 'route_and_measure')
  final RouteAndMeasure? routeAndMeasure;
  @JsonKey(name: 'last_updated')
  final DateTime lastUpdated;
  @JsonKey(name: 'device')
  final FieldDevice device;

  FieldDeviceReading({
    required this.routeAndMeasure,
    required this.lastUpdated,
    required this.device,
  });

  static FieldDeviceReading fromJson(Map<String, dynamic> json) {
    return FieldDeviceReading(
      routeAndMeasure: json['route_and_measure'] != null
          ? RouteAndMeasure.fromJson(
              json['route_and_measure'] as Map<String, dynamic>)
          : null,
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(
          ((json['last_updated'] as int) * 1000)),
      device: FieldDevice.create()
        ..mergeFromProto3Json(json['device'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'route_and_measure': routeAndMeasure?.toJson(),
        'last_updated': lastUpdated.toIso8601String(),
        'device': device.toProto3Json(),
      };
}
