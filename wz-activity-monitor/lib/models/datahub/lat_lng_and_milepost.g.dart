// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lat_lng_and_milepost.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LatLngAndMilepost _$LatLngAndMilepostFromJson(Map<String, dynamic> json) =>
    LatLngAndMilepost(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      milepost: (json['milepost'] as num).toDouble(),
    );

Map<String, dynamic> _$LatLngAndMilepostToJson(LatLngAndMilepost instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'milepost': instance.milepost,
    };
