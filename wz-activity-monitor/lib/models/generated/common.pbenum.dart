// This is a generated file - do not edit.
//
// Generated from common.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class RoadSurfaceType extends $pb.ProtobufEnum {
  static const RoadSurfaceType ROAD_SURFACE_UNKNOWN = RoadSurfaceType._(0, _omitEnumNames ? '' : 'ROAD_SURFACE_UNKNOWN');
  static const RoadSurfaceType ROAD_SURFACE_TYPE_PAVED = RoadSurfaceType._(1, _omitEnumNames ? '' : 'ROAD_SURFACE_TYPE_PAVED');
  static const RoadSurfaceType ROAD_SURFACE_TYPE_GRAVEL = RoadSurfaceType._(2, _omitEnumNames ? '' : 'ROAD_SURFACE_TYPE_GRAVEL');
  static const RoadSurfaceType ROAD_SURFACE_TYPE_DIRT = RoadSurfaceType._(3, _omitEnumNames ? '' : 'ROAD_SURFACE_TYPE_DIRT');
  static const RoadSurfaceType ROAD_SURFACE_TYPE_GROOVED = RoadSurfaceType._(4, _omitEnumNames ? '' : 'ROAD_SURFACE_TYPE_GROOVED');

  static const $core.List<RoadSurfaceType> values = <RoadSurfaceType> [
    ROAD_SURFACE_UNKNOWN,
    ROAD_SURFACE_TYPE_PAVED,
    ROAD_SURFACE_TYPE_GRAVEL,
    ROAD_SURFACE_TYPE_DIRT,
    ROAD_SURFACE_TYPE_GROOVED,
  ];

  static final $core.List<RoadSurfaceType?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 4);
  static RoadSurfaceType? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RoadSurfaceType._(super.value, super.name);
}

/// https://github.com/usdot-jpo-ode/wzdx/blob/develop/spec-content/enumerated-types/MarkedLocationType.md
class MarkedLocationType extends $pb.ProtobufEnum {
  static const MarkedLocationType MARKED_LOCATION_TYPE_UNKNOWN = MarkedLocationType._(0, _omitEnumNames ? '' : 'MARKED_LOCATION_TYPE_UNKNOWN');
  static const MarkedLocationType MARKED_LOCATION_TYPE_GENERIC = MarkedLocationType._(1, _omitEnumNames ? '' : 'MARKED_LOCATION_TYPE_GENERIC');
  static const MarkedLocationType MARKED_LOCATION_TYPE_FLAGGER = MarkedLocationType._(2, _omitEnumNames ? '' : 'MARKED_LOCATION_TYPE_FLAGGER');
  static const MarkedLocationType MARKED_LOCATION_TYPE_LANE_CLOSURE_START = MarkedLocationType._(3, _omitEnumNames ? '' : 'MARKED_LOCATION_TYPE_LANE_CLOSURE_START');
  static const MarkedLocationType MARKED_LOCATION_TYPE_LANE_CLOSURE_END = MarkedLocationType._(4, _omitEnumNames ? '' : 'MARKED_LOCATION_TYPE_LANE_CLOSURE_END');
  static const MarkedLocationType MARKED_LOCATION_TYPE_WORKER_PRESENCE_START = MarkedLocationType._(5, _omitEnumNames ? '' : 'MARKED_LOCATION_TYPE_WORKER_PRESENCE_START');
  static const MarkedLocationType MARKED_LOCATION_TYPE_WORKER_PRESENCE_END = MarkedLocationType._(6, _omitEnumNames ? '' : 'MARKED_LOCATION_TYPE_WORKER_PRESENCE_END');
  static const MarkedLocationType MARKED_LOCATION_TYPE_WORKER_POSITION = MarkedLocationType._(7, _omitEnumNames ? '' : 'MARKED_LOCATION_TYPE_WORKER_POSITION');
  static const MarkedLocationType MARKED_LOCATION_TYPE_ROAD_CLOSURE_START = MarkedLocationType._(8, _omitEnumNames ? '' : 'MARKED_LOCATION_TYPE_ROAD_CLOSURE_START');
  static const MarkedLocationType MARKED_LOCATION_TYPE_ROAD_CLOSURE_END = MarkedLocationType._(9, _omitEnumNames ? '' : 'MARKED_LOCATION_TYPE_ROAD_CLOSURE_END');
  static const MarkedLocationType MARKED_LOCATION_TYPE_ROAD_EVENT_START = MarkedLocationType._(10, _omitEnumNames ? '' : 'MARKED_LOCATION_TYPE_ROAD_EVENT_START');
  static const MarkedLocationType MARKED_LOCATION_TYPE_ROAD_EVENT_END = MarkedLocationType._(11, _omitEnumNames ? '' : 'MARKED_LOCATION_TYPE_ROAD_EVENT_END');
  static const MarkedLocationType MARKED_LOCATION_TYPE_SPEED_REDUCTION_START = MarkedLocationType._(12, _omitEnumNames ? '' : 'MARKED_LOCATION_TYPE_SPEED_REDUCTION_START');
  static const MarkedLocationType MARKED_LOCATION_TYPE_SPEED_REDUCTION_END = MarkedLocationType._(13, _omitEnumNames ? '' : 'MARKED_LOCATION_TYPE_SPEED_REDUCTION_END');
  static const MarkedLocationType MARKED_LOCATION_TYPE_INCIDENT_START = MarkedLocationType._(14, _omitEnumNames ? '' : 'MARKED_LOCATION_TYPE_INCIDENT_START');
  static const MarkedLocationType MARKED_LOCATION_TYPE_INCIDENT_END = MarkedLocationType._(15, _omitEnumNames ? '' : 'MARKED_LOCATION_TYPE_INCIDENT_END');
  static const MarkedLocationType MARKED_LOCATION_TYPE_APPROACH_REGION = MarkedLocationType._(16, _omitEnumNames ? '' : 'MARKED_LOCATION_TYPE_APPROACH_REGION');

  static const $core.List<MarkedLocationType> values = <MarkedLocationType> [
    MARKED_LOCATION_TYPE_UNKNOWN,
    MARKED_LOCATION_TYPE_GENERIC,
    MARKED_LOCATION_TYPE_FLAGGER,
    MARKED_LOCATION_TYPE_LANE_CLOSURE_START,
    MARKED_LOCATION_TYPE_LANE_CLOSURE_END,
    MARKED_LOCATION_TYPE_WORKER_PRESENCE_START,
    MARKED_LOCATION_TYPE_WORKER_PRESENCE_END,
    MARKED_LOCATION_TYPE_WORKER_POSITION,
    MARKED_LOCATION_TYPE_ROAD_CLOSURE_START,
    MARKED_LOCATION_TYPE_ROAD_CLOSURE_END,
    MARKED_LOCATION_TYPE_ROAD_EVENT_START,
    MARKED_LOCATION_TYPE_ROAD_EVENT_END,
    MARKED_LOCATION_TYPE_SPEED_REDUCTION_START,
    MARKED_LOCATION_TYPE_SPEED_REDUCTION_END,
    MARKED_LOCATION_TYPE_INCIDENT_START,
    MARKED_LOCATION_TYPE_INCIDENT_END,
    MARKED_LOCATION_TYPE_APPROACH_REGION,
  ];

  static final $core.List<MarkedLocationType?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 16);
  static MarkedLocationType? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MarkedLocationType._(super.value, super.name);
}


const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
