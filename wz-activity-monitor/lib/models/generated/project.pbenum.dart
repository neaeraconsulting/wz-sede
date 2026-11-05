// This is a generated file - do not edit.
//
// Generated from project.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Project_ProjectActiveStatus extends $pb.ProtobufEnum {
  static const Project_ProjectActiveStatus PROJECT_ACTIVE_STATUS_UNKNOWN = Project_ProjectActiveStatus._(0, _omitEnumNames ? '' : 'PROJECT_ACTIVE_STATUS_UNKNOWN');
  static const Project_ProjectActiveStatus PROJECT_ACTIVE_STATUS_ACTIVE = Project_ProjectActiveStatus._(1, _omitEnumNames ? '' : 'PROJECT_ACTIVE_STATUS_ACTIVE');
  static const Project_ProjectActiveStatus PROJECT_ACTIVE_STATUS_SUSPENDED = Project_ProjectActiveStatus._(2, _omitEnumNames ? '' : 'PROJECT_ACTIVE_STATUS_SUSPENDED');

  static const $core.List<Project_ProjectActiveStatus> values = <Project_ProjectActiveStatus> [
    PROJECT_ACTIVE_STATUS_UNKNOWN,
    PROJECT_ACTIVE_STATUS_ACTIVE,
    PROJECT_ACTIVE_STATUS_SUSPENDED,
  ];

  static final $core.List<Project_ProjectActiveStatus?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 2);
  static Project_ProjectActiveStatus? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Project_ProjectActiveStatus._(super.value, super.name);
}


const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
