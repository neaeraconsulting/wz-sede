// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_worker_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveWorkerLocation _$LiveWorkerLocationFromJson(Map<String, dynamic> json) =>
    LiveWorkerLocation(
      roadEventId: (json['road_event_id'] as num).toInt(),
      workerId: json['worker_id'] as String,
      timestamp:
          DateTimeJsonConverter.fromJson((json['timestamp'] as num).toInt()),
      isActive: json['is_active'] as bool,
      appVersion: json['app_version'] as String,
      velocityKph: (json['velocity_kph'] as num).toDouble(),
      heading: (json['heading'] as num).toDouble(),
      locationType:
          $enumDecode(_$WorkerLocationTypeEnumMap, json['location_type']),
      location: LatLngJsonConverter.fromJson(json['location'] as List),
      locationHistory:
          LatLngJsonConverter.fromJsonList(json['location_history'] as List),
    );

Map<String, dynamic> _$LiveWorkerLocationToJson(LiveWorkerLocation instance) =>
    <String, dynamic>{
      'road_event_id': instance.roadEventId,
      'worker_id': instance.workerId,
      'timestamp': DateTimeJsonConverter.toJson(instance.timestamp),
      'is_active': instance.isActive,
      'app_version': instance.appVersion,
      'location_type': _$WorkerLocationTypeEnumMap[instance.locationType]!,
      'velocity_kph': instance.velocityKph,
      'heading': instance.heading,
      'location': LatLngJsonConverter.toJson(instance.location),
      'location_history':
          LatLngJsonConverter.toJsonList(instance.locationHistory),
    };

const _$WorkerLocationTypeEnumMap = {
  WorkerLocationType.WORKER: 'worker',
  WorkerLocationType.FLAGGER: 'flagger',
  WorkerLocationType.MOBILE_OPERATOR: 'mobile-operator',
};
