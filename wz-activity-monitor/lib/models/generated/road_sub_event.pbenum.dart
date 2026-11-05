// This is a generated file - do not edit.
//
// Generated from road_sub_event.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class RoadSubEvent_RoadDirection extends $pb.ProtobufEnum {
  static const RoadSubEvent_RoadDirection ROAD_DIRECTION_UNKNOWN = RoadSubEvent_RoadDirection._(0, _omitEnumNames ? '' : 'ROAD_DIRECTION_UNKNOWN');
  static const RoadSubEvent_RoadDirection ROAD_DIRECTION_BOTH = RoadSubEvent_RoadDirection._(1, _omitEnumNames ? '' : 'ROAD_DIRECTION_BOTH');
  static const RoadSubEvent_RoadDirection ROAD_DIRECTION_NORTHBOUND = RoadSubEvent_RoadDirection._(2, _omitEnumNames ? '' : 'ROAD_DIRECTION_NORTHBOUND');
  static const RoadSubEvent_RoadDirection ROAD_DIRECTION_SOUTHBOUND = RoadSubEvent_RoadDirection._(3, _omitEnumNames ? '' : 'ROAD_DIRECTION_SOUTHBOUND');
  static const RoadSubEvent_RoadDirection ROAD_DIRECTION_EASTBOUND = RoadSubEvent_RoadDirection._(4, _omitEnumNames ? '' : 'ROAD_DIRECTION_EASTBOUND');
  static const RoadSubEvent_RoadDirection ROAD_DIRECTION_WESTBOUND = RoadSubEvent_RoadDirection._(5, _omitEnumNames ? '' : 'ROAD_DIRECTION_WESTBOUND');

  static const $core.List<RoadSubEvent_RoadDirection> values = <RoadSubEvent_RoadDirection> [
    ROAD_DIRECTION_UNKNOWN,
    ROAD_DIRECTION_BOTH,
    ROAD_DIRECTION_NORTHBOUND,
    ROAD_DIRECTION_SOUTHBOUND,
    ROAD_DIRECTION_EASTBOUND,
    ROAD_DIRECTION_WESTBOUND,
  ];

  static final $core.List<RoadSubEvent_RoadDirection?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 5);
  static RoadSubEvent_RoadDirection? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RoadSubEvent_RoadDirection._(super.value, super.name);
}

class RoadSubEvent_RoadSubEventLinkType extends $pb.ProtobufEnum {
  static const RoadSubEvent_RoadSubEventLinkType ROAD_SUB_EVENT_LINK_TYPE_UNKNOWN = RoadSubEvent_RoadSubEventLinkType._(0, _omitEnumNames ? '' : 'ROAD_SUB_EVENT_LINK_TYPE_UNKNOWN');
  static const RoadSubEvent_RoadSubEventLinkType ROAD_SUB_EVENT_LINK_TYPE_FIRST_IN_SEQUENCE = RoadSubEvent_RoadSubEventLinkType._(1, _omitEnumNames ? '' : 'ROAD_SUB_EVENT_LINK_TYPE_FIRST_IN_SEQUENCE');
  static const RoadSubEvent_RoadSubEventLinkType ROAD_SUB_EVENT_LINK_TYPE_NEXT_IN_SEQUENCE = RoadSubEvent_RoadSubEventLinkType._(2, _omitEnumNames ? '' : 'ROAD_SUB_EVENT_LINK_TYPE_NEXT_IN_SEQUENCE');
  static const RoadSubEvent_RoadSubEventLinkType ROAD_SUB_EVENT_LINK_TYPE_FIRST_OCCURRENCE = RoadSubEvent_RoadSubEventLinkType._(3, _omitEnumNames ? '' : 'ROAD_SUB_EVENT_LINK_TYPE_FIRST_OCCURRENCE');
  static const RoadSubEvent_RoadSubEventLinkType ROAD_SUB_EVENT_LINK_TYPE_NEXT_OCCURRENCE = RoadSubEvent_RoadSubEventLinkType._(4, _omitEnumNames ? '' : 'ROAD_SUB_EVENT_LINK_TYPE_NEXT_OCCURRENCE');
  static const RoadSubEvent_RoadSubEventLinkType ROAD_SUB_EVENT_LINK_TYPE_RELATED_ROAD_EVENT = RoadSubEvent_RoadSubEventLinkType._(5, _omitEnumNames ? '' : 'ROAD_SUB_EVENT_LINK_TYPE_RELATED_ROAD_EVENT');
  static const RoadSubEvent_RoadSubEventLinkType ROAD_SUB_EVENT_LINK_TYPE_RELATED_DETOUR = RoadSubEvent_RoadSubEventLinkType._(6, _omitEnumNames ? '' : 'ROAD_SUB_EVENT_LINK_TYPE_RELATED_DETOUR');
  static const RoadSubEvent_RoadSubEventLinkType ROAD_SUB_EVENT_LINK_TYPE_PLANNED_MOVING_OPERATION = RoadSubEvent_RoadSubEventLinkType._(7, _omitEnumNames ? '' : 'ROAD_SUB_EVENT_LINK_TYPE_PLANNED_MOVING_OPERATION');
  static const RoadSubEvent_RoadSubEventLinkType ROAD_SUB_EVENT_LINK_TYPE_ACTIVE_MOVING_OPERATION = RoadSubEvent_RoadSubEventLinkType._(8, _omitEnumNames ? '' : 'ROAD_SUB_EVENT_LINK_TYPE_ACTIVE_MOVING_OPERATION');

