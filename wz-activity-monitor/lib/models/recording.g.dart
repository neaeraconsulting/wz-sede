// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recording.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recording _$RecordingFromJson(Map<String, dynamic> json) => Recording(
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
      startDate: DateTimeJsonConverter.fromJsonNullable(
          (json['start_date'] as num?)?.toInt()),
      endDate: DateTimeJsonConverter.fromJsonNullable(
          (json['end_date'] as num?)?.toInt()),
      timestamp:
          DateTimeJsonConverter.fromJson((json['timestamp'] as num).toInt()),
      areaType: $enumDecode(_$WorkZoneTypeEnumMap, json['area_type']),
      vehicleImpact:
          $enumDecodeNullable(_$VehicleImpactEnumMap, json['vehicle_impact']),
      surfaceType: $enumDecodeNullable(
          _$RoadSegmentSurfaceTypeEnumMap, json['surface_type']),
      points: (json['points'] as List<dynamic>)
          .map((e) => RecordingPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      userId: json['user_id'] as String?,
      eventSchedule: json['event_schedule'] == null
          ? null
          : EventRecurrence.fromJson(
              json['event_schedule'] as Map<String, dynamic>),
      workerPresenceSchedule: json['worker_presence_schedule'] == null
          ? null
          : EventRecurrence.fromJson(
              json['worker_presence_schedule'] as Map<String, dynamic>),
      recordingStartTimestamp: json['recording_start_timestamp'] == null
          ? null
          : DateTime.parse(json['recording_start_timestamp'] as String),
      recordingEndTimestamp: json['recording_end_timestamp'] == null
          ? null
          : DateTime.parse(json['recording_end_timestamp'] as String),
      linkedFieldDeviceIds: (json['linked_field_device_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      sourceType: $enumDecodeNullable(
          _$RecordingSourceTypeEnumMap, json['source_type']),
    );

Map<String, dynamic> _$RecordingToJson(Recording instance) => <String, dynamic>{
      'project_id': instance.projectId,
      'road_event_id': instance.roadEventId,
      'name': instance.name,
      'description': instance.description,
      'types_of_work': instance.typesOfWork,
      'road_name': instance.roadName,
      'direction': _$RoadwayDirectionEnumMap[instance.direction],
      'start_date': DateTimeJsonConverter.toJsonNullable(instance.startDate),
      'end_date': DateTimeJsonConverter.toJsonNullable(instance.endDate),
      'timestamp': DateTimeJsonConverter.toJson(instance.timestamp),
      'area_type': _$WorkZoneTypeEnumMap[instance.areaType]!,
      'vehicle_impact': _$VehicleImpactEnumMap[instance.vehicleImpact],
      'surface_type': _$RoadSegmentSurfaceTypeEnumMap[instance.surfaceType],
      'points': instance.points,
      'user_id': instance.userId,
      'event_schedule': instance.eventSchedule,
      'worker_presence_schedule': instance.workerPresenceSchedule,
      'recording_start_timestamp':
          instance.recordingStartTimestamp?.toIso8601String(),
      'recording_end_timestamp':
          instance.recordingEndTimestamp?.toIso8601String(),
      'linked_field_device_ids': instance.linkedFieldDeviceIds,
      'source_type': _$RecordingSourceTypeEnumMap[instance.sourceType],
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

const _$RecordingSourceTypeEnumMap = {
  RecordingSourceType.drive: 'drive',
  RecordingSourceType.kmlUpload: 'kml-upload',
};

RecordingWithId _$RecordingWithIdFromJson(Map<String, dynamic> json) =>
    RecordingWithId(
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
      startDate: DateTimeJsonConverter.fromJsonNullable(
          (json['start_date'] as num?)?.toInt()),
      endDate: DateTimeJsonConverter.fromJsonNullable(
          (json['end_date'] as num?)?.toInt()),
      timestamp:
          DateTimeJsonConverter.fromJson((json['timestamp'] as num).toInt()),
      areaType: $enumDecode(_$WorkZoneTypeEnumMap, json['area_type']),
      vehicleImpact:
          $enumDecodeNullable(_$VehicleImpactEnumMap, json['vehicle_impact']),
      surfaceType: $enumDecodeNullable(
          _$RoadSegmentSurfaceTypeEnumMap, json['surface_type']),
      points: (json['points'] as List<dynamic>)
          .map((e) => RecordingPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      userId: json['user_id'] as String?,
      eventSchedule: json['event_schedule'] == null
          ? null
          : EventRecurrence.fromJson(
              json['event_schedule'] as Map<String, dynamic>),
      workerPresenceSchedule: json['worker_presence_schedule'] == null
          ? null
          : EventRecurrence.fromJson(
              json['worker_presence_schedule'] as Map<String, dynamic>),
      recordingStartTimestamp: json['recording_start_timestamp'] == null
          ? null
          : DateTime.parse(json['recording_start_timestamp'] as String),
      recordingEndTimestamp: json['recording_end_timestamp'] == null
          ? null
          : DateTime.parse(json['recording_end_timestamp'] as String),
      linkedFieldDeviceIds: (json['linked_field_device_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      sourceType: $enumDecodeNullable(
          _$RecordingSourceTypeEnumMap, json['source_type']),
    );

Map<String, dynamic> _$RecordingWithIdToJson(RecordingWithId instance) =>
    <String, dynamic>{
      'project_id': instance.projectId,
      'road_event_id': instance.roadEventId,
      'name': instance.name,
      'description': instance.description,
      'types_of_work': instance.typesOfWork,
      'road_name': instance.roadName,
      'direction': _$RoadwayDirectionEnumMap[instance.direction],
      'start_date': DateTimeJsonConverter.toJsonNullable(instance.startDate),
      'end_date': DateTimeJsonConverter.toJsonNullable(instance.endDate),
      'timestamp': DateTimeJsonConverter.toJson(instance.timestamp),
      'area_type': _$WorkZoneTypeEnumMap[instance.areaType]!,
      'vehicle_impact': _$VehicleImpactEnumMap[instance.vehicleImpact],
      'surface_type': _$RoadSegmentSurfaceTypeEnumMap[instance.surfaceType],
      'points': instance.points,
      'user_id': instance.userId,
      'event_schedule': instance.eventSchedule,
      'worker_presence_schedule': instance.workerPresenceSchedule,
      'recording_start_timestamp':
          instance.recordingStartTimestamp?.toIso8601String(),
      'recording_end_timestamp':
          instance.recordingEndTimestamp?.toIso8601String(),
      'linked_field_device_ids': instance.linkedFieldDeviceIds,
      'source_type': _$RecordingSourceTypeEnumMap[instance.sourceType],
      'id': instance.id,
    };

RecordingMarking _$RecordingMarkingFromJson(Map<String, dynamic> json) =>
    RecordingMarking(
      refPt: json['ref_pt'] as bool?,
      lanes: (json['lanes'] as List<dynamic>?)
          ?.map((e) => Lane.fromJson(e as Map<String, dynamic>))
          .toList(),
      workersPresent: json['workers_present'] as bool?,
      speedLimitMph: (json['speed_limit_mph'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RecordingMarkingToJson(RecordingMarking instance) =>
    <String, dynamic>{
      'ref_pt': instance.refPt,
      'lanes': instance.lanes,
      'workers_present': instance.workersPresent,
      'speed_limit_mph': instance.speedLimitMph,
    };

RecordingPoint _$RecordingPointFromJson(Map<String, dynamic> json) =>
    RecordingPoint(
      timestamp: (json['timestamp'] as num).toInt(),
      numSatellites: (json['num_satellites'] as num).toInt(),
      accuracy: (json['accuracy'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      altitude: (json['altitude'] as num).toDouble(),
      speed: (json['speed'] as num).toDouble(),
      heading: (json['heading'] as num).toDouble(),
      marking: json['marking'] == null
          ? null
          : RecordingMarking.fromJson(json['marking'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RecordingPointToJson(RecordingPoint instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'num_satellites': instance.numSatellites,
      'accuracy': instance.accuracy,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'altitude': instance.altitude,
      'speed': instance.speed,
      'heading': instance.heading,
      'marking': instance.marking,
    };
