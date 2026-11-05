// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wzdx_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restriction _$RestrictionFromJson(Map<String, dynamic> json) => Restriction(
      type: $enumDecode(_$RestrictionTypeEnumMap, json['type']),
      value: (json['value'] as num).toDouble(),
      unit: $enumDecode(_$UnitOfMeasurementEnumMap, json['unit']),
    );

Map<String, dynamic> _$RestrictionToJson(Restriction instance) =>
    <String, dynamic>{
      'type': _$RestrictionTypeEnumMap[instance.type]!,
      'value': instance.value,
      'unit': _$UnitOfMeasurementEnumMap[instance.unit]!,
    };

const _$RestrictionTypeEnumMap = {
  RestrictionType.localAccessOnly: 'local-access-only',
  RestrictionType.noTrucks: 'no-trucks',
  RestrictionType.travelPeakHoursOnly: 'travel-peak-hours-only',
  RestrictionType.hov3: 'hov-3',
  RestrictionType.hov2: 'hov-2',
  RestrictionType.noParking: 'no-parking',
  RestrictionType.reducedWidth: 'reduced-width',
  RestrictionType.reducedHeight: 'reduced-height',
  RestrictionType.reducedLength: 'reduced-length',
  RestrictionType.reducedWeight: 'reduced-weight',
  RestrictionType.axleLoadLimit: 'axle-load-limit',
  RestrictionType.grossWeightLimit: 'gross-weight-limit',
  RestrictionType.towingProhibited: 'towing-prohibited',
  RestrictionType.permittedOversizeLoadsProhibited:
      'permitted-oversize-loads-prohibited',
  RestrictionType.noPassing: 'no-passing',
};

const _$UnitOfMeasurementEnumMap = {
  UnitOfMeasurement.feet: 'feet',
  UnitOfMeasurement.meters: 'meters',
  UnitOfMeasurement.centimeters: 'centimeters',
  UnitOfMeasurement.pounds: 'pounds',
  UnitOfMeasurement.tons: 'tons',
  UnitOfMeasurement.kilograms: 'kilograms',
};

