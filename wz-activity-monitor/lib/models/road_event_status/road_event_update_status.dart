// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:wzam/models/date_time_json_converter.dart';

part 'road_event_update_status.g.dart';

@JsonSerializable()
class RoadEventUpdateStatus {
  @JsonKey(name: 'source_type')
  final RoadEventUpdateSourceType sourceType;

  @JsonKey(name: 'approval_status')
  final RoadEventUpdateApprovalStatus approvalStatus;

  @JsonKey(name: 'event_status')
  final EventStatus eventStatus;
  @JsonKey(
      name: 'update_submitted_timestamp',
      fromJson: DateTimeJsonConverter.fromJson,
      toJson: DateTimeJsonConverter.toJson)
  final DateTime updateSubmittedTimestamp;
  @JsonKey(
      name: 'update_review_timestamp',
      fromJson: DateTimeJsonConverter.fromJsonNullable,
      toJson: DateTimeJsonConverter.toJsonNullable)
  final DateTime? updateReviewTimestamp;
  @JsonKey(name: 'source')
  final Map<String, dynamic> source;

  RoadEventUpdateStatus({
    required this.sourceType,
    required this.approvalStatus,
    required this.eventStatus,
    required this.updateSubmittedTimestamp,
    this.updateReviewTimestamp,
    required this.source,
  });

  factory RoadEventUpdateStatus.fromJson(Map<String, dynamic> json) =>
      _$RoadEventUpdateStatusFromJson(json);
  Map<String, dynamic> toJson() => _$RoadEventUpdateStatusToJson(this);
}

enum RoadEventUpdateSourceType {
  REPORT, RECORDING, MOBILE_VEHICLE, MOBILE_WORKER
}

enum RoadEventUpdateApprovalStatus {
  APPROVED, AUTO_APPROVED, REJECTED, PENDING
}

enum EventStatus {
  ERROR, NOT_CREATED, UPCOMING, ONGOING, COMPLETED
}
