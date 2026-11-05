// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_and_measure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteAndMeasure _$RouteAndMeasureFromJson(Map<String, dynamic> json) =>
    RouteAndMeasure(
      routeId: json['routeId'] as String,
      translatedRouteId: json['translatedRouteId'] as String,
      measure: (json['measure'] as num).toDouble(),
      translatedMeasure: (json['translatedMeasure'] as num).toDouble(),
    );

Map<String, dynamic> _$RouteAndMeasureToJson(RouteAndMeasure instance) =>
    <String, dynamic>{
      'routeId': instance.routeId,
      'translatedRouteId': instance.translatedRouteId,
      'measure': instance.measure,
      'translatedMeasure': instance.translatedMeasure,
    };
