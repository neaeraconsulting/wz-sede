// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_vehicle_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MobileVehicleLocation _$MobileVehicleLocationFromJson(
        Map<String, dynamic> json) =>
    MobileVehicleLocation(
      roadEventId: (json['road_event_id'] as num?)?.toInt(),
      workerId: json['worker_id'] as String,
      timestamp:
          DateTimeJsonConverter.fromJson((json['timestamp'] as num).toInt()),
      isActive: json['is_active'] as bool,
      appVersion: json['app_version'] as String,
      licensePlate: json['license_plate'] as String,
      velocityKph: (json['velocity_kph'] as num).toDouble(),
      heading: (json['heading'] as num).toDouble(),
      operationType: $enumDecode(
          _$MobileVehicleOperationTypeEnumMap, json['operation_type']),
      location: LatLngJsonConverter.fromJson(json['location'] as List),
      locationHistory:
          LatLngJsonConverter.fromJsonList(json['location_history'] as List),
    );

Map<String, dynamic> _$MobileVehicleLocationToJson(
        MobileVehicleLocation instance) =>
    <String, dynamic>{
      'road_event_id': instance.roadEventId,
      'worker_id': instance.workerId,
      'timestamp': DateTimeJsonConverter.toJson(instance.timestamp),
      'is_active': instance.isActive,
      'app_version': instance.appVersion,
      'license_plate': instance.licensePlate,
      'operation_type':
          _$MobileVehicleOperationTypeEnumMap[instance.operationType]!,
      'velocity_kph': instance.velocityKph,
      'heading': instance.heading,
      'location': LatLngJsonConverter.toJson(instance.location),
      'location_history':
          LatLngJsonConverter.toJsonList(instance.locationHistory),
    };

const _$MobileVehicleOperationTypeEnumMap = {
  MobileVehicleOperationType.STRIPING: 'striping',
  MobileVehicleOperationType.PLOWING: 'plowing',
  MobileVehicleOperationType.MOWING: 'mowing',
  MobileVehicleOperationType.GENERAL_ACTIVE: 'general-active',
  MobileVehicleOperationType.GENERAL_INACTIVE: 'general-inactive',
};
