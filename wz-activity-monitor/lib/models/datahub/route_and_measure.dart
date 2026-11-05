import 'package:json_annotation/json_annotation.dart';

part 'route_and_measure.g.dart';

@JsonSerializable()
class RouteAndMeasure {
  @JsonKey(name: 'routeId')
  final String routeId;
  @JsonKey(name: 'translatedRouteId')
  final String translatedRouteId;
  @JsonKey(name: 'measure')
  final double measure;
  @JsonKey(name: 'translatedMeasure')
  final double translatedMeasure;

  RouteAndMeasure({
    required this.routeId,
    required this.translatedRouteId,
    required this.measure,
    required this.translatedMeasure,
  });

  factory RouteAndMeasure.fromJson(Map<String, dynamic> json) =>
      _$RouteAndMeasureFromJson(json);
  Map<String, dynamic> toJson() => _$RouteAndMeasureToJson(this);
}