Lane _$LaneFromJson(Map<String, dynamic> json) => Lane(
      laneOrder: (json['order'] as num).toInt(),
      type: $enumDecode(_$LaneTypeEnumMap, json['type']),
      status: $enumDecode(_$LaneStatusEnumMap, json['status']),
      restrictions: (json['restrictions'] as List<dynamic>)
          .map((e) => Restriction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LaneToJson(Lane instance) => <String, dynamic>{
      'order': instance.laneOrder,
      'type': _$LaneTypeEnumMap[instance.type]!,
      'status': _$LaneStatusEnumMap[instance.status]!,
      'restrictions': instance.restrictions,
    };

const _$LaneTypeEnumMap = {
  LaneType.general: 'general',
  LaneType.exitLane: 'exit-lane',
  LaneType.exitRamp: 'exit-ramp',
  LaneType.entranceLane: 'entrance-lane',
  LaneType.entranceRamp: 'entrance-ramp',
  LaneType.sidewalk: 'sidewalk',
  LaneType.bikeLane: 'bike-lane',
  LaneType.shoulder: 'shoulder',
  LaneType.parking: 'parking',
  LaneType.median: 'median',
  LaneType.twoWayCenterTurnLane: 'two-way-center-turn-lane',
};

const _$LaneStatusEnumMap = {
  LaneStatus.open: 'open',
  LaneStatus.closed: 'closed',
  LaneStatus.shiftLeft: 'shift-left',
  LaneStatus.shiftRight: 'shift-right',
  LaneStatus.mergeLeft: 'merge-left',
  LaneStatus.mergeRight: 'merge-right',
  LaneStatus.alternatingFlow: 'alternating-flow',
};

TypeOfWork _$TypeOfWorkFromJson(Map<String, dynamic> json) => TypeOfWork(
      typeName: $enumDecode(_$WorkTypeNameEnumMap, json['type_name']),
      isArchitecturalChange: json['is_architectural_change'] as bool,
    );

Map<String, dynamic> _$TypeOfWorkToJson(TypeOfWork instance) =>
    <String, dynamic>{
      'type_name': _$WorkTypeNameEnumMap[instance.typeName]!,
      'is_architectural_change': instance.isArchitecturalChange,
    };

const _$WorkTypeNameEnumMap = {
  WorkTypeName.maintenance: 'maintenance',
  WorkTypeName.minorRoadDefectRepair: 'minor-road-defect-repair',
  WorkTypeName.roadsideWork: 'roadside-work',
  WorkTypeName.overheadWork: 'overhead-work',
  WorkTypeName.belowRoadWork: 'below-road-work',
  WorkTypeName.barrierWork: 'barrier-work',
  WorkTypeName.surfaceWork: 'surface-work',
  WorkTypeName.painting: 'painting',
  WorkTypeName.roadwayRelocation: 'roadway-relocation',
  WorkTypeName.roadwayCreation: 'roadway-creation',
};

WorkerPresence _$WorkerPresenceFromJson(Map<String, dynamic> json) =>
    WorkerPresence(
      areWorkersPresent: json['are_workers_present'] as bool,
      definition:
          $enumDecode(_$WorkerPresenceDefinitionEnumMap, json['definition']),
      method: $enumDecode(_$WorkerPresenceMethodEnumMap, json['method']),
      workerPresenceLastConfirmedDate:
          (json['worker_presence_last_confirmed_date'] as num).toInt(),
      confidence:
          $enumDecode(_$WorkerPresenceConfidenceEnumMap, json['confidence']),
    );

Map<String, dynamic> _$WorkerPresenceToJson(WorkerPresence instance) =>
    <String, dynamic>{
      'are_workers_present': instance.areWorkersPresent,
      'definition': _$WorkerPresenceDefinitionEnumMap[instance.definition]!,
      'method': _$WorkerPresenceMethodEnumMap[instance.method]!,
      'worker_presence_last_confirmed_date':
          instance.workerPresenceLastConfirmedDate,
      'confidence': _$WorkerPresenceConfidenceEnumMap[instance.confidence]!,
    };

const _$WorkerPresenceDefinitionEnumMap = {
  WorkerPresenceDefinition.workersInWorkZoneWorking:
      'workers-in-work-zone-working',
  WorkerPresenceDefinition.workersInWorkZoneNotWorking:
      'workers-in-work-zone-not-working',
  WorkerPresenceDefinition.mobileEquipmentInWorkZoneMoving:
      'mobile-equipment-in-work-zone-moving',
  WorkerPresenceDefinition.mobileEquipmentInWorkZoneNotMoving:
      'mobile-equipment-in-work-zone-not-moving',
  WorkerPresenceDefinition.fixedEquipmentInWorkZone:
      'fixed-equipment-in-work-zone',
  WorkerPresenceDefinition.humansBehindBarrier: 'humans-behind-barrier',
  WorkerPresenceDefinition.humansInRightOfWay: 'humans-in-right-of-way',
};

const _$WorkerPresenceMethodEnumMap = {
  WorkerPresenceMethod.cameraMonitoring: 'camera-monitoring',
  WorkerPresenceMethod.arrowBoardPresent: 'arrow-board-present',
  WorkerPresenceMethod.conesPresent: 'cones-present',
  WorkerPresenceMethod.maintenanceVehiclePresent: 'maintenance-vehicle-present',
  WorkerPresenceMethod.wearablesPresent: 'wearables-present',
  WorkerPresenceMethod.mobileDevicePresent: 'mobile-device-present',
  WorkerPresenceMethod.checkInApp: 'check-in-app',
  WorkerPresenceMethod.checkInVerbal: 'check-in-verbal',
  WorkerPresenceMethod.scheduled: 'scheduled',
};

const _$WorkerPresenceConfidenceEnumMap = {
  WorkerPresenceConfidence.low: 'low',
  WorkerPresenceConfidence.medium: 'medium',
  WorkerPresenceConfidence.high: 'high',
};
