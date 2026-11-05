// This is a generated file - do not edit.
//
// Generated from wzdx.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class WorkZoneType extends $pb.ProtobufEnum {
  static const WorkZoneType WORK_ZONE_TYPE_UNKNOWN = WorkZoneType._(0, _omitEnumNames ? '' : 'WORK_ZONE_TYPE_UNKNOWN');
  static const WorkZoneType WORK_ZONE_TYPE_STATIC = WorkZoneType._(1, _omitEnumNames ? '' : 'WORK_ZONE_TYPE_STATIC');
  static const WorkZoneType WORK_ZONE_TYPE_MOVING = WorkZoneType._(2, _omitEnumNames ? '' : 'WORK_ZONE_TYPE_MOVING');
  static const WorkZoneType WORK_ZONE_TYPE_PLANNED_MOVING_AREA = WorkZoneType._(3, _omitEnumNames ? '' : 'WORK_ZONE_TYPE_PLANNED_MOVING_AREA');

  static const $core.List<WorkZoneType> values = <WorkZoneType> [
    WORK_ZONE_TYPE_UNKNOWN,
    WORK_ZONE_TYPE_STATIC,
    WORK_ZONE_TYPE_MOVING,
    WORK_ZONE_TYPE_PLANNED_MOVING_AREA,
  ];

  static final $core.List<WorkZoneType?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 3);
  static WorkZoneType? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const WorkZoneType._(super.value, super.name);
}

class LocationMethod extends $pb.ProtobufEnum {
  static const LocationMethod LOCATION_METHOD_UNKNOWN = LocationMethod._(0, _omitEnumNames ? '' : 'LOCATION_METHOD_UNKNOWN');
  static const LocationMethod LOCATION_METHOD_CHANNEL_DEVICE_METHOD = LocationMethod._(1, _omitEnumNames ? '' : 'LOCATION_METHOD_CHANNEL_DEVICE_METHOD');
  static const LocationMethod LOCATION_METHOD_SIGN_METHOD = LocationMethod._(2, _omitEnumNames ? '' : 'LOCATION_METHOD_SIGN_METHOD');
  static const LocationMethod LOCATION_METHOD_JUNCTION_METHOD = LocationMethod._(3, _omitEnumNames ? '' : 'LOCATION_METHOD_JUNCTION_METHOD');
  static const LocationMethod LOCATION_METHOD_OTHER = LocationMethod._(4, _omitEnumNames ? '' : 'LOCATION_METHOD_OTHER');

  static const $core.List<LocationMethod> values = <LocationMethod> [
    LOCATION_METHOD_UNKNOWN,
    LOCATION_METHOD_CHANNEL_DEVICE_METHOD,
    LOCATION_METHOD_SIGN_METHOD,
    LOCATION_METHOD_JUNCTION_METHOD,
    LOCATION_METHOD_OTHER,
  ];

  static final $core.List<LocationMethod?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 4);
  static LocationMethod? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const LocationMethod._(super.value, super.name);
}

