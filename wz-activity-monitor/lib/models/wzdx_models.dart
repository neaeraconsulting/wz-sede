import 'package:json_annotation/json_annotation.dart';
import 'package:wzam/models/generated/wzdx.pbenum.dart' as pb_enum_wzdx;
import 'package:wzam/models/generated/wzdx.pb.dart' as pb_wzdx;
import 'package:wzam/models/generated/common.pbenum.dart' as pb_enum_common;
import 'package:wzam/services/protobuf_utils.dart';

part 'wzdx_models.g.dart';

enum WorkZoneType {
  @JsonValue('static')
  static,
  @JsonValue('moving')
  moving,
  @JsonValue('planned-moving-area')
  plannedMovingArea;

  static fromProto(pb_enum_wzdx.WorkZoneType type) {
    switch (type) {
      case pb_enum_wzdx.WorkZoneType.WORK_ZONE_TYPE_STATIC:
        return WorkZoneType.static;
      case pb_enum_wzdx.WorkZoneType.WORK_ZONE_TYPE_MOVING:
        return WorkZoneType.moving;
      case pb_enum_wzdx.WorkZoneType.WORK_ZONE_TYPE_PLANNED_MOVING_AREA:
        return WorkZoneType.plannedMovingArea;
      default:
        return WorkZoneType.static;
    }
  }

  static fromProtoWithAllowedTypes(pb_enum_wzdx.WorkZoneType type) {
    switch (type) {
      case pb_enum_wzdx.WorkZoneType.WORK_ZONE_TYPE_STATIC:
        return WorkZoneType.static;
      case pb_enum_wzdx.WorkZoneType.WORK_ZONE_TYPE_MOVING:
        return WorkZoneType.plannedMovingArea;
      case pb_enum_wzdx.WorkZoneType.WORK_ZONE_TYPE_PLANNED_MOVING_AREA:
        return WorkZoneType.plannedMovingArea;
      default:
        return WorkZoneType.static;
    }
  }
}

enum RoadwayDirection {
  @JsonValue('northbound')
  northbound,
  @JsonValue('eastbound')
  eastbound,
  @JsonValue('southbound')
  southbound,
  @JsonValue('westbound')
  westbound,
  @JsonValue('inner-loop')
  innerLoop,
  @JsonValue('outer-loop')
  outerLoop,
  @JsonValue('undefined')
  undefined,
  @JsonValue('unknown')
  unknown;

  static fromProto(pb_enum_wzdx.RoadwayDirection direction) {
    switch (direction) {
      case pb_enum_wzdx.RoadwayDirection.ROADWAY_DIRECTION_NORTHBOUND:
        return RoadwayDirection.northbound;
      case pb_enum_wzdx.RoadwayDirection.ROADWAY_DIRECTION_EASTBOUND:
        return RoadwayDirection.eastbound;
      case pb_enum_wzdx.RoadwayDirection.ROADWAY_DIRECTION_SOUTHBOUND:
        return RoadwayDirection.southbound;
      case pb_enum_wzdx.RoadwayDirection.ROADWAY_DIRECTION_WESTBOUND:
        return RoadwayDirection.westbound;
      case pb_enum_wzdx.RoadwayDirection.ROADWAY_DIRECTION_INNER_LOOP:
        return RoadwayDirection.innerLoop;
      case pb_enum_wzdx.RoadwayDirection.ROADWAY_DIRECTION_OUTER_LOOP:
        return RoadwayDirection.outerLoop;
      case pb_enum_wzdx.RoadwayDirection.ROADWAY_DIRECTION_UNDEFINED:
        return RoadwayDirection.undefined;
      case pb_enum_wzdx.RoadwayDirection.ROADWAY_DIRECTION_UNKNOWN:
        return RoadwayDirection.unknown;
      default:
        return RoadwayDirection.unknown;
    }
  }
}

enum LocationMethod {
  @JsonValue('channel-device-method')
  channelDeviceMethod,
  @JsonValue('sign-method')
  signMethod,
  @JsonValue('junction-method')
  junctionMethod,
  @JsonValue('other')
  other,
  @JsonValue('unknown')
  unknown;

