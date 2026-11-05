import 'package:json_annotation/json_annotation.dart';
import 'package:wzam/models/datahub/route_and_measure_range.dart';
import 'package:wzam/models/date_time_json_converter.dart';
import 'package:wzam/models/generated/road_event.pb.dart';
import 'package:wzam/models/wrappers/road_sub_event_wrapper.dart';

class RoadEventWrapper {
  @JsonKey(name: 'roadEvent')
  final RoadEvent roadEvent;
  @JsonKey(name: 'roadSubEvents')
  final List<RoadSubEventWrapper> roadSubEvents;
  @JsonKey(name: 'observations')
  final List<Map<String, dynamic>>? observations;
  @JsonKey(name: 'RouteAndMeasureRange')
  final RouteAndMeasureRange? routeAndMeasureRange;
  @JsonKey(
      name: 'lastUpdated',
      fromJson: DateTimeJsonConverter.fromJson,
      toJson: DateTimeJsonConverter.toJson)
  final DateTime? lastUpdated;
  @JsonKey(name: 'numLanes')
  final int? numLanes;
  


  RoadEventWrapper({
    required this.roadEvent,
    required this.roadSubEvents,
    required this.routeAndMeasureRange,
    required this.lastUpdated,
    required this.numLanes,
    this.observations,
  });

  static RoadEventWrapper fromJson(Map<String, dynamic> json) {
    return RoadEventWrapper(
      roadEvent: RoadEvent.create()
        ..mergeFromProto3Json(json['roadEvent'] as Map<String, dynamic>),
      roadSubEvents: (json['roadSubEvents'] as List<dynamic>)
          .map((v) => RoadSubEventWrapper.fromJson(v))
          .toList(),
      observations: (json['observations'] as List<dynamic>?)
          ?.map((v) => Map<String, dynamic>.from(v as Map))
          .toList(),
      routeAndMeasureRange: json['routeAndMeasureRange'] != null
          ? RouteAndMeasureRange.fromJson(
              json['routeAndMeasureRange'] as Map<String, dynamic>)
          : null,
      lastUpdated: json['lastUpdated'] != null
          ? DateTimeJsonConverter.fromJsonNullable(
              json['lastUpdated'] as int?)
          : null,
      numLanes: json['numLanes'] as int?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'roadEvent': roadEvent.toProto3Json(),
        'roadSubEvents': roadSubEvents.map((e) => e.toJson()).toList(),
      'observations': observations,
        'routeAndMeasureRange': routeAndMeasureRange?.toJson(),
        'lastUpdated': DateTimeJsonConverter.toJsonNullable(lastUpdated),
        'numLanes': numLanes,
      };
}