class VehicleImpact extends $pb.ProtobufEnum {
  static const VehicleImpact VEHICLE_IMPACT_UNKNOWN = VehicleImpact._(0, _omitEnumNames ? '' : 'VEHICLE_IMPACT_UNKNOWN');
  static const VehicleImpact VEHICLE_IMPACT_ALL_LANES_CLOSED = VehicleImpact._(1, _omitEnumNames ? '' : 'VEHICLE_IMPACT_ALL_LANES_CLOSED');
  static const VehicleImpact VEHICLE_IMPACT_SOME_LANES_CLOSED = VehicleImpact._(2, _omitEnumNames ? '' : 'VEHICLE_IMPACT_SOME_LANES_CLOSED');
  static const VehicleImpact VEHICLE_IMPACT_ALL_LANES_OPEN = VehicleImpact._(3, _omitEnumNames ? '' : 'VEHICLE_IMPACT_ALL_LANES_OPEN');
  static const VehicleImpact VEHICLE_IMPACT_ALTERNATING_ONE_WAY = VehicleImpact._(4, _omitEnumNames ? '' : 'VEHICLE_IMPACT_ALTERNATING_ONE_WAY');
  static const VehicleImpact VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_LEFT = VehicleImpact._(5, _omitEnumNames ? '' : 'VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_LEFT');
  static const VehicleImpact VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_RIGHT = VehicleImpact._(6, _omitEnumNames ? '' : 'VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_RIGHT');
  static const VehicleImpact VEHICLE_IMPACT_ALL_LANES_OPEN_SHIFT_LEFT = VehicleImpact._(7, _omitEnumNames ? '' : 'VEHICLE_IMPACT_ALL_LANES_OPEN_SHIFT_LEFT');
  static const VehicleImpact VEHICLE_IMPACT_ALL_LANES_OPEN_SHIFT_RIGHT = VehicleImpact._(8, _omitEnumNames ? '' : 'VEHICLE_IMPACT_ALL_LANES_OPEN_SHIFT_RIGHT');
  static const VehicleImpact VEHICLE_IMPACT_SOME_LANES_CLOSED_SPLIT = VehicleImpact._(9, _omitEnumNames ? '' : 'VEHICLE_IMPACT_SOME_LANES_CLOSED_SPLIT');
  static const VehicleImpact VEHICLE_IMPACT_FLAGGING = VehicleImpact._(10, _omitEnumNames ? '' : 'VEHICLE_IMPACT_FLAGGING');
  static const VehicleImpact VEHICLE_IMPACT_TEMPORARY_TRAFFIC_SIGNAL = VehicleImpact._(11, _omitEnumNames ? '' : 'VEHICLE_IMPACT_TEMPORARY_TRAFFIC_SIGNAL');

  static const $core.List<VehicleImpact> values = <VehicleImpact> [
    VEHICLE_IMPACT_UNKNOWN,
    VEHICLE_IMPACT_ALL_LANES_CLOSED,
    VEHICLE_IMPACT_SOME_LANES_CLOSED,
    VEHICLE_IMPACT_ALL_LANES_OPEN,
    VEHICLE_IMPACT_ALTERNATING_ONE_WAY,
    VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_LEFT,
    VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_RIGHT,
    VEHICLE_IMPACT_ALL_LANES_OPEN_SHIFT_LEFT,
    VEHICLE_IMPACT_ALL_LANES_OPEN_SHIFT_RIGHT,
    VEHICLE_IMPACT_SOME_LANES_CLOSED_SPLIT,
    VEHICLE_IMPACT_FLAGGING,
    VEHICLE_IMPACT_TEMPORARY_TRAFFIC_SIGNAL,
  ];

  static final $core.List<VehicleImpact?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 11);
  static VehicleImpact? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const VehicleImpact._(super.value, super.name);
}

class LaneType extends $pb.ProtobufEnum {
  static const LaneType LANE_TYPE_UNKNOWN = LaneType._(0, _omitEnumNames ? '' : 'LANE_TYPE_UNKNOWN');
  static const LaneType LANE_TYPE_GENERAL = LaneType._(1, _omitEnumNames ? '' : 'LANE_TYPE_GENERAL');
  static const LaneType LANE_TYPE_EXIT_LANE = LaneType._(2, _omitEnumNames ? '' : 'LANE_TYPE_EXIT_LANE');
  static const LaneType LANE_TYPE_EXIT_RAMP = LaneType._(3, _omitEnumNames ? '' : 'LANE_TYPE_EXIT_RAMP');
  static const LaneType LANE_TYPE_ENTRANCE_LANE = LaneType._(4, _omitEnumNames ? '' : 'LANE_TYPE_ENTRANCE_LANE');
  static const LaneType LANE_TYPE_ENTRANCE_RAMP = LaneType._(5, _omitEnumNames ? '' : 'LANE_TYPE_ENTRANCE_RAMP');
  static const LaneType LANE_TYPE_SIDEWALK = LaneType._(6, _omitEnumNames ? '' : 'LANE_TYPE_SIDEWALK');
  static const LaneType LANE_TYPE_BIKE_LANE = LaneType._(7, _omitEnumNames ? '' : 'LANE_TYPE_BIKE_LANE');
  static const LaneType LANE_TYPE_SHOULDER = LaneType._(8, _omitEnumNames ? '' : 'LANE_TYPE_SHOULDER');
  static const LaneType LANE_TYPE_PARKING = LaneType._(9, _omitEnumNames ? '' : 'LANE_TYPE_PARKING');
  static const LaneType LANE_TYPE_MEDIAN = LaneType._(10, _omitEnumNames ? '' : 'LANE_TYPE_MEDIAN');
  static const LaneType LANE_TYPE_TWO_WAY_CENTER_TURN_LANE = LaneType._(11, _omitEnumNames ? '' : 'LANE_TYPE_TWO_WAY_CENTER_TURN_LANE');