  static const $core.List<RoadSubEvent_RoadSubEventLinkType> values = <RoadSubEvent_RoadSubEventLinkType> [
    ROAD_SUB_EVENT_LINK_TYPE_UNKNOWN,
    ROAD_SUB_EVENT_LINK_TYPE_FIRST_IN_SEQUENCE,
    ROAD_SUB_EVENT_LINK_TYPE_NEXT_IN_SEQUENCE,
    ROAD_SUB_EVENT_LINK_TYPE_FIRST_OCCURRENCE,
    ROAD_SUB_EVENT_LINK_TYPE_NEXT_OCCURRENCE,
    ROAD_SUB_EVENT_LINK_TYPE_RELATED_ROAD_EVENT,
    ROAD_SUB_EVENT_LINK_TYPE_RELATED_DETOUR,
    ROAD_SUB_EVENT_LINK_TYPE_PLANNED_MOVING_OPERATION,
    ROAD_SUB_EVENT_LINK_TYPE_ACTIVE_MOVING_OPERATION,
  ];

  static final $core.List<RoadSubEvent_RoadSubEventLinkType?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 8);
  static RoadSubEvent_RoadSubEventLinkType? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RoadSubEvent_RoadSubEventLinkType._(super.value, super.name);
}

class RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType extends $pb.ProtobufEnum {
  static const RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType ROAD_SUB_EVENT_LINK_TYPE_UNKNOWN = RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType._(0, _omitEnumNames ? '' : 'ROAD_SUB_EVENT_LINK_TYPE_UNKNOWN');
  static const RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType ROAD_SUB_EVENT_LINK_TYPE_FIRST_IN_SEQUENCE = RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType._(1, _omitEnumNames ? '' : 'ROAD_SUB_EVENT_LINK_TYPE_FIRST_IN_SEQUENCE');
  static const RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType ROAD_SUB_EVENT_LINK_TYPE_NEXT_IN_SEQUENCE = RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType._(2, _omitEnumNames ? '' : 'ROAD_SUB_EVENT_LINK_TYPE_NEXT_IN_SEQUENCE');
  static const RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType ROAD_SUB_EVENT_LINK_TYPE_FIRST_OCCURRENCE = RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType._(3, _omitEnumNames ? '' : 'ROAD_SUB_EVENT_LINK_TYPE_FIRST_OCCURRENCE');
  static const RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType ROAD_SUB_EVENT_LINK_TYPE_NEXT_OCCURRENCE = RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType._(4, _omitEnumNames ? '' : 'ROAD_SUB_EVENT_LINK_TYPE_NEXT_OCCURRENCE');
  static const RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType ROAD_SUB_EVENT_LINK_TYPE_RELATED_ROAD_EVENT = RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType._(5, _omitEnumNames ? '' : 'ROAD_SUB_EVENT_LINK_TYPE_RELATED_ROAD_EVENT');
  static const RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType ROAD_SUB_EVENT_LINK_TYPE_RELATED_DETOUR = RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType._(6, _omitEnumNames ? '' : 'ROAD_SUB_EVENT_LINK_TYPE_RELATED_DETOUR');
  static const RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType ROAD_SUB_EVENT_LINK_TYPE_PLANNED_MOVING_OPERATION = RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType._(7, _omitEnumNames ? '' : 'ROAD_SUB_EVENT_LINK_TYPE_PLANNED_MOVING_OPERATION');
  static const RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType ROAD_SUB_EVENT_LINK_TYPE_ACTIVE_MOVING_OPERATION = RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType._(8, _omitEnumNames ? '' : 'ROAD_SUB_EVENT_LINK_TYPE_ACTIVE_MOVING_OPERATION');

  static const $core.List<RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType> values = <RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType> [
    ROAD_SUB_EVENT_LINK_TYPE_UNKNOWN,
    ROAD_SUB_EVENT_LINK_TYPE_FIRST_IN_SEQUENCE,
    ROAD_SUB_EVENT_LINK_TYPE_NEXT_IN_SEQUENCE,
    ROAD_SUB_EVENT_LINK_TYPE_FIRST_OCCURRENCE,
    ROAD_SUB_EVENT_LINK_TYPE_NEXT_OCCURRENCE,
    ROAD_SUB_EVENT_LINK_TYPE_RELATED_ROAD_EVENT,
    ROAD_SUB_EVENT_LINK_TYPE_RELATED_DETOUR,
    ROAD_SUB_EVENT_LINK_TYPE_PLANNED_MOVING_OPERATION,
    ROAD_SUB_EVENT_LINK_TYPE_ACTIVE_MOVING_OPERATION,
  ];

  static final $core.List<RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 8);
  static RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType._(super.value, super.name);
}


const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
