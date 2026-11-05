import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

extension PositionExtensions on Position {
  LatLng getLatLng() {
    return LatLng(latitude, longitude);
  }
}