  static const $core.List<LaneType> values = <LaneType> [
    LANE_TYPE_UNKNOWN,
    LANE_TYPE_GENERAL,
    LANE_TYPE_EXIT_LANE,
    LANE_TYPE_EXIT_RAMP,
    LANE_TYPE_ENTRANCE_LANE,
    LANE_TYPE_ENTRANCE_RAMP,
    LANE_TYPE_SIDEWALK,
    LANE_TYPE_BIKE_LANE,
    LANE_TYPE_SHOULDER,
    LANE_TYPE_PARKING,
    LANE_TYPE_MEDIAN,
    LANE_TYPE_TWO_WAY_CENTER_TURN_LANE,
  ];

  static final $core.List<LaneType?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 11);
  static LaneType? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const LaneType._(super.value, super.name);
}

class LaneStatus extends $pb.ProtobufEnum {
  static const LaneStatus LANE_STATUS_UNKNOWN = LaneStatus._(0, _omitEnumNames ? '' : 'LANE_STATUS_UNKNOWN');
  static const LaneStatus LANE_STATUS_OPEN = LaneStatus._(1, _omitEnumNames ? '' : 'LANE_STATUS_OPEN');
  static const LaneStatus LANE_STATUS_CLOSED = LaneStatus._(2, _omitEnumNames ? '' : 'LANE_STATUS_CLOSED');
  static const LaneStatus LANE_STATUS_SHIFT_LEFT = LaneStatus._(3, _omitEnumNames ? '' : 'LANE_STATUS_SHIFT_LEFT');
  static const LaneStatus LANE_STATUS_SHIFT_RIGHT = LaneStatus._(4, _omitEnumNames ? '' : 'LANE_STATUS_SHIFT_RIGHT');
  static const LaneStatus LANE_STATUS_MERGE_LEFT = LaneStatus._(5, _omitEnumNames ? '' : 'LANE_STATUS_MERGE_LEFT');
  static const LaneStatus LANE_STATUS_MERGE_RIGHT = LaneStatus._(6, _omitEnumNames ? '' : 'LANE_STATUS_MERGE_RIGHT');
  static const LaneStatus LANE_STATUS_ALTERNATING_FLOW = LaneStatus._(7, _omitEnumNames ? '' : 'LANE_STATUS_ALTERNATING_FLOW');

  static const $core.List<LaneStatus> values = <LaneStatus> [
    LANE_STATUS_UNKNOWN,
    LANE_STATUS_OPEN,
    LANE_STATUS_CLOSED,
    LANE_STATUS_SHIFT_LEFT,
    LANE_STATUS_SHIFT_RIGHT,
    LANE_STATUS_MERGE_LEFT,
    LANE_STATUS_MERGE_RIGHT,
    LANE_STATUS_ALTERNATING_FLOW,
  ];

  static final $core.List<LaneStatus?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 7);
  static LaneStatus? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const LaneStatus._(super.value, super.name);
}

