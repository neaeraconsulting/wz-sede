import 'package:json_annotation/json_annotation.dart';
import 'package:wzam/models/datahub/route_and_measure_range.dart';
import 'package:wzam/models/generated/road_sub_event.pb.dart';

class RoadSubEventWrapper {
  @JsonKey(name: 'roadSubEvent')
  final RoadSubEvent roadSubEvent;
  @JsonKey(name: 'observations')
  final List<Map<String, dynamic>>? observations;
  @JsonKey(name: 'RouteAndMeasureRange')
  final RouteAndMeasureRange? routeAndMeasureRange;

  RoadSubEventWrapper({
    required this.roadSubEvent,
    required this.routeAndMeasureRange,
    this.observations,
  });

  static RoadSubEventWrapper fromJson(Map<String, dynamic> json) {
    return RoadSubEventWrapper(
      roadSubEvent: RoadSubEvent.create()
        ..mergeFromProto3Json(json['roadSubEvent'] as Map<String, dynamic>),
      observations: (json['observations'] as List<dynamic>?)
          ?.map((v) => Map<String, dynamic>.from(v as Map))
          .toList(),
      routeAndMeasureRange: json['routeAndMeasureRange'] != null
          ? RouteAndMeasureRange.fromJson(
              json['routeAndMeasureRange'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'roadSubEvent': roadSubEvent.toProto3Json(),
        'observations': observations,
        'routeAndMeasureRange': routeAndMeasureRange?.toJson(),
      };
}
