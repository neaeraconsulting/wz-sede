// This is a generated file - do not edit.
//
// Generated from road_event.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class RoadEvent_RoadEventActiveStatus extends $pb.ProtobufEnum {
  static const RoadEvent_RoadEventActiveStatus ROAD_EVENT_ACTIVE_STATUS_UNKNOWN = RoadEvent_RoadEventActiveStatus._(0, _omitEnumNames ? '' : 'ROAD_EVENT_ACTIVE_STATUS_UNKNOWN');
  static const RoadEvent_RoadEventActiveStatus ROAD_EVENT_ACTIVE_STATUS_ACTIVE = RoadEvent_RoadEventActiveStatus._(1, _omitEnumNames ? '' : 'ROAD_EVENT_ACTIVE_STATUS_ACTIVE');
  static const RoadEvent_RoadEventActiveStatus ROAD_EVENT_ACTIVE_STATUS_INACTIVE = RoadEvent_RoadEventActiveStatus._(2, _omitEnumNames ? '' : 'ROAD_EVENT_ACTIVE_STATUS_INACTIVE');

  static const $core.List<RoadEvent_RoadEventActiveStatus> values = <RoadEvent_RoadEventActiveStatus> [
    ROAD_EVENT_ACTIVE_STATUS_UNKNOWN,
    ROAD_EVENT_ACTIVE_STATUS_ACTIVE,
    ROAD_EVENT_ACTIVE_STATUS_INACTIVE,
  ];

  static final $core.List<RoadEvent_RoadEventActiveStatus?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 2);
  static RoadEvent_RoadEventActiveStatus? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RoadEvent_RoadEventActiveStatus._(super.value, super.name);
}


const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