  static fromProto(pb_enum_wzdx.LocationMethod method) {
    switch (method) {
      case pb_enum_wzdx.LocationMethod.LOCATION_METHOD_CHANNEL_DEVICE_METHOD:
        return LocationMethod.channelDeviceMethod;
      case pb_enum_wzdx.LocationMethod.LOCATION_METHOD_SIGN_METHOD:
        return LocationMethod.signMethod;
      case pb_enum_wzdx.LocationMethod.LOCATION_METHOD_JUNCTION_METHOD:
        return LocationMethod.junctionMethod;
      case pb_enum_wzdx.LocationMethod.LOCATION_METHOD_OTHER:
        return LocationMethod.other;
      case pb_enum_wzdx.LocationMethod.LOCATION_METHOD_UNKNOWN:
        return LocationMethod.unknown;
      default:
        return LocationMethod.unknown;
    }
  }
}

enum VehicleImpact {
  @JsonValue('all-lanes-closed')
  allLanesClosed,
  @JsonValue('some-lanes-closed')
  someLanesClosed,
  @JsonValue('all-lanes-open')
  allLanesOpen,
  @JsonValue('alternating-one-way')
  alternatingOneWay,
  @JsonValue('some-lanes-closed-merge-left')
  someLanesClosedMergeLeft,
  @JsonValue('some-lanes-closed-merge-right')
  someLanesClosedMergeRight,
  @JsonValue('all-lanes-open-shift-left')
  allLanesOpenShiftLeft,
  @JsonValue('all-lanes-open-shift-right')
  allLanesOpenShiftRight,
  @JsonValue('some-lanes-closed-split')
  someLanesClosedSplit,
  @JsonValue('flagging')
  flagging,
  @JsonValue('temporary-traffic-signal')
  temporaryTrafficSignal,
  @JsonValue('unknown')
  unknown;

  static fromProto(pb_enum_wzdx.VehicleImpact impact) {
    switch (impact) {
      case pb_enum_wzdx.VehicleImpact.VEHICLE_IMPACT_ALL_LANES_CLOSED:
        return VehicleImpact.allLanesClosed;
      case pb_enum_wzdx.VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED:
        return VehicleImpact.someLanesClosed;
      case pb_enum_wzdx.VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN:
        return VehicleImpact.allLanesOpen;
      case pb_enum_wzdx.VehicleImpact.VEHICLE_IMPACT_ALTERNATING_ONE_WAY:
        return VehicleImpact.alternatingOneWay;
      case pb_enum_wzdx
            .VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_LEFT:
        return VehicleImpact.someLanesClosedMergeLeft;
      case pb_enum_wzdx
            .VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_RIGHT:
        return VehicleImpact.someLanesClosedMergeRight;
      case pb_enum_wzdx.VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN_SHIFT_LEFT:
        return VehicleImpact.allLanesOpenShiftLeft;
      case pb_enum_wzdx.VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN_SHIFT_RIGHT:
        return VehicleImpact.allLanesOpenShiftRight;
      case pb_enum_wzdx.VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_SPLIT:
        return VehicleImpact.someLanesClosedSplit;
      case pb_enum_wzdx.VehicleImpact.VEHICLE_IMPACT_FLAGGING:
        return VehicleImpact.flagging;
      case pb_enum_wzdx.VehicleImpact.VEHICLE_IMPACT_TEMPORARY_TRAFFIC_SIGNAL:
        return VehicleImpact.temporaryTrafficSignal;
      case pb_enum_wzdx.VehicleImpact.VEHICLE_IMPACT_UNKNOWN:
        return VehicleImpact.unknown;
      default:
        return VehicleImpact.unknown;
    }
  }

