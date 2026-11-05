package com.wydot.wz_datahub.api.models.wrappers;

import java.util.List;

import com.google.type.LatLng;
import com.wydot.wz_datahub.api.models.gis_service.RouteAndMeasureRange;
import com.wydot.wz_datahub.api.models.update_processing.Observation;
import com.wydot.wz_datahub.api.utilities.gis_service.GisService;

import kotlin.Pair;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import reactor.core.publisher.Mono;
import wyo.dot.protobuf.RoadSubEvent;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class RoadSubEventWrapper {
    private RoadSubEvent roadSubEvent;
    private List<Observation<?>> observations;
    private RouteAndMeasureRange routeAndMeasureRange;

    public RoadSubEventWrapper(RoadSubEvent roadSubEvent, List<Observation<?>> observations, GisService gisService) {
        this.roadSubEvent = roadSubEvent;
        this.observations = observations;
        RouteAndMeasureRange routeAndMeasureRange = getRouteMeasureAndRange(gisService, roadSubEvent).block();
        if (routeAndMeasureRange == null) {
            this.routeAndMeasureRange = null;
            return;
        }
        this.routeAndMeasureRange = routeAndMeasureRange;
    }

    private Mono<RouteAndMeasureRange> getRouteMeasureAndRange(GisService gisService, RoadSubEvent roadSubEvent) {
        return RouteAndMeasureRange.fromRoadSubEvent(gisService, roadSubEvent.toBuilder());
    }

    public Pair<LatLng, LatLng> getStartAndEndPositions() {
        switch (this.roadSubEvent.getGeometryCase()) {
            case POINT:
                return new Pair<>(this.roadSubEvent.getPoint().getCoordinates(),
                        this.roadSubEvent.getPoint().getCoordinates());
            case LINE_STRING:
                if (this.roadSubEvent.getLineString().getCoordinates().getCoordinatesCount() > 0) {
                    LatLng startPosition = this.roadSubEvent.getLineString().getCoordinates().getCoordinates(0);
                    LatLng endPosition = this.roadSubEvent.getLineString().getCoordinates()
                            .getCoordinates(
                                    this.roadSubEvent.getLineString().getCoordinates().getCoordinatesCount() - 1);
                    return new Pair<>(startPosition, endPosition);
                }
                return null;
            case POLYGON:
                return null;
            default:
                return null;
        }
    }
}
