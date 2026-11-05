import 'dart:math';
import 'package:latlong2/latlong.dart' as map;
import 'package:wzam/models/generated/google/type/latlng.pb.dart' as pb;

class GeometryService {
  static List<map.LatLng> getSideLineCoordinates(List<pb.LatLng> coordinates, [bool offsetNegative = true]) {
    int maxNumOffsetPoints = 8;
    int originalCoordinateLength = coordinates.length;
    if (coordinates.length > maxNumOffsetPoints) {
      List<pb.LatLng> newCoordinates = [];
      newCoordinates.add(coordinates.first);
      int numMidPoints = maxNumOffsetPoints - 2;
      int remainingPoints = coordinates.length - 2;
      int factor = (remainingPoints / (numMidPoints + 1)).ceil();
      for (int i = factor; i < coordinates.length - 2; i += factor) {
        newCoordinates.add(coordinates[i]);
      }
      newCoordinates.add(coordinates.last);
      coordinates = newCoordinates;
    }
    List<map.LatLng> sidePoints = [];
    double offset = (originalCoordinateLength.toDouble()) * 0.00008;
    for (int i = 0; i < coordinates.length - 1; i++) {
      pb.LatLng start = coordinates[i];
      pb.LatLng end = coordinates[i + 1];
      double dx = end.longitude - start.longitude;
      double dy = end.latitude - start.latitude;
      double length = sqrt(dx * dx + dy * dy); // Offset distance based on length
      double offsetX = -dy / length * offset; // Adjust the offset distance as needed
      double offsetY = dx / length * offset;
      if (offsetNegative) {
        offsetX = -offsetX;
        offsetY = -offsetY;
      }
      if (i == 0) {
        sidePoints.add(map.LatLng(start.latitude, start.longitude));
        sidePoints.add(map.LatLng(start.latitude + offsetY, start.longitude + offsetX));
        sidePoints.add(map.LatLng(end.latitude + offsetY, end.longitude + offsetX));
        if (originalCoordinateLength == 2) {
          sidePoints.add(map.LatLng(end.latitude, end.longitude));
        }
        continue;
      }
      if (i == coordinates.length - 2) {
        sidePoints.add(map.LatLng(end.latitude + offsetY, end.longitude + offsetX));
        sidePoints.add(map.LatLng(end.latitude, end.longitude));
        continue;
      }
      sidePoints.add(map.LatLng(end.latitude + offsetY, end.longitude + offsetX));
    }
    if (checkIfGoingIntoItself(sidePoints)) {
      sidePoints = getSideLineCoordinates(coordinates, false);
    }
    sidePoints = fixLoopingPoints(sidePoints);
    return sidePoints;
  }

  static bool checkIfGoingIntoItself(List<map.LatLng> points) {
    // check to see if the line created by point 1 and point 2 crosses the line created by point last and point last -1
    if (points.length > 4) {
      map.LatLng p1 = points[0];
      map.LatLng p2 = points[1];
      map.LatLng p3 = points[points.length - 2];
      map.LatLng p4 = points[points.length - 1];
      if (doLineSegmentsIntersect(p1, p2, p3, p4)) {
        return true;
      }
    }
    return false;
  }

  static bool doLineSegmentsIntersect(map.LatLng p1, map.LatLng p2, map.LatLng p3, map.LatLng p4) {
    double d1 = orientation(p3, p4, p1);
    double d2 = orientation(p3, p4, p2);
    double d3 = orientation(p1, p2, p3);
    double d4 = orientation(p1, p2, p4);
    
    // General case: segments intersect if they have different orientations
    if (((d1 > 0 && d2 < 0) || (d1 < 0 && d2 > 0)) &&
        ((d3 > 0 && d4 < 0) || (d3 < 0 && d4 > 0))) {
      return true;
    }
    
    // Special cases: check if points are collinear and overlapping
    if (d1 == 0 && isPointOnSegment(p3, p1, p4)) return true;
    if (d2 == 0 && isPointOnSegment(p3, p2, p4)) return true;
    if (d3 == 0 && isPointOnSegment(p1, p3, p2)) return true;
    if (d4 == 0 && isPointOnSegment(p1, p4, p2)) return true;
    
    return false;
  }

  // Calculate orientation of three points (clockwise, counterclockwise, or collinear)
  static double orientation(map.LatLng p, map.LatLng q, map.LatLng r) {
    return (q.latitude - p.latitude) * (r.longitude - q.longitude) - 
          (q.longitude - p.longitude) * (r.latitude - q.latitude);
  }

  // Check if point q lies on line segment pr (assuming they're collinear)
  static bool isPointOnSegment(map.LatLng p, map.LatLng q, map.LatLng r) {
    return q.longitude <= max(p.longitude, r.longitude) &&
          q.longitude >= min(p.longitude, r.longitude) &&
          q.latitude <= max(p.latitude, r.latitude) &&
          q.latitude >= min(p.latitude, r.latitude);
  }

  static List<map.LatLng> fixLoopingPoints(List<map.LatLng> points) {
    if (points.length < 4) {
      return points;
    }

    bool foundIntersection = true;
    
    while (foundIntersection) {
      foundIntersection = false;
      
      for (int i = 0; i < points.length - 1 && !foundIntersection; i++) {
        for (int j = i + 2; j < points.length - 1; j++) {
          map.LatLng p1 = points[i];
          map.LatLng p2 = points[i + 1];
          map.LatLng p3 = points[j];
          map.LatLng p4 = points[j + 1];
          
          if (doLineSegmentsIntersect(p1, p2, p3, p4)) {
            // Remove all points between the intersecting segments to eliminate the loop
            List<map.LatLng> newPoints = [];
            newPoints.addAll(points.sublist(0, i + 1)); 
            newPoints.addAll(points.sublist(j + 1)); 
            
            points = newPoints;
            foundIntersection = true;
            break; 
          }
        }
      }
    }    
    return points;
  }
}