class RestrictionType extends $pb.ProtobufEnum {
  static const RestrictionType RESTRICTION_TYPE_UNKNOWN = RestrictionType._(0, _omitEnumNames ? '' : 'RESTRICTION_TYPE_UNKNOWN');
  static const RestrictionType RESTRICTION_TYPE_LOCAL_ACCESS_ONLY = RestrictionType._(1, _omitEnumNames ? '' : 'RESTRICTION_TYPE_LOCAL_ACCESS_ONLY');
  static const RestrictionType RESTRICTION_TYPE_NO_TRUCKS = RestrictionType._(2, _omitEnumNames ? '' : 'RESTRICTION_TYPE_NO_TRUCKS');
  static const RestrictionType RESTRICTION_TYPE_TRAVEL_PEAK_HOURS_ONLY = RestrictionType._(3, _omitEnumNames ? '' : 'RESTRICTION_TYPE_TRAVEL_PEAK_HOURS_ONLY');
  static const RestrictionType RESTRICTION_TYPE_HOV_3 = RestrictionType._(4, _omitEnumNames ? '' : 'RESTRICTION_TYPE_HOV_3');
  static const RestrictionType RESTRICTION_TYPE_HOV_2 = RestrictionType._(5, _omitEnumNames ? '' : 'RESTRICTION_TYPE_HOV_2');
  static const RestrictionType RESTRICTION_TYPE_NO_PARKING = RestrictionType._(6, _omitEnumNames ? '' : 'RESTRICTION_TYPE_NO_PARKING');
  static const RestrictionType RESTRICTION_TYPE_REDUCED_WIDTH = RestrictionType._(7, _omitEnumNames ? '' : 'RESTRICTION_TYPE_REDUCED_WIDTH');
  static const RestrictionType RESTRICTION_TYPE_REDUCED_HEIGHT = RestrictionType._(8, _omitEnumNames ? '' : 'RESTRICTION_TYPE_REDUCED_HEIGHT');
  static const RestrictionType RESTRICTION_TYPE_REDUCED_LENGTH = RestrictionType._(9, _omitEnumNames ? '' : 'RESTRICTION_TYPE_REDUCED_LENGTH');
  static const RestrictionType RESTRICTION_TYPE_REDUCED_WEIGHT = RestrictionType._(10, _omitEnumNames ? '' : 'RESTRICTION_TYPE_REDUCED_WEIGHT');
  static const RestrictionType RESTRICTION_TYPE_AXLE_LOAD_LIMIT = RestrictionType._(11, _omitEnumNames ? '' : 'RESTRICTION_TYPE_AXLE_LOAD_LIMIT');
  static const RestrictionType RESTRICTION_TYPE_GROSS_WEIGHT_LIMIT = RestrictionType._(12, _omitEnumNames ? '' : 'RESTRICTION_TYPE_GROSS_WEIGHT_LIMIT');
  static const RestrictionType RESTRICTION_TYPE_TOWING_PROHIBITED = RestrictionType._(13, _omitEnumNames ? '' : 'RESTRICTION_TYPE_TOWING_PROHIBITED');
  static const RestrictionType RESTRICTION_TYPE_PERMITTED_OVERSIZE_LOADS_PROHIBITED = RestrictionType._(14, _omitEnumNames ? '' : 'RESTRICTION_TYPE_PERMITTED_OVERSIZE_LOADS_PROHIBITED');
  static const RestrictionType RESTRICTION_TYPE_NO_PASSING = RestrictionType._(15, _omitEnumNames ? '' : 'RESTRICTION_TYPE_NO_PASSING');

  static const $core.List<RestrictionType> values = <RestrictionType> [
    RESTRICTION_TYPE_UNKNOWN,
    RESTRICTION_TYPE_LOCAL_ACCESS_ONLY,
    RESTRICTION_TYPE_NO_TRUCKS,
    RESTRICTION_TYPE_TRAVEL_PEAK_HOURS_ONLY,
    RESTRICTION_TYPE_HOV_3,
    RESTRICTION_TYPE_HOV_2,
    RESTRICTION_TYPE_NO_PARKING,
    RESTRICTION_TYPE_REDUCED_WIDTH,
    RESTRICTION_TYPE_REDUCED_HEIGHT,
    RESTRICTION_TYPE_REDUCED_LENGTH,
    RESTRICTION_TYPE_REDUCED_WEIGHT,
    RESTRICTION_TYPE_AXLE_LOAD_LIMIT,
    RESTRICTION_TYPE_GROSS_WEIGHT_LIMIT,
    RESTRICTION_TYPE_TOWING_PROHIBITED,
    RESTRICTION_TYPE_PERMITTED_OVERSIZE_LOADS_PROHIBITED,
    RESTRICTION_TYPE_NO_PASSING,
  ];

  static final $core.List<RestrictionType?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 15);
  static RestrictionType? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RestrictionType._(super.value, super.name);
}

