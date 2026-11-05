package com.wydot.wz_datahub.api.utilities.gis_service;

import java.util.List;

import org.springframework.stereotype.Component;

import com.google.type.LatLng;
import com.wydot.wz_datahub.api.models.gis_service.LatLngAndMilepost;
import com.wydot.wz_datahub.api.models.gis_service.RouteAndMeasure;
import com.wydot.wz_datahub.api.models.gis_service.RouteAndMeasureRange;
import com.wydot.wz_datahub.api.models.gis_service.State;
import com.wydot.wz_datahub.api.utilities.gis_service.colorado.GisServiceColorado;
import com.wydot.wz_datahub.api.utilities.Units;

import lombok.RequiredArgsConstructor;
import reactor.core.publisher.Mono;
import wyo.dot.protobuf.FieldDevice;

@Component
@RequiredArgsConstructor
public class GisService {
    private final GisServiceWyoming gisServiceWyoming;
    private final GisServiceColorado gisServiceColorado;

    public Mono<RouteAndMeasure> getClosestRouteAndMeasureForDevice(FieldDevice device) {
        LatLng point = device.getGeometry().getCoordinates();
        State state = State.fromLatLng(point);
        return switch (state) {
            case State.WYOMING -> gisServiceWyoming.getClosestRouteAndMeasureForDevice(device);
            case State.COLORADO -> gisServiceColorado.getClosestRouteAndMeasureForDevice(device);
            default -> Mono.empty();
        };
    }

    public Mono<RouteAndMeasure> getClosestRouteAndMeasure(LatLng point, int tolerance) {
        State state = State.fromLatLng(point);
        return switch (state) {
            case State.WYOMING -> gisServiceWyoming.getClosestRouteAndMeasure(point, tolerance);
            case State.COLORADO -> gisServiceColorado.getClosestRouteAndMeasure(point, tolerance);
            default -> Mono.empty();
        };
    }

    public Mono<RouteAndMeasure> getExpectedRouteAndMeasure(LatLng point, int tolerance,
            String expectedRouteId) {
        State state = State.fromLatLng(point);
        return switch (state) {
            case State.WYOMING -> gisServiceWyoming.getExpectedRouteAndMeasure(point, tolerance, expectedRouteId);
            case State.COLORADO -> gisServiceColorado.getExpectedRouteAndMeasure(point, tolerance, expectedRouteId);
            default -> Mono.empty();
        };
    }

    public Mono<RouteAndMeasureRange> getMatchingRouteAndMeasure(LatLng point1, LatLng point2, int tolerance) {
        State state = State.fromLatLng(point1);
        return switch (state) {
            case State.WYOMING -> gisServiceWyoming.getMatchingRouteAndMeasure(point1, point2, tolerance);
            case State.COLORADO -> gisServiceColorado.getMatchingRouteAndMeasure(point1, point2, tolerance);
            default -> Mono.empty();
        };
    }

    public Mono<RouteAndMeasure> translateMeasure(RouteAndMeasure route) {
        State state = State.fromRouteId(route.getRouteId());
        return switch (state) {
            case State.WYOMING -> gisServiceWyoming.translateMeasure(route);
            case State.COLORADO -> gisServiceColorado.translateMeasure(route);
            default -> Mono.empty();
        };
    }

    public Mono<List<LatLng>> getRouteGeometry(RouteAndMeasureRange range) {
        State state = State.fromRouteId(range.getRouteId());
        return switch (state) {
            case State.WYOMING -> gisServiceWyoming.getRouteGeometry(range);
            case State.COLORADO -> gisServiceColorado.getRouteGeometry(range);
            default -> Mono.empty();
        };
    }

    public Mono<List<LatLngAndMilepost>> getRouteGeometryWithMeasures(RouteAndMeasureRange range) {
        State state = State.fromRouteId(range.getRouteId());
        return switch (state) {
            case State.WYOMING -> gisServiceWyoming.getRouteGeometryWithMeasures(range);
            case State.COLORADO -> gisServiceColorado.getRouteGeometryWithMeasures(range);
            default -> Mono.empty();
        };
    }

    public Mono<LatLng> getGeometryForMeasure(RouteAndMeasure measure) {
        State state = State.fromRouteId(measure.getRouteId());
        return switch (state) {
            case State.WYOMING -> gisServiceWyoming.getGeometryAtMeasure(measure);
            case State.COLORADO -> gisServiceColorado.getGeometryAtMeasure(measure);
            default -> Mono.empty();
        };
    }

    public Mono<String> getRoadName(RouteAndMeasureRange range) {
        State state = State.fromRouteId(range.getRouteId());
        return switch (state) {
            case State.WYOMING -> gisServiceWyoming.getRoadName(range);
            case State.COLORADO -> Mono.just(range.getRouteId());
            default -> Mono.empty();
        };
    }

    public Mono<String> getRoadName(RouteAndMeasure measure) {
        State state = State.fromRouteId(measure.getRouteId());
        return switch (state) {
            case State.WYOMING -> gisServiceWyoming.getRoadName(measure);
            case State.COLORADO -> Mono.just(measure.getRouteId());
            default -> Mono.empty();
        };
    }

    public Mono<RouteAndMeasureRange> addMeasureBounds(RouteAndMeasure point, double heading,
            double distanceMeters) {
        Double upstreamMeasure = point.getMeasure();
        if (RouteAndMeasure.isRouteIdDec(point.getRouteId())) {
            upstreamMeasure -= Units.convertMetersToMiles(distanceMeters);
        } else {
            upstreamMeasure += Units.convertMetersToMiles(distanceMeters);
        }
        return translateMeasure(new RouteAndMeasure(point.getRouteId(), point.getTranslatedRouteId(),
                upstreamMeasure, null)).flatMap(translatedUpstreamMeasure -> {
                    RouteAndMeasureRange range = RouteAndMeasureRange.fromMeasures(point, translatedUpstreamMeasure);
                    return getRoadHeading(range).map((Double routeHeading) -> {
                        if (isWithinHeadingRange(routeHeading, heading, 180.0)) {
                            return point.addRange(distanceMeters, range.isRouteDec());
                        } else {
                            return point.addRange(distanceMeters, !range.isRouteDec());
                        }
                    });
                });
    }

    public Mono<Double> getRoadHeading(RouteAndMeasureRange pointRange) {
        return getGeometryForMeasure(pointRange.getStartRouteAndMeasure())
                .flatMap(startLatLng -> getGeometryForMeasure(pointRange.getEndRouteAndMeasure())
                        .map(endLatLng -> GisUtils.calculateHeadingBetweenLatLngs(startLatLng, endLatLng)));
    }

    public Boolean isWithinHeadingRange(double roadHeading, double observationHeading, double headingTolerance) {
        double lowerBound = (roadHeading - headingTolerance / 2 + 360) % 360;
        double upperBound = (roadHeading + headingTolerance / 2 + 360) % 360;

        boolean distanceMeters;
        if (lowerBound > upperBound) {
            distanceMeters = (observationHeading >= lowerBound && observationHeading < 360)
                    || (observationHeading >= 0 && observationHeading <= upperBound);
        } else {
            distanceMeters = observationHeading >= lowerBound && observationHeading <= upperBound;
        }
        return distanceMeters;
    }
}
