// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'road_event_update_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoadEventUpdateStatus _$RoadEventUpdateStatusFromJson(
        Map<String, dynamic> json) =>
    RoadEventUpdateStatus(
      sourceType:
          $enumDecode(_$RoadEventUpdateSourceTypeEnumMap, json['source_type']),
      approvalStatus: $enumDecode(
          _$RoadEventUpdateApprovalStatusEnumMap, json['approval_status']),
      eventStatus: $enumDecode(_$EventStatusEnumMap, json['event_status']),
      updateSubmittedTimestamp: DateTimeJsonConverter.fromJson(
          (json['update_submitted_timestamp'] as num).toInt()),
      updateReviewTimestamp: DateTimeJsonConverter.fromJsonNullable(
          (json['update_review_timestamp'] as num?)?.toInt()),
      source: json['source'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$RoadEventUpdateStatusToJson(
        RoadEventUpdateStatus instance) =>
    <String, dynamic>{
      'source_type': _$RoadEventUpdateSourceTypeEnumMap[instance.sourceType]!,
      'approval_status':
          _$RoadEventUpdateApprovalStatusEnumMap[instance.approvalStatus]!,
      'event_status': _$EventStatusEnumMap[instance.eventStatus]!,
      'update_submitted_timestamp':
          DateTimeJsonConverter.toJson(instance.updateSubmittedTimestamp),
      'update_review_timestamp':
          DateTimeJsonConverter.toJsonNullable(instance.updateReviewTimestamp),
      'source': instance.source,
    };

const _$RoadEventUpdateSourceTypeEnumMap = {
  RoadEventUpdateSourceType.REPORT: 'REPORT',
  RoadEventUpdateSourceType.RECORDING: 'RECORDING',
  RoadEventUpdateSourceType.MOBILE_VEHICLE: 'MOBILE_VEHICLE',
  RoadEventUpdateSourceType.MOBILE_WORKER: 'MOBILE_WORKER',
};

const _$RoadEventUpdateApprovalStatusEnumMap = {
  RoadEventUpdateApprovalStatus.APPROVED: 'APPROVED',
  RoadEventUpdateApprovalStatus.AUTO_APPROVED: 'AUTO_APPROVED',
  RoadEventUpdateApprovalStatus.REJECTED: 'REJECTED',
  RoadEventUpdateApprovalStatus.PENDING: 'PENDING',
};

const _$EventStatusEnumMap = {
  EventStatus.ERROR: 'ERROR',
  EventStatus.NOT_CREATED: 'NOT_CREATED',
  EventStatus.UPCOMING: 'UPCOMING',
  EventStatus.ONGOING: 'ONGOING',
  EventStatus.COMPLETED: 'COMPLETED',
};
