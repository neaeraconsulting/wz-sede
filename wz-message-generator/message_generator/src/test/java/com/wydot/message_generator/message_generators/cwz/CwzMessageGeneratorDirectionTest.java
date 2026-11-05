package com.wydot.message_generator.message_generators.cwz;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.RETURNS_DEEP_STUBS;
import static org.mockito.Mockito.mock;

import java.util.List;
import java.util.Random;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.type.LatLng;
import com.wydot.message_generator.accessors.cwz.CwzRepository;
import com.wydot.message_generator.models.wz.cwz.RoadwayDirection;
import com.wydot.message_generator.sdx.SdxApiService;

class CwzMessageGeneratorDirectionTest {
    private static final double EARTH_RADIUS_M = 6_371_000.0;
    private static final double START_LAT = 41.14;
    private static final double START_LNG = -104.82;

    private CwzMessageGenerator generator;

    @BeforeEach
    void setUp() {
        generator = new CwzMessageGenerator(
                mock(SdxApiService.class),
                mock(CwzProperties.class, RETURNS_DEEP_STUBS),
                mock(CwzRepository.class),
                new ObjectMapper());
    }

    private static LatLng point(double lat, double lng) {
        return LatLng.newBuilder().setLatitude(lat).setLongitude(lng).build();
    }

    // Destination point from start along a given bearing
    private static LatLng destination(double bearingDeg, double distanceM) {
        double lat1 = Math.toRadians(START_LAT);
        double lng1 = Math.toRadians(START_LNG);
        double brng = Math.toRadians(bearingDeg);
        double d = distanceM / EARTH_RADIUS_M;
        double lat2 = Math.asin(Math.sin(lat1) * Math.cos(d) + Math.cos(lat1) * Math.sin(d) * Math.cos(brng));
        double lng2 = lng1 + Math.atan2(Math.sin(brng) * Math.sin(d) * Math.cos(lat1),
                Math.cos(d) - Math.sin(lat1) * Math.sin(lat2));
        return point(Math.toDegrees(lat2), Math.toDegrees(lng2));
    }

    private RoadwayDirection direction(double bearingDeg, List<String> roadNames) {
        return generator.getRoadwayDirectionFromGeometry(
                List.of(point(START_LAT, START_LNG), destination(bearingDeg, 2000)), roadNames);
    }

    @Test
    void nullPointsReturnsUnknown() {
        assertEquals(RoadwayDirection.UNKNOWN, generator.getRoadwayDirectionFromGeometry(null, List.of()));
    }

    @Test
    void singlePointReturnsUnknown() {
        assertEquals(RoadwayDirection.UNKNOWN,
                generator.getRoadwayDirectionFromGeometry(List.of(point(START_LAT, START_LNG)), List.of()));
    }

    @Test
    void nullRoadNamesFallsBackToHeading() {
        assertEquals(RoadwayDirection.NORTHBOUND, direction(0, null));
    }

    @ParameterizedTest
    @CsvSource({
            "0, NORTHBOUND", "20, NORTHBOUND", "44, NORTHBOUND", "46, EASTBOUND", "90, EASTBOUND",
            "134, EASTBOUND", "136, SOUTHBOUND", "180, SOUTHBOUND", "224, SOUTHBOUND",
            "226, WESTBOUND", "270, WESTBOUND", "314, WESTBOUND", "316, NORTHBOUND", "359, NORTHBOUND"
    })
    void snapsToNearestCardinalWithoutInterstate(double bearing, RoadwayDirection expected) {
        assertEquals(expected, direction(bearing, List.of("US-30")));
    }

    @ParameterizedTest
    @CsvSource({
            // ML80I / ML90I style: 0 -> east/west
            "ML80I, 10, EASTBOUND", "ML80I, 80, EASTBOUND", "ML80I, 170, EASTBOUND",
            "ML80I, 190, WESTBOUND", "ML80I, 270, WESTBOUND", "ML80I, 350, WESTBOUND",
            // ML25I style: 5 -> north/south
            "ML25I, 280, NORTHBOUND", "ML25I, 350, NORTHBOUND", "ML25I, 80, NORTHBOUND",
            "ML25I, 100, SOUTHBOUND", "ML25I, 180, SOUTHBOUND", "ML25I, 260, SOUTHBOUND",
            "ml25i, 180, SOUTHBOUND", "ML15I, 0, NORTHBOUND"
    })
    void interstateForcesAxis(String roadName, double bearing, RoadwayDirection expected) {
        assertEquals(expected, direction(bearing, List.of(roadName)));
    }

    @Test
    void interstateNameFoundAmongMultipleRoadNames() {
        // Mostly-northbound heading, but I-80 is east/west, so it resolves to eastbound
        assertEquals(RoadwayDirection.EASTBOUND, direction(10, List.of("Lincolnway", "ML80I")));
    }

    @Test
    void interstateWithOtherLastDigitFallsBackToHeading() {
        assertEquals(RoadwayDirection.NORTHBOUND, direction(10, List.of("ML22I")));
    }

    @Test
    void nonInterstateMlNameIsIgnored() {
        assertEquals(RoadwayDirection.NORTHBOUND, direction(10, List.of("ML80", "ML80IX")));
    }

    @Test
    void usesFirstAndLastPointOnly() {
        List<LatLng> points = List.of(
                point(START_LAT, START_LNG),
                destination(270, 1000),
                destination(180, 1000),
                destination(0, 3000));
        assertEquals(RoadwayDirection.NORTHBOUND, generator.getRoadwayDirectionFromGeometry(points, List.of()));
    }

    @Test
    void randomBearingsMatchExpectedCardinal() {
        Random random = new Random(42);
        for (int i = 0; i < 500; i++) {
            double bearing = random.nextDouble() * 360;
            // Skip bearings within 2 degrees of a sector boundary to avoid rounding ambiguity
            double offset = (bearing + 45) % 90;
            if (offset < 2 || offset > 88) {
                continue;
            }
            int sector = (int) (((bearing + 45) % 360) / 90);
            RoadwayDirection expected = switch (sector) {
                case 0 -> RoadwayDirection.NORTHBOUND;
                case 1 -> RoadwayDirection.EASTBOUND;
                case 2 -> RoadwayDirection.SOUTHBOUND;
                default -> RoadwayDirection.WESTBOUND;
            };
            double distance = 100 + random.nextDouble() * 50_000;
            RoadwayDirection actual = generator.getRoadwayDirectionFromGeometry(
                    List.of(point(START_LAT, START_LNG), destination(bearing, distance)), List.of());
            assertEquals(expected, actual, "bearing=" + bearing + " distance=" + distance);
        }
    }

    @Test
    void randomBearingsOnInterstatesStayOnAxis() {
        Random random = new Random(7);
        for (int i = 0; i < 500; i++) {
            double bearing = random.nextDouble() * 360;
            double distance = 100 + random.nextDouble() * 50_000;
            List<LatLng> points = List.of(point(START_LAT, START_LNG), destination(bearing, distance));

            RoadwayDirection ew = generator.getRoadwayDirectionFromGeometry(points, List.of("ML80I"));
            RoadwayDirection ns = generator.getRoadwayDirectionFromGeometry(points, List.of("ML25I"));

            assertEquals(bearing < 180 ? RoadwayDirection.EASTBOUND : RoadwayDirection.WESTBOUND, ew,
                    "ML80I bearing=" + bearing);
            assertEquals(bearing >= 90 && bearing < 270 ? RoadwayDirection.SOUTHBOUND : RoadwayDirection.NORTHBOUND,
                    ns, "ML25I bearing=" + bearing);
        }
    }
}
