// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_patch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportPatch _$ReportPatchFromJson(Map<String, dynamic> json) => ReportPatch(
      id: (json['id'] as num).toInt(),
      roadEventId: (json['road_event_id'] as num).toInt(),
      timestamp:
          DateTimeJsonConverter.fromJson((json['timestamp'] as num).toInt()),
      userId: json['user_id'] as String,
      name: json['name'] as String?,
      description: json['description'] as String?,
      typesOfWork: (json['types_of_work'] as List<dynamic>?)
          ?.map((e) => TypeOfWork.fromJson(e as Map<String, dynamic>))
          .toList(),
      roadName: json['road_name'] as String?,
      direction:
          $enumDecodeNullable(_$RoadwayDirectionEnumMap, json['direction']),
      startDate: DateTimeJsonConverter.fromJsonNullable(
          (json['start_date'] as num?)?.toInt()),
      endDate: DateTimeJsonConverter.fromJsonNullable(
          (json['end_date'] as num?)?.toInt()),
      geometryType:
          $enumDecodeNullable(_$GeometryTypeEnumMap, json['geometry_type']),
      geometry:
          LatLngJsonConverter.fromJsonListNullable(json['geometry'] as List?),
      licensePlate: json['license_plate'] as String?,
      eventSchedule: json['event_schedule'] == null
          ? null
          : EventRecurrence.fromJson(
              json['event_schedule'] as Map<String, dynamic>),
      linkedFieldDeviceIds: (json['linked_field_device_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ReportPatchToJson(ReportPatch instance) =>
    <String, dynamic>{
      'id': instance.id,
      'road_event_id': instance.roadEventId,
      'timestamp': DateTimeJsonConverter.toJson(instance.timestamp),
      'user_id': instance.userId,
      'name': instance.name,
      'description': instance.description,
      'types_of_work': instance.typesOfWork,
      'road_name': instance.roadName,
      'direction': _$RoadwayDirectionEnumMap[instance.direction],
      'start_date': DateTimeJsonConverter.toJsonNullable(instance.startDate),
      'end_date': DateTimeJsonConverter.toJsonNullable(instance.endDate),
      'geometry_type': _$GeometryTypeEnumMap[instance.geometryType],
      'geometry': LatLngJsonConverter.toJsonListNullable(instance.geometry),
      'license_plate': instance.licensePlate,
      'event_schedule': instance.eventSchedule,
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

const _$GeometryTypeEnumMap = {
  GeometryType.multipoint: 'multipoint',
  GeometryType.linestring: 'linestring',
  GeometryType.polygon: 'polygon',
};
