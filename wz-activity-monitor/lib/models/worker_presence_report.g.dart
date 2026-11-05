// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_presence_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkerPresenceReport _$WorkerPresenceReportFromJson(
        Map<String, dynamic> json) =>
    WorkerPresenceReport(
      roadEventId: (json['road_event_id'] as num).toInt(),
      timestamp:
          DateTimeJsonConverter.fromJson((json['timestamp'] as num).toInt()),
      routeAndMeasureRange: RouteAndMeasureRange.fromJson(
          json['route_and_measure_range'] as Map<String, dynamic>),
      userId: json['user_id'] as String,
      schedule:
          EventRecurrence.fromJson(json['schedule'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkerPresenceReportToJson(
        WorkerPresenceReport instance) =>
    <String, dynamic>{
      'road_event_id': instance.roadEventId,
      'timestamp': DateTimeJsonConverter.toJson(instance.timestamp),
      'route_and_measure_range': instance.routeAndMeasureRange,
      'user_id': instance.userId,
      'schedule': instance.schedule,
    };
