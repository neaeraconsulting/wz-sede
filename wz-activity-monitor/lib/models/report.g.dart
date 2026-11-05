// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) => Report(
      projectId: (json['project_id'] as num?)?.toInt(),
      roadEventId: (json['road_event_id'] as num?)?.toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      typesOfWork: (json['types_of_work'] as List<dynamic>)
          .map((e) => TypeOfWork.fromJson(e as Map<String, dynamic>))
          .toList(),
      roadName: json['road_name'] as String?,
      direction:
          $enumDecodeNullable(_$RoadwayDirectionEnumMap, json['direction']),
      workersPresent: json['workers_present'] as bool,
      startDate: DateTimeJsonConverter.fromJsonNullable(
          (json['start_date'] as num?)?.toInt()),
      endDate: DateTimeJsonConverter.fromJsonNullable(
          (json['end_date'] as num?)?.toInt()),
      timestamp:
          DateTimeJsonConverter.fromJson((json['timestamp'] as num).toInt()),
      areaType: $enumDecode(_$WorkZoneTypeEnumMap, json['area_type']),
      speedLimitMph: (json['speed_limit_mph'] as num?)?.toDouble(),
      geometryType: $enumDecode(_$GeometryTypeEnumMap, json['geometry_type']),
      geometry: LatLngJsonConverter.fromJsonList(json['geometry'] as List),
      geometryLineWidth: (json['geometry_line_width'] as num?)?.toDouble(),
      vehicleImpact:
          $enumDecodeNullable(_$VehicleImpactEnumMap, json['vehicle_impact']),
      surfaceType: $enumDecodeNullable(
          _$RoadSegmentSurfaceTypeEnumMap, json['surface_type']),
      userId: json['user_id'] as String?,
      eventSchedule: json['event_schedule'] == null
          ? null
          : EventRecurrence.fromJson(
              json['event_schedule'] as Map<String, dynamic>),
      workerPresenceSchedule: json['worker_presence_schedule'] == null
          ? null
          : EventRecurrence.fromJson(
              json['worker_presence_schedule'] as Map<String, dynamic>),
      linkedFieldDeviceIds: (json['linked_field_device_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'project_id': instance.projectId,
      'road_event_id': instance.roadEventId,
      'name': instance.name,
      'description': instance.description,
      'types_of_work': instance.typesOfWork,
      'road_name': instance.roadName,
      'direction': _$RoadwayDirectionEnumMap[instance.direction],
      'workers_present': instance.workersPresent,
      'start_date': DateTimeJsonConverter.toJsonNullable(instance.startDate),
      'end_date': DateTimeJsonConverter.toJsonNullable(instance.endDate),
      'timestamp': DateTimeJsonConverter.toJson(instance.timestamp),
      'area_type': _$WorkZoneTypeEnumMap[instance.areaType]!,
      'speed_limit_mph': instance.speedLimitMph,
      'geometry_type': _$GeometryTypeEnumMap[instance.geometryType]!,
      'geometry': LatLngJsonConverter.toJsonList(instance.geometry),
      'geometry_line_width': instance.geometryLineWidth,
      'vehicle_impact': _$VehicleImpactEnumMap[instance.vehicleImpact],
      'surface_type': _$RoadSegmentSurfaceTypeEnumMap[instance.surfaceType],
      'user_id': instance.userId,
      'event_schedule': instance.eventSchedule,
      'worker_presence_schedule': instance.workerPresenceSchedule,
      'linked_field_device_ids': instance.linkedFieldDeviceIds,
    };

const _$RoadwayDirectionEnumMap = {
  RoadwayDirection.northbound: 'northbound',
  RoadwayDirection.eastbound: 'eastbound',
  RoadwayDirection.southbound: 'southbound',
  RoadwayDirection.westbound: 'westbound',
  RoadwayDirection.innerLoop: 'inner-loop',
  RoadwayDirection.outerLoop: 'outer-loop',
  RoadwayDirection.undefined: 'undefined',
  RoadwayDirection.unknown: 'unknown',
};

const _$WorkZoneTypeEnumMap = {
  WorkZoneType.static: 'static',
  WorkZoneType.moving: 'moving',
  WorkZoneType.plannedMovingArea: 'planned-moving-area',
};

const _$GeometryTypeEnumMap = {
  GeometryType.multipoint: 'multipoint',
  GeometryType.linestring: 'linestring',
  GeometryType.polygon: 'polygon',
};

const _$VehicleImpactEnumMap = {
  VehicleImpact.allLanesClosed: 'all-lanes-closed',
  VehicleImpact.someLanesClosed: 'some-lanes-closed',
  VehicleImpact.allLanesOpen: 'all-lanes-open',
  VehicleImpact.alternatingOneWay: 'alternating-one-way',
  VehicleImpact.someLanesClosedMergeLeft: 'some-lanes-closed-merge-left',
  VehicleImpact.someLanesClosedMergeRight: 'some-lanes-closed-merge-right',
  VehicleImpact.allLanesOpenShiftLeft: 'all-lanes-open-shift-left',
  VehicleImpact.allLanesOpenShiftRight: 'all-lanes-open-shift-right',
  VehicleImpact.someLanesClosedSplit: 'some-lanes-closed-split',
  VehicleImpact.flagging: 'flagging',
  VehicleImpact.temporaryTrafficSignal: 'temporary-traffic-signal',
  VehicleImpact.unknown: 'unknown',
};

const _$RoadSegmentSurfaceTypeEnumMap = {
  RoadSegmentSurfaceType.paved: 'paved',
  RoadSegmentSurfaceType.gravel: 'gravel',
  RoadSegmentSurfaceType.dirt: 'dirt',
  RoadSegmentSurfaceType.grooved: 'grooved',
};

ReportWithId _$ReportWithIdFromJson(Map<String, dynamic> json) => ReportWithId(
      id: (json['id'] as num).toInt(),
      projectId: (json['project_id'] as num?)?.toInt(),
      roadEventId: (json['road_event_id'] as num?)?.toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      typesOfWork: (json['types_of_work'] as List<dynamic>)
          .map((e) => TypeOfWork.fromJson(e as Map<String, dynamic>))
          .toList(),
      roadName: json['road_name'] as String?,
      direction:
          $enumDecodeNullable(_$RoadwayDirectionEnumMap, json['direction']),
      workersPresent: json['workers_present'] as bool,
      startDate: DateTimeJsonConverter.fromJsonNullable(
          (json['start_date'] as num?)?.toInt()),
      endDate: DateTimeJsonConverter.fromJsonNullable(
          (json['end_date'] as num?)?.toInt()),
      timestamp:
          DateTimeJsonConverter.fromJson((json['timestamp'] as num).toInt()),
      areaType: $enumDecode(_$WorkZoneTypeEnumMap, json['area_type']),
      speedLimitMph: (json['speed_limit_mph'] as num?)?.toDouble(),
      geometryType: $enumDecode(_$GeometryTypeEnumMap, json['geometry_type']),
      geometry: LatLngJsonConverter.fromJsonList(json['geometry'] as List),
      geometryLineWidth: (json['geometry_line_width'] as num?)?.toDouble(),
      vehicleImpact:
          $enumDecodeNullable(_$VehicleImpactEnumMap, json['vehicle_impact']),
      surfaceType: $enumDecodeNullable(
          _$RoadSegmentSurfaceTypeEnumMap, json['surface_type']),
      userId: json['user_id'] as String?,
      eventSchedule: json['event_schedule'] == null
          ? null
          : EventRecurrence.fromJson(
              json['event_schedule'] as Map<String, dynamic>),
      workerPresenceSchedule: json['worker_presence_schedule'] == null
          ? null
          : EventRecurrence.fromJson(
              json['worker_presence_schedule'] as Map<String, dynamic>),
      linkedFieldDeviceIds: (json['linked_field_device_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ReportWithIdToJson(ReportWithId instance) =>
    <String, dynamic>{
      'project_id': instance.projectId,
      'road_event_id': instance.roadEventId,
      'name': instance.name,
      'description': instance.description,
      'types_of_work': instance.typesOfWork,
      'road_name': instance.roadName,
      'direction': _$RoadwayDirectionEnumMap[instance.direction],
      'workers_present': instance.workersPresent,
      'start_date': DateTimeJsonConverter.toJsonNullable(instance.startDate),
      'end_date': DateTimeJsonConverter.toJsonNullable(instance.endDate),
      'timestamp': DateTimeJsonConverter.toJson(instance.timestamp),
      'area_type': _$WorkZoneTypeEnumMap[instance.areaType]!,
      'speed_limit_mph': instance.speedLimitMph,
      'geometry_type': _$GeometryTypeEnumMap[instance.geometryType]!,
      'geometry': LatLngJsonConverter.toJsonList(instance.geometry),
      'geometry_line_width': instance.geometryLineWidth,
      'vehicle_impact': _$VehicleImpactEnumMap[instance.vehicleImpact],
      'surface_type': _$RoadSegmentSurfaceTypeEnumMap[instance.surfaceType],
      'user_id': instance.userId,
      'event_schedule': instance.eventSchedule,
      'worker_presence_schedule': instance.workerPresenceSchedule,
      'linked_field_device_ids': instance.linkedFieldDeviceIds,
      'id': instance.id,
    };

EventRecurrence _$EventRecurrenceFromJson(Map<String, dynamic> json) =>
    EventRecurrence(
      startTime:
          DateTimeJsonConverter.fromTimeOfDayJson(json['start_time'] as String),
      endTime:
          DateTimeJsonConverter.fromTimeOfDayJson(json['end_time'] as String),
      startDate:
          DateTimeJsonConverter.fromDateJson(json['start_date'] as String),
      endDate: DateTimeJsonConverter.fromDateJson(json['end_date'] as String),
      daysOfWeek: (json['days_of_week'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      exclusion: json['exclusion'] as bool? ?? false,
    );

Map<String, dynamic> _$EventRecurrenceToJson(EventRecurrence instance) =>
    <String, dynamic>{
      'start_time': DateTimeJsonConverter.toTimeOfDayJson(instance.startTime),
      'end_time': DateTimeJsonConverter.toTimeOfDayJson(instance.endTime),
      'start_date': DateTimeJsonConverter.toDateJson(instance.startDate),
      'end_date': DateTimeJsonConverter.toDateJson(instance.endDate),
      'days_of_week': instance.daysOfWeek,
      'exclusion': instance.exclusion,
    };
