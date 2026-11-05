package com.wydot.wz_datahub.api.utilities.gis_service;

import java.util.List;

import org.geotools.api.referencing.crs.CoordinateReferenceSystem;
import org.geotools.api.referencing.operation.MathTransform;
import org.geotools.geometry.jts.JTS;
import org.geotools.referencing.CRS;
import org.geotools.referencing.GeodeticCalculator;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.LineString;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.linearref.LengthIndexedLine;

import com.google.type.LatLng;

public class GisUtils {
    public static double calculateDistanceMeters(LatLng p1, LatLng p2) {
        GeodeticCalculator calc = new GeodeticCalculator();

        // GeoTools expects x=longitude, y=latitude
        calc.setStartingGeographicPoint(p1.getLongitude(), p1.getLatitude());
        calc.setDestinationGeographicPoint(p2.getLongitude(), p2.getLatitude());

        return calc.getOrthodromicDistance();
    }

    public static double calculateLineStringDistanceMeters(List<LatLng> points) {
        double distanceMeters = 0.0;
        for (int i = 0; i < points.size() - 1; i++) {
            distanceMeters += calculateDistanceMeters(points.get(i), points.get(i + 1));
        }
        return distanceMeters;
    }

    public static Coordinate latLngToCoordinate(LatLng latLng) {
        return new Coordinate(latLng.getLongitude(), latLng.getLatitude());
    }

    /**
     * Calculates distance along a line and perpendicular distance from line.
     * 
     * @param linePoints list of LatLng representing the line
     * @param target     the point of interest
     * @return [distanceAlongMeters, distanceFromLineMeters]
     */
    public static double[] calculateLineAndOffset(List<LatLng> linePoints, LatLng target) throws Exception {
        if (linePoints == null || linePoints.size() < 2) {
            return new double[] { 0.0, 0.0 };
        }

        GeometryFactory gf = new GeometryFactory();

        // Build LineString
        Coordinate[] coords = linePoints.stream()
                .map(p -> latLngToCoordinate(p)) // JTS expects (x=lon, y=lat)
                .toArray(Coordinate[]::new);
        LineString line = gf.createLineString(coords);

        // Build Point
        Point point = gf.createPoint(latLngToCoordinate(target));

        // Reproject to a projected CRS in meters
        CoordinateReferenceSystem crsWGS84 = CRS.decode("EPSG:4326", true);
        CoordinateReferenceSystem crsMeters = CRS.decode("EPSG:3857", true); // Web Mercator
        MathTransform transform = CRS.findMathTransform(crsWGS84, crsMeters, true);

        LineString lineMeters = (LineString) JTS.transform(line, transform);
        Point pointMeters = (Point) JTS.transform(point, transform);

        // Use LengthIndexedLine to measure distances
        LengthIndexedLine indexed = new LengthIndexedLine(lineMeters);
        double index = indexed.project(pointMeters.getCoordinate());

        double distanceAlong = index; // meters from start of line
        Coordinate closest = indexed.extractPoint(index);
        double distanceFrom = pointMeters.getCoordinate().distance(closest); // meters offset

        return new double[] { distanceAlong, distanceFrom };
    }

    public static double calculateHeadingBetweenLatLngs(LatLng from, LatLng to) {
        GeodeticCalculator calc = new GeodeticCalculator();

        // GeoTools expects x=longitude, y=latitude
        calc.setStartingGeographicPoint(from.getLongitude(), from.getLatitude());
        calc.setDestinationGeographicPoint(to.getLongitude(), to.getLatitude());

        return calc.getAzimuth();
    }
}