class UnitOfMeasurement extends $pb.ProtobufEnum {
  static const UnitOfMeasurement UNIT_OF_MEASUREMENT_UNKNOWN = UnitOfMeasurement._(0, _omitEnumNames ? '' : 'UNIT_OF_MEASUREMENT_UNKNOWN');
  static const UnitOfMeasurement UNIT_OF_MEASUREMENT_FEET = UnitOfMeasurement._(1, _omitEnumNames ? '' : 'UNIT_OF_MEASUREMENT_FEET');
  static const UnitOfMeasurement UNIT_OF_MEASUREMENT_METERS = UnitOfMeasurement._(2, _omitEnumNames ? '' : 'UNIT_OF_MEASUREMENT_METERS');
  static const UnitOfMeasurement UNIT_OF_MEASUREMENT_CENTIMETERS = UnitOfMeasurement._(3, _omitEnumNames ? '' : 'UNIT_OF_MEASUREMENT_CENTIMETERS');
  static const UnitOfMeasurement UNIT_OF_MEASUREMENT_POUNDS = UnitOfMeasurement._(4, _omitEnumNames ? '' : 'UNIT_OF_MEASUREMENT_POUNDS');
  static const UnitOfMeasurement UNIT_OF_MEASUREMENT_TONS = UnitOfMeasurement._(5, _omitEnumNames ? '' : 'UNIT_OF_MEASUREMENT_TONS');
  static const UnitOfMeasurement UNIT_OF_MEASUREMENT_KILOGRAMS = UnitOfMeasurement._(6, _omitEnumNames ? '' : 'UNIT_OF_MEASUREMENT_KILOGRAMS');
  static const UnitOfMeasurement UNIT_OF_MEASUREMENT_INCHES = UnitOfMeasurement._(7, _omitEnumNames ? '' : 'UNIT_OF_MEASUREMENT_INCHES');

  static const $core.List<UnitOfMeasurement> values = <UnitOfMeasurement> [
    UNIT_OF_MEASUREMENT_UNKNOWN,
    UNIT_OF_MEASUREMENT_FEET,
    UNIT_OF_MEASUREMENT_METERS,
    UNIT_OF_MEASUREMENT_CENTIMETERS,
    UNIT_OF_MEASUREMENT_POUNDS,
    UNIT_OF_MEASUREMENT_TONS,
    UNIT_OF_MEASUREMENT_KILOGRAMS,
    UNIT_OF_MEASUREMENT_INCHES,
  ];

  static final $core.List<UnitOfMeasurement?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 7);
  static UnitOfMeasurement? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const UnitOfMeasurement._(super.value, super.name);
}

class WorkTypeName extends $pb.ProtobufEnum {
  static const WorkTypeName WORK_TYPE_NAME_UNKNOWN = WorkTypeName._(0, _omitEnumNames ? '' : 'WORK_TYPE_NAME_UNKNOWN');
  static const WorkTypeName WORK_TYPE_NAME_MAINTENANCE = WorkTypeName._(1, _omitEnumNames ? '' : 'WORK_TYPE_NAME_MAINTENANCE');
  static const WorkTypeName WORK_TYPE_NAME_MINOR_ROAD_DEFECT_REPAIR = WorkTypeName._(2, _omitEnumNames ? '' : 'WORK_TYPE_NAME_MINOR_ROAD_DEFECT_REPAIR');
  static const WorkTypeName WORK_TYPE_NAME_ROADSIDE_WORK = WorkTypeName._(3, _omitEnumNames ? '' : 'WORK_TYPE_NAME_ROADSIDE_WORK');
  static const WorkTypeName WORK_TYPE_NAME_OVERHEAD_WORK = WorkTypeName._(4, _omitEnumNames ? '' : 'WORK_TYPE_NAME_OVERHEAD_WORK');
  static const WorkTypeName WORK_TYPE_NAME_BELOW_ROAD_WORK = WorkTypeName._(5, _omitEnumNames ? '' : 'WORK_TYPE_NAME_BELOW_ROAD_WORK');
  static const WorkTypeName WORK_TYPE_NAME_BARRIER_WORK = WorkTypeName._(6, _omitEnumNames ? '' : 'WORK_TYPE_NAME_BARRIER_WORK');
  static const WorkTypeName WORK_TYPE_NAME_SURFACE_WORK = WorkTypeName._(7, _omitEnumNames ? '' : 'WORK_TYPE_NAME_SURFACE_WORK');
  static const WorkTypeName WORK_TYPE_NAME_PAINTING = WorkTypeName._(8, _omitEnumNames ? '' : 'WORK_TYPE_NAME_PAINTING');
  static const WorkTypeName WORK_TYPE_NAME_ROADWAY_RELOCATION = WorkTypeName._(9, _omitEnumNames ? '' : 'WORK_TYPE_NAME_ROADWAY_RELOCATION');
  static const WorkTypeName WORK_TYPE_NAME_ROADWAY_CREATION = WorkTypeName._(10, _omitEnumNames ? '' : 'WORK_TYPE_NAME_ROADWAY_CREATION');

