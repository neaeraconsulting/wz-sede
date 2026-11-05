import 'package:json_annotation/json_annotation.dart';

part 'route_and_measure_range.g.dart';

@JsonSerializable()
class RouteAndMeasureRange {
  @JsonKey(name: 'routeId')
  final String routeId;
  @JsonKey(name: 'translatedRouteId')
  final String translatedRouteId;
  @JsonKey(name: 'startMeasure')
  final double startMeasure;
  @JsonKey(name: 'translatedStartMeasure')
  final double translatedStartMeasure;
  @JsonKey(name: 'endMeasure')
  final double endMeasure;
  @JsonKey(name: 'translatedEndMeasure')
  final double translatedEndMeasure;

  RouteAndMeasureRange({
    required this.routeId,
    required this.translatedRouteId,
    required this.startMeasure,
    required this.translatedStartMeasure,
    required this.endMeasure,
    required this.translatedEndMeasure,
  });

  factory RouteAndMeasureRange.fromJson(Map<String, dynamic> json) =>
      _$RouteAndMeasureRangeFromJson(json);
  Map<String, dynamic> toJson() => _$RouteAndMeasureRangeToJson(this);
}
