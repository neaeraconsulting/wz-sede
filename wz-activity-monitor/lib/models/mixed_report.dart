import 'package:json_annotation/json_annotation.dart';
import 'package:wzam/models/report.dart';
import 'package:wzam/models/report_patch.dart';

part 'mixed_report.g.dart';

@JsonSerializable()
class MixedReport {
  const MixedReport({
    this.reportWithId,
    this.reportPatch,
  });

  final ReportWithId? reportWithId;
  final ReportPatch? reportPatch;

  bool get isFullReport => reportWithId != null;
  bool get isPatch => reportPatch != null;
  int get id => reportWithId?.id ?? reportPatch!.id;

  static MixedReport? tryFromIndividualJson(Map<String, dynamic> json) {
    // Full reports include fields that ReportPatch does not require.
    final bool isPatch = json.containsKey('road_event_id');

    if (isPatch) {
      try {
        return MixedReport(reportPatch: ReportPatch.fromJson(json));
      } catch (_) {
        return null;
      }
    } else {
      try {
        return MixedReport(reportWithId: ReportWithId.fromJson(json));
      } catch (_) {
        return null;
      }
    }
  }

  factory MixedReport.fromJson(Map<String, dynamic> json) =>
      _$MixedReportFromJson(json);

  Map<String, dynamic> toJson() => _$MixedReportToJson(this);
}

@JsonSerializable()
class MixedReportLocal {
  const MixedReportLocal({
    this.report,
    this.reportPatch,
  });

  final Report? report;
  final ReportPatch? reportPatch;

  bool get isFullReport => report != null;
  bool get isPatch => reportPatch != null;
  String get name => report?.name ?? reportPatch!.id.toString();

  static MixedReportLocal? tryFromIndividualJson(Map<String, dynamic> json) {
    // Full reports include fields that ReportPatch does not require.
    final bool isPatch = json.containsKey('road_event_id');

    if (isPatch) {
      try {
        return MixedReportLocal(reportPatch: ReportPatch.fromJson(json));
      } catch (_) {
        return null;
      }
    } else {
      try {
        return MixedReportLocal(report: ReportWithId.fromJson(json));
      } catch (_) {
        return null;
      }
    }
  }

  factory MixedReportLocal.fromJson(Map<String, dynamic> json) =>
      _$MixedReportLocalFromJson(json);

  Map<String, dynamic> toJson() => _$MixedReportLocalToJson(this);
}
