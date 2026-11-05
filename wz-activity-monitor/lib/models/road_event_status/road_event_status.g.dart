// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'road_event_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoadEventStatus _$RoadEventStatusFromJson(Map<String, dynamic> json) =>
    RoadEventStatus(
      roadEvent: _roadEventWrapperFromJson(
          json['road_event'] as Map<String, dynamic>?),
      updates: (json['updates'] as List<dynamic>)
          .map((e) => RoadEventUpdateStatus.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RoadEventStatusToJson(RoadEventStatus instance) =>
    <String, dynamic>{
      'road_event': _roadEventWrapperToJson(instance.roadEvent),
      'updates': instance.updates,
    };
