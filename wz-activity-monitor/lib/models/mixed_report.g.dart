// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mixed_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MixedReport _$MixedReportFromJson(Map<String, dynamic> json) => MixedReport(
      reportWithId: json['reportWithId'] == null
          ? null
          : ReportWithId.fromJson(json['reportWithId'] as Map<String, dynamic>),
      reportPatch: json['reportPatch'] == null
          ? null
          : ReportPatch.fromJson(json['reportPatch'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MixedReportToJson(MixedReport instance) =>
    <String, dynamic>{
      'reportWithId': instance.reportWithId,
      'reportPatch': instance.reportPatch,
    };

MixedReportLocal _$MixedReportLocalFromJson(Map<String, dynamic> json) =>
    MixedReportLocal(
      report: json['report'] == null
          ? null
          : ReportWithId.fromJson(json['report'] as Map<String, dynamic>),
      reportPatch: json['reportPatch'] == null
          ? null
          : ReportPatch.fromJson(json['reportPatch'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MixedReportLocalToJson(MixedReportLocal instance) =>
    <String, dynamic>{
      'report': instance.report,
      'reportPatch': instance.reportPatch,
    };
