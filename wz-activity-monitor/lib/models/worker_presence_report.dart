import 'package:json_annotation/json_annotation.dart';
import 'package:wzam/models/datahub/route_and_measure_range.dart';
import 'package:wzam/models/date_time_json_converter.dart';
import 'package:wzam/models/event_status.dart';
import 'package:wzam/models/report.dart';

part 'worker_presence_report.g.dart';

@JsonSerializable()
class WorkerPresenceReport {
  @JsonKey(name: 'road_event_id')
  final int roadEventId;
  @JsonKey(
      name: 'timestamp',
      fromJson: DateTimeJsonConverter.fromJson,
      toJson: DateTimeJsonConverter.toJson)
  final DateTime timestamp;
  @JsonKey(name: 'route_and_measure_range')
  final RouteAndMeasureRange routeAndMeasureRange;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'schedule')
  final EventRecurrence schedule;

  WorkerPresenceReport(
      {required this.roadEventId,
      required this.timestamp,
      required this.routeAndMeasureRange,
      required this.userId,
      required this.schedule});


  factory WorkerPresenceReport.fromJson(Map<String, dynamic> json) => _$WorkerPresenceReportFromJson(json);

  Map<String, dynamic> toJson() => _$WorkerPresenceReportToJson(this);
}