  static fromProtoWithAllowedTypes(pb_enum_wzdx.VehicleImpact impact) {
    switch (impact) {
      case pb_enum_wzdx.VehicleImpact.VEHICLE_IMPACT_ALL_LANES_CLOSED:
        return VehicleImpact.allLanesClosed;
      case pb_enum_wzdx.VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED:
        return VehicleImpact.someLanesClosed;
      case pb_enum_wzdx.VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN:
        return VehicleImpact.allLanesOpen;
      case pb_enum_wzdx.VehicleImpact.VEHICLE_IMPACT_ALTERNATING_ONE_WAY:
        return VehicleImpact.alternatingOneWay;
      case pb_enum_wzdx
            .VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_LEFT:
        return VehicleImpact.someLanesClosed;
      case pb_enum_wzdx
            .VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_RIGHT:
        return VehicleImpact.someLanesClosed;
      case pb_enum_wzdx.VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN_SHIFT_LEFT:
        return VehicleImpact.allLanesOpen;
      case pb_enum_wzdx.VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN_SHIFT_RIGHT:
        return VehicleImpact.allLanesOpen;
      case pb_enum_wzdx.VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_SPLIT:
        return VehicleImpact.someLanesClosed;
      case pb_enum_wzdx.VehicleImpact.VEHICLE_IMPACT_FLAGGING:
        return VehicleImpact.allLanesOpen;
      case pb_enum_wzdx.VehicleImpact.VEHICLE_IMPACT_TEMPORARY_TRAFFIC_SIGNAL:
        return VehicleImpact.allLanesClosed;
      case pb_enum_wzdx.VehicleImpact.VEHICLE_IMPACT_UNKNOWN:
        return VehicleImpact.allLanesOpen;
      default:
        return VehicleImpact.allLanesOpen;
    }
  }
}

enum LaneType {
  @JsonValue('general')
  general,
  @JsonValue('exit-lane')
  exitLane,
  @JsonValue('exit-ramp')
  exitRamp,
  @JsonValue('entrance-lane')
  entranceLane,
  @JsonValue('entrance-ramp')
  entranceRamp,
  @JsonValue('sidewalk')
  sidewalk,
  @JsonValue('bike-lane')
  bikeLane,
  @JsonValue('shoulder')
  shoulder,
  @JsonValue('parking')
  parking,
  @JsonValue('median')
  median,
  @JsonValue('two-way-center-turn-lane')
  twoWayCenterTurnLane;

  static fromProto(pb_enum_wzdx.LaneType type) {
    switch (type) {
      case pb_enum_wzdx.LaneType.LANE_TYPE_GENERAL:
        return LaneType.general;
      case pb_enum_wzdx.LaneType.LANE_TYPE_EXIT_LANE:
        return LaneType.exitLane;
      case pb_enum_wzdx.LaneType.LANE_TYPE_EXIT_RAMP:
        return LaneType.exitRamp;
      case pb_enum_wzdx.LaneType.LANE_TYPE_ENTRANCE_LANE:
        return LaneType.entranceLane;
      case pb_enum_wzdx.LaneType.LANE_TYPE_ENTRANCE_RAMP:
        return LaneType.entranceRamp;
      case pb_enum_wzdx.LaneType.LANE_TYPE_SIDEWALK:
        return LaneType.sidewalk;
      case pb_enum_wzdx.LaneType.LANE_TYPE_BIKE_LANE:
        return LaneType.bikeLane;
      case pb_enum_wzdx.LaneType.LANE_TYPE_SHOULDER:
        return LaneType.shoulder;
      case pb_enum_wzdx.LaneType.LANE_TYPE_PARKING:
        return LaneType.parking;
      case pb_enum_wzdx.LaneType.LANE_TYPE_MEDIAN:
        return LaneType.median;
      case pb_enum_wzdx.LaneType.LANE_TYPE_TWO_WAY_CENTER_TURN_LANE:
        return LaneType.twoWayCenterTurnLane;
      default:
        return LaneType.general;
    }
  }
}

enum LaneStatus {
  @JsonValue('open')
  open,
  @JsonValue('closed')
  closed,
  @JsonValue('shift-left')
  shiftLeft,
  @JsonValue('shift-right')
  shiftRight,
  @JsonValue('merge-left')
  mergeLeft,
  @JsonValue('merge-right')
  mergeRight,
  @JsonValue('alternating-flow')
  alternatingFlow;