  static const $core.List<WorkTypeName> values = <WorkTypeName> [
    WORK_TYPE_NAME_UNKNOWN,
    WORK_TYPE_NAME_MAINTENANCE,
    WORK_TYPE_NAME_MINOR_ROAD_DEFECT_REPAIR,
    WORK_TYPE_NAME_ROADSIDE_WORK,
    WORK_TYPE_NAME_OVERHEAD_WORK,
    WORK_TYPE_NAME_BELOW_ROAD_WORK,
    WORK_TYPE_NAME_BARRIER_WORK,
    WORK_TYPE_NAME_SURFACE_WORK,
    WORK_TYPE_NAME_PAINTING,
    WORK_TYPE_NAME_ROADWAY_RELOCATION,
    WORK_TYPE_NAME_ROADWAY_CREATION,
  ];

  static final $core.List<WorkTypeName?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 10);
  static WorkTypeName? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const WorkTypeName._(super.value, super.name);
}

class WorkerPresenceDefinition extends $pb.ProtobufEnum {
  static const WorkerPresenceDefinition WORKER_PRESENCE_DEFINITION_UNKNOWN = WorkerPresenceDefinition._(0, _omitEnumNames ? '' : 'WORKER_PRESENCE_DEFINITION_UNKNOWN');
  static const WorkerPresenceDefinition WORKER_PRESENCE_DEFINITION_WORKERS_IN_WORK_ZONE_WORKING = WorkerPresenceDefinition._(1, _omitEnumNames ? '' : 'WORKER_PRESENCE_DEFINITION_WORKERS_IN_WORK_ZONE_WORKING');
  static const WorkerPresenceDefinition WORKER_PRESENCE_DEFINITION_WORKERS_IN_WORK_ZONE_NOT_WORKING = WorkerPresenceDefinition._(2, _omitEnumNames ? '' : 'WORKER_PRESENCE_DEFINITION_WORKERS_IN_WORK_ZONE_NOT_WORKING');
  static const WorkerPresenceDefinition WORKER_PRESENCE_DEFINITION_MOBILE_EQUIPMENT_IN_WORK_ZONE_MOVING = WorkerPresenceDefinition._(3, _omitEnumNames ? '' : 'WORKER_PRESENCE_DEFINITION_MOBILE_EQUIPMENT_IN_WORK_ZONE_MOVING');
  static const WorkerPresenceDefinition WORKER_PRESENCE_DEFINITION_MOBILE_EQUIPMENT_IN_WORK_ZONE_NOT_MOVING = WorkerPresenceDefinition._(4, _omitEnumNames ? '' : 'WORKER_PRESENCE_DEFINITION_MOBILE_EQUIPMENT_IN_WORK_ZONE_NOT_MOVING');
  static const WorkerPresenceDefinition WORKER_PRESENCE_DEFINITION_FIXED_EQUIPMENT_IN_WORK_ZONE = WorkerPresenceDefinition._(5, _omitEnumNames ? '' : 'WORKER_PRESENCE_DEFINITION_FIXED_EQUIPMENT_IN_WORK_ZONE');
  static const WorkerPresenceDefinition WORKER_PRESENCE_DEFINITION_HUMANS_BEHIND_BARRIER = WorkerPresenceDefinition._(6, _omitEnumNames ? '' : 'WORKER_PRESENCE_DEFINITION_HUMANS_BEHIND_BARRIER');
  static const WorkerPresenceDefinition WORKER_PRESENCE_DEFINITION_HUMANS_IN_RIGHT_OF_WAY = WorkerPresenceDefinition._(7, _omitEnumNames ? '' : 'WORKER_PRESENCE_DEFINITION_HUMANS_IN_RIGHT_OF_WAY');

