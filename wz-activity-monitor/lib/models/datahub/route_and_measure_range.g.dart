// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_and_measure_range.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteAndMeasureRange _$RouteAndMeasureRangeFromJson(
        Map<String, dynamic> json) =>
    RouteAndMeasureRange(
      routeId: json['routeId'] as String,
      translatedRouteId: json['translatedRouteId'] as String,
      startMeasure: (json['startMeasure'] as num).toDouble(),
      translatedStartMeasure:
          (json['translatedStartMeasure'] as num).toDouble(),
      endMeasure: (json['endMeasure'] as num).toDouble(),
      translatedEndMeasure: (json['translatedEndMeasure'] as num).toDouble(),
    );

Map<String, dynamic> _$RouteAndMeasureRangeToJson(
        RouteAndMeasureRange instance) =>
    <String, dynamic>{
      'routeId': instance.routeId,
      'translatedRouteId': instance.translatedRouteId,
      'startMeasure': instance.startMeasure,
      'translatedStartMeasure': instance.translatedStartMeasure,
      'endMeasure': instance.endMeasure,
      'translatedEndMeasure': instance.translatedEndMeasure,
    };