  static fromProto(pb_enum_wzdx.LaneStatus status) {
    switch (status) {
      case pb_enum_wzdx.LaneStatus.LANE_STATUS_OPEN:
        return LaneStatus.open;
      case pb_enum_wzdx.LaneStatus.LANE_STATUS_CLOSED:
        return LaneStatus.closed;
      case pb_enum_wzdx.LaneStatus.LANE_STATUS_SHIFT_LEFT:
        return LaneStatus.shiftLeft;
      case pb_enum_wzdx.LaneStatus.LANE_STATUS_SHIFT_RIGHT:
        return LaneStatus.shiftRight;
      case pb_enum_wzdx.LaneStatus.LANE_STATUS_MERGE_LEFT:
        return LaneStatus.mergeLeft;
      case pb_enum_wzdx.LaneStatus.LANE_STATUS_MERGE_RIGHT:
        return LaneStatus.mergeRight;
      case pb_enum_wzdx.LaneStatus.LANE_STATUS_ALTERNATING_FLOW:
        return LaneStatus.alternatingFlow;
      default:
        return LaneStatus.open;
    }
  }
}

enum RestrictionType {
  @JsonValue('local-access-only')
  localAccessOnly,
  @JsonValue('no-trucks')
  noTrucks,
  @JsonValue('travel-peak-hours-only')
  travelPeakHoursOnly,
  @JsonValue('hov-3')
  hov3,
  @JsonValue('hov-2')
  hov2,
  @JsonValue('no-parking')
  noParking,
  @JsonValue('reduced-width')
  reducedWidth,
  @JsonValue('reduced-height')
  reducedHeight,
  @JsonValue('reduced-length')
  reducedLength,
  @JsonValue('reduced-weight')
  reducedWeight,
  @JsonValue('axle-load-limit')
  axleLoadLimit,
  @JsonValue('gross-weight-limit')
  grossWeightLimit,
  @JsonValue('towing-prohibited')
  towingProhibited,
  @JsonValue('permitted-oversize-loads-prohibited')
  permittedOversizeLoadsProhibited,
  @JsonValue('no-passing')
  noPassing;

  static fromProto(pb_enum_wzdx.RestrictionType type) {
    switch (type) {
      case pb_enum_wzdx.RestrictionType.RESTRICTION_TYPE_LOCAL_ACCESS_ONLY:
        return RestrictionType.localAccessOnly;
      case pb_enum_wzdx.RestrictionType.RESTRICTION_TYPE_NO_TRUCKS:
        return RestrictionType.noTrucks;
      case pb_enum_wzdx.RestrictionType.RESTRICTION_TYPE_TRAVEL_PEAK_HOURS_ONLY:
        return RestrictionType.travelPeakHoursOnly;
      case pb_enum_wzdx.RestrictionType.RESTRICTION_TYPE_HOV_3:
        return RestrictionType.hov3;
      case pb_enum_wzdx.RestrictionType.RESTRICTION_TYPE_HOV_2:
        return RestrictionType.hov2;
      case pb_enum_wzdx.RestrictionType.RESTRICTION_TYPE_NO_PARKING:
        return RestrictionType.noParking;
      case pb_enum_wzdx.RestrictionType.RESTRICTION_TYPE_REDUCED_WIDTH:
        return RestrictionType.reducedWidth;
      case pb_enum_wzdx.RestrictionType.RESTRICTION_TYPE_REDUCED_HEIGHT:
        return RestrictionType.reducedHeight;
      case pb_enum_wzdx.RestrictionType.RESTRICTION_TYPE_REDUCED_LENGTH:
        return RestrictionType.reducedLength;
      case pb_enum_wzdx.RestrictionType.RESTRICTION_TYPE_REDUCED_WEIGHT:
        return RestrictionType.reducedWeight;
      case pb_enum_wzdx.RestrictionType.RESTRICTION_TYPE_AXLE_LOAD_LIMIT:
        return RestrictionType.axleLoadLimit;
      case pb_enum_wzdx.RestrictionType.RESTRICTION_TYPE_GROSS_WEIGHT_LIMIT:
        return RestrictionType.grossWeightLimit;
      case pb_enum_wzdx.RestrictionType.RESTRICTION_TYPE_TOWING_PROHIBITED:
        return RestrictionType.towingProhibited;
      case pb_enum_wzdx.RestrictionType
            .RESTRICTION_TYPE_PERMITTED_OVERSIZE_LOADS_PROHIBITED:
        return RestrictionType.permittedOversizeLoadsProhibited;
      case pb_enum_wzdx.RestrictionType.RESTRICTION_TYPE_NO_PASSING:
        return RestrictionType.noPassing;
      default:
        return RestrictionType.localAccessOnly;
    }
  }
}