  static const $core.List<WorkerPresenceDefinition> values = <WorkerPresenceDefinition> [
    WORKER_PRESENCE_DEFINITION_UNKNOWN,
    WORKER_PRESENCE_DEFINITION_WORKERS_IN_WORK_ZONE_WORKING,
    WORKER_PRESENCE_DEFINITION_WORKERS_IN_WORK_ZONE_NOT_WORKING,
    WORKER_PRESENCE_DEFINITION_MOBILE_EQUIPMENT_IN_WORK_ZONE_MOVING,
    WORKER_PRESENCE_DEFINITION_MOBILE_EQUIPMENT_IN_WORK_ZONE_NOT_MOVING,
    WORKER_PRESENCE_DEFINITION_FIXED_EQUIPMENT_IN_WORK_ZONE,
    WORKER_PRESENCE_DEFINITION_HUMANS_BEHIND_BARRIER,
    WORKER_PRESENCE_DEFINITION_HUMANS_IN_RIGHT_OF_WAY,
  ];

  static final $core.List<WorkerPresenceDefinition?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 7);
  static WorkerPresenceDefinition? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const WorkerPresenceDefinition._(super.value, super.name);
}

class WorkerPresenceMethod extends $pb.ProtobufEnum {
  static const WorkerPresenceMethod WORKER_PRESENCE_METHOD_UNKNOWN = WorkerPresenceMethod._(0, _omitEnumNames ? '' : 'WORKER_PRESENCE_METHOD_UNKNOWN');
  static const WorkerPresenceMethod WORKER_PRESENCE_METHOD_CAMERA_MONITORING = WorkerPresenceMethod._(1, _omitEnumNames ? '' : 'WORKER_PRESENCE_METHOD_CAMERA_MONITORING');
  static const WorkerPresenceMethod WORKER_PRESENCE_METHOD_CONES_PRESENT = WorkerPresenceMethod._(2, _omitEnumNames ? '' : 'WORKER_PRESENCE_METHOD_CONES_PRESENT');
  static const WorkerPresenceMethod WORKER_PRESENCE_METHOD_MAINTENANCE_VEHICLE_PRESENT = WorkerPresenceMethod._(3, _omitEnumNames ? '' : 'WORKER_PRESENCE_METHOD_MAINTENANCE_VEHICLE_PRESENT');
  static const WorkerPresenceMethod WORKER_PRESENCE_METHOD_WEARABLES_PRESENT = WorkerPresenceMethod._(4, _omitEnumNames ? '' : 'WORKER_PRESENCE_METHOD_WEARABLES_PRESENT');
  static const WorkerPresenceMethod WORKER_PRESENCE_METHOD_MOBILE_DEVICE_PRESENT = WorkerPresenceMethod._(5, _omitEnumNames ? '' : 'WORKER_PRESENCE_METHOD_MOBILE_DEVICE_PRESENT');
  static const WorkerPresenceMethod WORKER_PRESENCE_METHOD_CHECK_IN_APP = WorkerPresenceMethod._(6, _omitEnumNames ? '' : 'WORKER_PRESENCE_METHOD_CHECK_IN_APP');
  static const WorkerPresenceMethod WORKER_PRESENCE_METHOD_CHECK_IN_VERBAL = WorkerPresenceMethod._(7, _omitEnumNames ? '' : 'WORKER_PRESENCE_METHOD_CHECK_IN_VERBAL');
  static const WorkerPresenceMethod WORKER_PRESENCE_METHOD_SCHEDULED = WorkerPresenceMethod._(8, _omitEnumNames ? '' : 'WORKER_PRESENCE_METHOD_SCHEDULED');

  static const $core.List<WorkerPresenceMethod> values = <WorkerPresenceMethod> [
    WORKER_PRESENCE_METHOD_UNKNOWN,
    WORKER_PRESENCE_METHOD_CAMERA_MONITORING,
    WORKER_PRESENCE_METHOD_CONES_PRESENT,
    WORKER_PRESENCE_METHOD_MAINTENANCE_VEHICLE_PRESENT,
    WORKER_PRESENCE_METHOD_WEARABLES_PRESENT,
    WORKER_PRESENCE_METHOD_MOBILE_DEVICE_PRESENT,
    WORKER_PRESENCE_METHOD_CHECK_IN_APP,
    WORKER_PRESENCE_METHOD_CHECK_IN_VERBAL,
    WORKER_PRESENCE_METHOD_SCHEDULED,
  ];

