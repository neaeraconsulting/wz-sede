package com.wydot.wz_datahub.api.models.gis_service;

import com.wydot.wz_datahub.api.utilities.Units;
import com.wydot.wz_datahub.api.utilities.gis_service.GisService;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;
import wyo.dot.protobuf.RoadSubEvent;

@Slf4j
@AllArgsConstructor
@NoArgsConstructor
@Data
public class RouteAndMeasureRange {
    private String routeId;
    private String translatedRouteId;
    private Double startMeasure;
    private Double translatedStartMeasure;
    private Double endMeasure;
    private Double translatedEndMeasure;

    public static RouteAndMeasureRange fromMeasures(RouteAndMeasure r1,
            RouteAndMeasure r2) {
        if (r1 == null || r2 == null || !r1.getRouteId().equals(r2.getRouteId())) {
            return null;
        }
        return new RouteAndMeasureRange(r1.getRouteId(), r1.getTranslatedRouteId(), r1.getMeasure(),
                r1.getTranslatedMeasure(),
                r2.getMeasure(),
                r2.getTranslatedMeasure());
    }

    public static boolean isRouteIdDec(String routeId) {
        return RouteAndMeasure.isRouteIdDec(routeId);
    }

    public boolean isRouteDec() {
        // TODO: Find bug in descending report in archer reading Route ID D, but
        // direction negative. Suspect region was drawn backwards
        if (startMeasure != null && endMeasure != null) {
            return startMeasure > endMeasure;
        } else {
            return RouteAndMeasure.isRouteIdDec(routeId);
        }
    }

    public RouteAndMeasure getStartRouteAndMeasure() {
        return new RouteAndMeasure(routeId, translatedRouteId, startMeasure, translatedStartMeasure);
    }

    public RouteAndMeasure getEndRouteAndMeasure() {
        return new RouteAndMeasure(routeId, translatedRouteId, endMeasure, translatedEndMeasure);
    }

    public double getLengthMeters() {
        return Units.convertMilesToMeters(Math.abs(translatedEndMeasure - translatedStartMeasure));
    }

    private boolean isPointWithinRange(double point, double start, double end, double threshold) {
        double totalLength = Math.abs(end - start);
        double sumDistances = Math.abs(point - start) + Math.abs(point - end);
        return sumDistances <= (totalLength + threshold);
    }

    public boolean checkOtherPartiallyWithin(RouteAndMeasureRange other) {
        if (other == null || !this.routeId.equals(other.routeId)) {
            return false;
        }
        double thresholdMiles = 0.01;
        boolean firstWithin = isPointWithinRange(other.startMeasure, this.startMeasure, this.endMeasure,
                thresholdMiles);
        boolean secondWithin = isPointWithinRange(other.endMeasure, this.startMeasure, this.endMeasure, thresholdMiles);
        return firstWithin || secondWithin;
    }

    public boolean checkOtherWithinTolerance(RouteAndMeasureRange other, double toleranceMiles) {
        if (other == null || !this.routeId.equals(other.routeId)) {
            return false;
        }
        boolean firstWithin = other.startMeasure >= this.startMeasure - toleranceMiles
                && other.startMeasure <= this.endMeasure + toleranceMiles;
        boolean secondWithin = other.endMeasure >= this.startMeasure - toleranceMiles
                && other.endMeasure <= this.endMeasure + toleranceMiles;
        return firstWithin && secondWithin;
    }

    public RouteAndMeasureRange expandToInclude(RouteAndMeasureRange other) {
        if (other == null || !this.routeId.equals(other.routeId)) {
            return this;
        }
        double newStart = Math.min(this.startMeasure, other.startMeasure);
        double newTranslatedStart = Math.min(this.translatedStartMeasure, other.translatedStartMeasure);
        double newEnd = Math.max(this.endMeasure, other.endMeasure);
        double newTranslatedEnd = Math.max(this.translatedEndMeasure, other.translatedEndMeasure);
        return new RouteAndMeasureRange(this.routeId, this.translatedRouteId, newStart, newTranslatedStart, newEnd,
                newTranslatedEnd);
    }

    public static Mono<RouteAndMeasureRange> fromRoadSubEvent(GisService gisService,
            RoadSubEvent.Builder roadSubEvent) {
        return switch (roadSubEvent.getGeometryCase()) {
            case POINT -> gisService
                    .getClosestRouteAndMeasure(roadSubEvent.getPoint().getCoordinates(), 100)
                    .map((rm) -> fromMeasures(rm, rm));
            case LINE_STRING -> Mono.zip(
                    gisService.getClosestRouteAndMeasure(
                            roadSubEvent.getLineString().getCoordinates().getCoordinatesList().getFirst(), 100),
                    gisService.getClosestRouteAndMeasure(
                            roadSubEvent.getLineString().getCoordinates().getCoordinatesList().getLast(), 100))
                    .map(tuple -> fromMeasures(tuple.getT1(), tuple.getT2()));
            case POLYGON -> Mono.empty();
            default -> {
                log.warn("No measures generated for RoadSubEvent with ID {}", roadSubEvent.getId());
                yield Mono.empty();
            }
        };
    }

    public static Mono<RouteAndMeasureRange> fromRoadSubEventExpected(GisService gisService,
            RoadSubEvent.Builder roadSubEvent, String expectedRouteId) {
        return switch (roadSubEvent.getGeometryCase()) {
            case POINT -> gisService
                    .getExpectedRouteAndMeasure(roadSubEvent.getPoint().getCoordinates(), 100, expectedRouteId)
                    .map((rm) -> fromMeasures(rm, rm));
            case LINE_STRING -> Mono.zip(
                    gisService.getExpectedRouteAndMeasure(
                            roadSubEvent.getLineString().getCoordinates().getCoordinatesList().getFirst(), 100,
                            expectedRouteId),
                    gisService.getExpectedRouteAndMeasure(
                            roadSubEvent.getLineString().getCoordinates().getCoordinatesList().getLast(), 100,
                            expectedRouteId))
                    .map(tuple -> fromMeasures(tuple.getT1(), tuple.getT2()));
            case POLYGON -> Mono.empty();
            default -> {
                log.warn("No measures generated for RoadSubEvent with ID {}", roadSubEvent.getId());
                yield Mono.empty();
            }
        };
    }

    public String toString() {
        return "RouteAndMeasureRange{" +
                "routeId='" + routeId + '\'' +
                ", translatedRouteId='" + translatedRouteId + '\'' +
                ", startMeasure=" + startMeasure +
                ", translatedStartMeasure=" + translatedStartMeasure +
                ", endMeasure=" + endMeasure +
                ", translatedEndMeasure=" + translatedEndMeasure +
                '}';
    }
}