enum UnitOfMeasurement {
  @JsonValue('feet')
  feet,
  @JsonValue('meters')
  meters,
  @JsonValue('centimeters')
  centimeters,
  @JsonValue('pounds')
  pounds,
  @JsonValue('tons')
  tons,
  @JsonValue('kilograms')
  kilograms;

  static fromProto(pb_enum_wzdx.UnitOfMeasurement unit) {
    switch (unit) {
      case pb_enum_wzdx.UnitOfMeasurement.UNIT_OF_MEASUREMENT_FEET:
        return UnitOfMeasurement.feet;
      case pb_enum_wzdx.UnitOfMeasurement.UNIT_OF_MEASUREMENT_METERS:
        return UnitOfMeasurement.meters;
      case pb_enum_wzdx.UnitOfMeasurement.UNIT_OF_MEASUREMENT_CENTIMETERS:
        return UnitOfMeasurement.centimeters;
      case pb_enum_wzdx.UnitOfMeasurement.UNIT_OF_MEASUREMENT_POUNDS:
        return UnitOfMeasurement.pounds;
      case pb_enum_wzdx.UnitOfMeasurement.UNIT_OF_MEASUREMENT_TONS:
        return UnitOfMeasurement.tons;
      case pb_enum_wzdx.UnitOfMeasurement.UNIT_OF_MEASUREMENT_KILOGRAMS:
        return UnitOfMeasurement.kilograms;
      default:
        return UnitOfMeasurement.feet;
    }
  }
}

@JsonSerializable()
class Restriction {
  final RestrictionType type;
  final double value;
  final UnitOfMeasurement unit;

  Restriction({
    required this.type,
    required this.value,
    required this.unit,
  });

  factory Restriction.fromProto(pb_wzdx.Restriction restriction) {
    return Restriction(
      type: RestrictionType.fromProto(restriction.type),
      value: restriction.value,
      unit: UnitOfMeasurement.fromProto(restriction.unit),
    );
  }

  factory Restriction.fromJson(Map<String, dynamic> json) =>
      _$RestrictionFromJson(json);
  Map<String, dynamic> toJson() => _$RestrictionToJson(this);
}

@JsonSerializable()
class Lane {
  @JsonKey(name: 'order')
  final int laneOrder;
  @JsonKey(name: 'type')
  final LaneType type;
  @JsonKey(name: 'status')
  final LaneStatus status;
  @JsonKey(name: 'restrictions')
  final List<Restriction> restrictions;

  Lane({
    required this.laneOrder,
    required this.type,
    required this.status,
    required this.restrictions,
  });

  factory Lane.fromProto(pb_wzdx.Lane lane) {
    return Lane(
      laneOrder: lane.laneOrder,
      type: LaneType.fromProto(lane.type),
      status: LaneStatus.fromProto(lane.status),
      restrictions: lane.restrictions
          .map((restriction) => Restriction.fromProto(restriction))
          .toList(),
    );
  }

  Lane copyWith({
    int? laneOrder,
    LaneType? type,
    LaneStatus? status,
    List<Restriction>? restrictions,
  }) {
    return Lane(
      laneOrder: laneOrder ?? this.laneOrder,
      type: type ?? this.type,
      status: status ?? this.status,
      restrictions: restrictions ?? this.restrictions,
    );
  }

  factory Lane.fromJson(Map<String, dynamic> json) => _$LaneFromJson(json);
  Map<String, dynamic> toJson() => _$LaneToJson(this);
}