  static final $core.List<WorkerPresenceMethod?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 8);
  static WorkerPresenceMethod? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const WorkerPresenceMethod._(super.value, super.name);
}

class WorkerPresenceConfidence extends $pb.ProtobufEnum {
  static const WorkerPresenceConfidence WORKER_PRESENCE_CONFIDENCE_UNKNOWN = WorkerPresenceConfidence._(0, _omitEnumNames ? '' : 'WORKER_PRESENCE_CONFIDENCE_UNKNOWN');
  static const WorkerPresenceConfidence WORKER_PRESENCE_CONFIDENCE_LOW = WorkerPresenceConfidence._(1, _omitEnumNames ? '' : 'WORKER_PRESENCE_CONFIDENCE_LOW');
  static const WorkerPresenceConfidence WORKER_PRESENCE_CONFIDENCE_MEDIUM = WorkerPresenceConfidence._(2, _omitEnumNames ? '' : 'WORKER_PRESENCE_CONFIDENCE_MEDIUM');
  static const WorkerPresenceConfidence WORKER_PRESENCE_CONFIDENCE_HIGH = WorkerPresenceConfidence._(3, _omitEnumNames ? '' : 'WORKER_PRESENCE_CONFIDENCE_HIGH');

  static const $core.List<WorkerPresenceConfidence> values = <WorkerPresenceConfidence> [
    WORKER_PRESENCE_CONFIDENCE_UNKNOWN,
    WORKER_PRESENCE_CONFIDENCE_LOW,
    WORKER_PRESENCE_CONFIDENCE_MEDIUM,
    WORKER_PRESENCE_CONFIDENCE_HIGH,
  ];

  static final $core.List<WorkerPresenceConfidence?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 3);
  static WorkerPresenceConfidence? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const WorkerPresenceConfidence._(super.value, super.name);
}

class RoadwayDirection extends $pb.ProtobufEnum {
  static const RoadwayDirection ROADWAY_DIRECTION_UNKNOWN = RoadwayDirection._(0, _omitEnumNames ? '' : 'ROADWAY_DIRECTION_UNKNOWN');
  static const RoadwayDirection ROADWAY_DIRECTION_NORTHBOUND = RoadwayDirection._(1, _omitEnumNames ? '' : 'ROADWAY_DIRECTION_NORTHBOUND');
  static const RoadwayDirection ROADWAY_DIRECTION_SOUTHBOUND = RoadwayDirection._(2, _omitEnumNames ? '' : 'ROADWAY_DIRECTION_SOUTHBOUND');
  static const RoadwayDirection ROADWAY_DIRECTION_EASTBOUND = RoadwayDirection._(3, _omitEnumNames ? '' : 'ROADWAY_DIRECTION_EASTBOUND');
  static const RoadwayDirection ROADWAY_DIRECTION_WESTBOUND = RoadwayDirection._(4, _omitEnumNames ? '' : 'ROADWAY_DIRECTION_WESTBOUND');
  static const RoadwayDirection ROADWAY_DIRECTION_INNER_LOOP = RoadwayDirection._(5, _omitEnumNames ? '' : 'ROADWAY_DIRECTION_INNER_LOOP');
  static const RoadwayDirection ROADWAY_DIRECTION_OUTER_LOOP = RoadwayDirection._(6, _omitEnumNames ? '' : 'ROADWAY_DIRECTION_OUTER_LOOP');
  static const RoadwayDirection ROADWAY_DIRECTION_UNDEFINED = RoadwayDirection._(7, _omitEnumNames ? '' : 'ROADWAY_DIRECTION_UNDEFINED');

  static const $core.List<RoadwayDirection> values = <RoadwayDirection> [
    ROADWAY_DIRECTION_UNKNOWN,
    ROADWAY_DIRECTION_NORTHBOUND,
    ROADWAY_DIRECTION_SOUTHBOUND,
    ROADWAY_DIRECTION_EASTBOUND,
    ROADWAY_DIRECTION_WESTBOUND,
    ROADWAY_DIRECTION_INNER_LOOP,
    ROADWAY_DIRECTION_OUTER_LOOP,
    ROADWAY_DIRECTION_UNDEFINED,
  ];

  static final $core.List<RoadwayDirection?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 7);
  static RoadwayDirection? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RoadwayDirection._(super.value, super.name);
}


const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
