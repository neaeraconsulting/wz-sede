import 'package:json_annotation/json_annotation.dart';
import 'package:wzam/models/generated/project.pb.dart';

class ProjectWrapper {
  @JsonKey(name: 'project')
  final Project project;
  @JsonKey(name: 'updateDate')
  final DateTime updateDate;

  ProjectWrapper({
    required this.project,
    required this.updateDate,
  });

  static ProjectWrapper fromJson(Map<String, dynamic> json) {
    return ProjectWrapper(
      project: Project.create()
        ..mergeFromProto3Json(json['project'] as Map<String, dynamic>),
      updateDate: DateTime.parse(json['updateDate'] as String),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'project': project.toProto3Json(),
        'updateDate': updateDate.toIso8601String(),
      };
}