enum WorkTypeName {
  @JsonValue('maintenance')
  maintenance,
  @JsonValue('minor-road-defect-repair')
  minorRoadDefectRepair,
  @JsonValue('roadside-work')
  roadsideWork,
  @JsonValue('overhead-work')
  overheadWork,
  @JsonValue('below-road-work')
  belowRoadWork,
  @JsonValue('barrier-work')
  barrierWork,
  @JsonValue('surface-work')
  surfaceWork,
  @JsonValue('painting')
  painting,
  @JsonValue('roadway-relocation')
  roadwayRelocation,
  @JsonValue('roadway-creation')
  roadwayCreation;

  static fromProto(pb_enum_wzdx.WorkTypeName type) {
    switch (type) {
      case pb_enum_wzdx.WorkTypeName.WORK_TYPE_NAME_MAINTENANCE:
        return WorkTypeName.maintenance;
      case pb_enum_wzdx.WorkTypeName.WORK_TYPE_NAME_MINOR_ROAD_DEFECT_REPAIR:
        return WorkTypeName.minorRoadDefectRepair;
      case pb_enum_wzdx.WorkTypeName.WORK_TYPE_NAME_ROADSIDE_WORK:
        return WorkTypeName.roadsideWork;
      case pb_enum_wzdx.WorkTypeName.WORK_TYPE_NAME_OVERHEAD_WORK:
        return WorkTypeName.overheadWork;
      case pb_enum_wzdx.WorkTypeName.WORK_TYPE_NAME_BELOW_ROAD_WORK:
        return WorkTypeName.belowRoadWork;
      case pb_enum_wzdx.WorkTypeName.WORK_TYPE_NAME_BARRIER_WORK:
        return WorkTypeName.barrierWork;
      case pb_enum_wzdx.WorkTypeName.WORK_TYPE_NAME_SURFACE_WORK:
        return WorkTypeName.surfaceWork;
      case pb_enum_wzdx.WorkTypeName.WORK_TYPE_NAME_PAINTING:
        return WorkTypeName.painting;
      case pb_enum_wzdx.WorkTypeName.WORK_TYPE_NAME_ROADWAY_RELOCATION:
        return WorkTypeName.roadwayRelocation;
      case pb_enum_wzdx.WorkTypeName.WORK_TYPE_NAME_ROADWAY_CREATION:
        return WorkTypeName.roadwayCreation;
      default:
        return WorkTypeName.maintenance;
    }
  }
}

@JsonSerializable()
class TypeOfWork {
  @JsonKey(name: 'type_name')
  final WorkTypeName typeName;
  @JsonKey(name: 'is_architectural_change')
  final bool isArchitecturalChange;

  TypeOfWork({
    required this.typeName,
    required this.isArchitecturalChange,
  });

  factory TypeOfWork.fromProto(pb_wzdx.TypeOfWork typeOfWork) {
    return TypeOfWork(
      typeName: WorkTypeName.fromProto(typeOfWork.typeName),
      isArchitecturalChange: typeOfWork.isArchitecturalChange,
    );
  }

  factory TypeOfWork.fromJson(Map<String, dynamic> json) =>
      _$TypeOfWorkFromJson(json);
  Map<String, dynamic> toJson() => _$TypeOfWorkToJson(this);
}

enum RoadSegmentSurfaceType {
  @JsonValue('paved')
  paved,
  @JsonValue('gravel')
  gravel,
  @JsonValue('dirt')
  dirt,
  @JsonValue('grooved')
  grooved;

  static fromProto(pb_enum_common.RoadSurfaceType type) {
    switch (type) {
      case pb_enum_common.RoadSurfaceType.ROAD_SURFACE_TYPE_PAVED:
        return RoadSegmentSurfaceType.paved;
      case pb_enum_common.RoadSurfaceType.ROAD_SURFACE_TYPE_GRAVEL:
        return RoadSegmentSurfaceType.gravel;
      case pb_enum_common.RoadSurfaceType.ROAD_SURFACE_TYPE_DIRT:
        return RoadSegmentSurfaceType.dirt;
      case pb_enum_common.RoadSurfaceType.ROAD_SURFACE_TYPE_GROOVED:
        return RoadSegmentSurfaceType.grooved;
      default:
        return RoadSegmentSurfaceType.paved;
    }
  }
}

