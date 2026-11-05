// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:wzam/models/road_event_status/road_event_update_status.dart';
import 'package:wzam/models/wrappers/road_event_wrapper.dart';

part 'road_event_status.g.dart';

Map<String, dynamic>? _roadEventWrapperToJson(RoadEventWrapper? wrapper) => wrapper?.toJson();
RoadEventWrapper? _roadEventWrapperFromJson(Map<String, dynamic>? json) =>
    json == null ? null : RoadEventWrapper.fromJson(json);

@JsonSerializable()
class RoadEventStatus {
  @JsonKey(
    name: 'road_event',
    fromJson: _roadEventWrapperFromJson,
    toJson: _roadEventWrapperToJson,
  )
  final RoadEventWrapper? roadEvent;

  @JsonKey(name: 'updates')
  final List<RoadEventUpdateStatus> updates;

  RoadEventStatus({
    this.roadEvent,
    required this.updates,
  });

  factory RoadEventStatus.fromJson(Map<String, dynamic> json) =>
      _$RoadEventStatusFromJson(json);
  Map<String, dynamic> toJson() => _$RoadEventStatusToJson(this);
}