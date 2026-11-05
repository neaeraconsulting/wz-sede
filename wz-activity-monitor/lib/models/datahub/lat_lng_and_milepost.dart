import 'package:json_annotation/json_annotation.dart';

part 'lat_lng_and_milepost.g.dart';

@JsonSerializable()
class LatLngAndMilepost {
  @JsonKey(name: 'latitude')
  final double latitude;
  @JsonKey(name: 'longitude')
  final double longitude;
  @JsonKey(name: 'milepost')
  final double milepost;

  LatLngAndMilepost({
    required this.latitude,
    required this.longitude,
    required this.milepost,
  });

  factory LatLngAndMilepost.fromJson(Map<String, dynamic> json) =>
      _$LatLngAndMilepostFromJson(json);
  Map<String, dynamic> toJson() => _$LatLngAndMilepostToJson(this);
}