enum WorkerPresenceDefinition {
  @JsonValue('workers-in-work-zone-working')
  workersInWorkZoneWorking,
  @JsonValue('workers-in-work-zone-not-working')
  workersInWorkZoneNotWorking,
  @JsonValue('mobile-equipment-in-work-zone-moving')
  mobileEquipmentInWorkZoneMoving,
  @JsonValue('mobile-equipment-in-work-zone-not-moving')
  mobileEquipmentInWorkZoneNotMoving,
  @JsonValue('fixed-equipment-in-work-zone')
  fixedEquipmentInWorkZone,
  @JsonValue('humans-behind-barrier')
  humansBehindBarrier,
  @JsonValue('humans-in-right-of-way')
  humansInRightOfWay;

  static fromProto(pb_enum_wzdx.WorkerPresenceDefinition definition) {
    switch (definition) {
      case pb_enum_wzdx.WorkerPresenceDefinition
            .WORKER_PRESENCE_DEFINITION_WORKERS_IN_WORK_ZONE_WORKING:
        return WorkerPresenceDefinition.workersInWorkZoneWorking;
      case pb_enum_wzdx.WorkerPresenceDefinition
            .WORKER_PRESENCE_DEFINITION_WORKERS_IN_WORK_ZONE_NOT_WORKING:
        return WorkerPresenceDefinition.workersInWorkZoneNotWorking;
      case pb_enum_wzdx.WorkerPresenceDefinition
            .WORKER_PRESENCE_DEFINITION_MOBILE_EQUIPMENT_IN_WORK_ZONE_MOVING:
        return WorkerPresenceDefinition.mobileEquipmentInWorkZoneMoving;
      case pb_enum_wzdx.WorkerPresenceDefinition
            .WORKER_PRESENCE_DEFINITION_MOBILE_EQUIPMENT_IN_WORK_ZONE_NOT_MOVING:
        return WorkerPresenceDefinition.mobileEquipmentInWorkZoneNotMoving;
      case pb_enum_wzdx.WorkerPresenceDefinition
            .WORKER_PRESENCE_DEFINITION_FIXED_EQUIPMENT_IN_WORK_ZONE:
        return WorkerPresenceDefinition.fixedEquipmentInWorkZone;
      case pb_enum_wzdx.WorkerPresenceDefinition
            .WORKER_PRESENCE_DEFINITION_HUMANS_BEHIND_BARRIER:
        return WorkerPresenceDefinition.humansBehindBarrier;
      case pb_enum_wzdx.WorkerPresenceDefinition
            .WORKER_PRESENCE_DEFINITION_HUMANS_IN_RIGHT_OF_WAY:
        return WorkerPresenceDefinition.humansInRightOfWay;
      default:
        return WorkerPresenceDefinition.workersInWorkZoneWorking;
    }
  }
}

enum WorkerPresenceMethod {
  @JsonValue('camera-monitoring')
  cameraMonitoring,
  @JsonValue('arrow-board-present')
  arrowBoardPresent,
  @JsonValue('cones-present')
  conesPresent,
  @JsonValue('maintenance-vehicle-present')
  maintenanceVehiclePresent,
  @JsonValue('wearables-present')
  wearablesPresent,
  @JsonValue('mobile-device-present')
  mobileDevicePresent,
  @JsonValue('check-in-app')
  checkInApp,
  @JsonValue('check-in-verbal')
  checkInVerbal,
  @JsonValue('scheduled')
  scheduled;

