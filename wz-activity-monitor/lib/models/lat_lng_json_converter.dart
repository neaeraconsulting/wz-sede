import 'package:latlong2/latlong.dart';

class LatLngJsonConverter {
  static LatLng fromJson(List<dynamic> json) {
    return LatLng(json[1] as double, json[0] as double);
  }

  static List<dynamic> toJson(LatLng latLng) {
    return [latLng.longitude, latLng.latitude];
  }

  static List<LatLng> fromJsonList(List<dynamic> json) {
    return json.map((list) => fromJson(list as List)).toList();
  }

  static List<dynamic> toJsonList(List<LatLng> geometry) {
    return geometry.map(toJson).toList();
  }

  static List<LatLng>? fromJsonListNullable(List<dynamic>? json) {
    return json?.map((list) => fromJson(list as List)).toList();
  }

  static List<dynamic>? toJsonListNullable(List<LatLng>? geometry) {
    return geometry?.map(toJson).toList();
  }
}