  static fromProto(pb_enum_wzdx.WorkerPresenceMethod method) {
    switch (method) {
      case pb_enum_wzdx
            .WorkerPresenceMethod.WORKER_PRESENCE_METHOD_CAMERA_MONITORING:
        return WorkerPresenceMethod.cameraMonitoring;
      case pb_enum_wzdx.WorkerPresenceMethod
            .WORKER_PRESENCE_METHOD_UNKNOWN: // TODO: Link to ARROW_BOARD_PRESENT
        return WorkerPresenceMethod.arrowBoardPresent;
      case pb_enum_wzdx
            .WorkerPresenceMethod.WORKER_PRESENCE_METHOD_CONES_PRESENT:
        return WorkerPresenceMethod.conesPresent;
      case pb_enum_wzdx.WorkerPresenceMethod
            .WORKER_PRESENCE_METHOD_MAINTENANCE_VEHICLE_PRESENT:
        return WorkerPresenceMethod.maintenanceVehiclePresent;
      case pb_enum_wzdx
            .WorkerPresenceMethod.WORKER_PRESENCE_METHOD_WEARABLES_PRESENT:
        return WorkerPresenceMethod.wearablesPresent;
      case pb_enum_wzdx
            .WorkerPresenceMethod.WORKER_PRESENCE_METHOD_MOBILE_DEVICE_PRESENT:
        return WorkerPresenceMethod.mobileDevicePresent;
      case pb_enum_wzdx
            .WorkerPresenceMethod.WORKER_PRESENCE_METHOD_CHECK_IN_APP:
        return WorkerPresenceMethod.checkInApp;
      case pb_enum_wzdx
            .WorkerPresenceMethod.WORKER_PRESENCE_METHOD_CHECK_IN_VERBAL:
        return WorkerPresenceMethod.checkInVerbal;
      case pb_enum_wzdx.WorkerPresenceMethod.WORKER_PRESENCE_METHOD_SCHEDULED:
        return WorkerPresenceMethod.scheduled;
      default:
        return WorkerPresenceMethod.scheduled;
    }
  }
}

enum WorkerPresenceConfidence {
  @JsonValue('low')
  low,
  @JsonValue('medium')
  medium,
  @JsonValue('high')
  high;

  static fromProto(pb_enum_wzdx.WorkerPresenceConfidence confidence) {
    switch (confidence) {
      case pb_enum_wzdx.WorkerPresenceConfidence.WORKER_PRESENCE_CONFIDENCE_LOW:
        return WorkerPresenceConfidence.low;
      case pb_enum_wzdx
            .WorkerPresenceConfidence.WORKER_PRESENCE_CONFIDENCE_MEDIUM:
        return WorkerPresenceConfidence.medium;
      case pb_enum_wzdx
            .WorkerPresenceConfidence.WORKER_PRESENCE_CONFIDENCE_HIGH:
        return WorkerPresenceConfidence.high;
      default:
        return WorkerPresenceConfidence.low;
    }
  }
}

@JsonSerializable()
class WorkerPresence {
  @JsonKey(name: 'are_workers_present')
  final bool areWorkersPresent;
  final WorkerPresenceDefinition definition;
  final WorkerPresenceMethod method;
  @JsonKey(name: 'worker_presence_last_confirmed_date')
  final int workerPresenceLastConfirmedDate;
  final WorkerPresenceConfidence confidence;

  WorkerPresence({
    required this.areWorkersPresent,
    required this.definition,
    required this.method,
    required this.workerPresenceLastConfirmedDate,
    required this.confidence,
  });

  factory WorkerPresence.fromProto(pb_wzdx.WorkerPresence workerPresence) {
    return WorkerPresence(
      areWorkersPresent: workerPresence.areWorkersPresent,
      definition: WorkerPresenceDefinition.fromProto(workerPresence.definition),
      method: WorkerPresenceMethod.fromProto(workerPresence.method),
      workerPresenceLastConfirmedDate: ProtobufUtils.fromTimestamp(
              workerPresence.workerPresenceLastConfirmedDate)
          .millisecondsSinceEpoch,
      confidence: WorkerPresenceConfidence.fromProto(workerPresence.confidence),
    );
  }

  factory WorkerPresence.fromJson(Map<String, dynamic> json) =>
      _$WorkerPresenceFromJson(json);
  Map<String, dynamic> toJson() => _$WorkerPresenceToJson(this);
}
