package com.wydot.wz_datahub.api.models.wrappers;

import java.time.Instant;
import java.util.List;
import java.util.stream.Stream;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.google.type.LatLng;
import com.wydot.wz_datahub.api.ProtobufUtils;
import com.wydot.wz_datahub.api.models.gis_service.RouteAndMeasureRange;
import com.wydot.wz_datahub.api.models.serialization.instant.InstantFromMillisDeserializer;
import com.wydot.wz_datahub.api.models.serialization.instant.InstantToMillisSerializer;
import com.wydot.wz_datahub.api.models.update_processing.Observation;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventUpdateStatus.EventStatus;

import kotlin.Pair;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import wyo.dot.protobuf.RoadEvent;
import wyo.dot.protobuf.RoadSubEvent;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class RoadEventWrapper {
    // TODO: Add surfaceType, reducedSpeedLimit, and vehicleImpact
    private RoadEvent roadEvent;
    private List<RoadSubEventWrapper> roadSubEvents;
    private List<Observation<?>> observations;
    private RouteAndMeasureRange routeAndMeasureRange;
    @JsonSerialize(using = InstantToMillisSerializer.class)
    @JsonDeserialize(using = InstantFromMillisDeserializer.class)
    private Instant lastUpdated;
    private Integer numLanes;
    private List<RoadEventUpdateStatus> updateHistory;

    public RoadEventWrapper(RoadEvent roadEvent, List<RoadSubEventWrapper> roadSubEvents,
            List<Observation<?>> observations, Instant lastUpdated, Integer numLanes,
            List<RoadEventUpdateStatus> updateHistory) {
        this.roadEvent = roadEvent;
        this.roadSubEvents = roadSubEvents;
        this.observations = observations;
        this.lastUpdated = lastUpdated;
        this.numLanes = numLanes;
        this.updateHistory = updateHistory;

        RoadSubEventWrapper firstSubEvent = roadSubEvents.stream().findFirst().orElse(null);
        if (firstSubEvent != null) {
            this.routeAndMeasureRange = firstSubEvent.getRouteAndMeasureRange();
        } else {
            this.routeAndMeasureRange = null;
        }

        RoadSubEventWrapper lastSubEvent = roadSubEvents.stream().reduce((first, second) -> second)
                .orElse(null);
        if (lastSubEvent != null) {
            this.routeAndMeasureRange = lastSubEvent.getRouteAndMeasureRange();
        } else {
            this.routeAndMeasureRange = null;
        }

        if (numLanes == null) {
            roadSubEvents.stream()
                    .filter((v) -> v.getRoadSubEvent().getLayerCase() == RoadSubEvent.LayerCase.BASE_LAYER)
                    .findFirst().ifPresent((v) -> {
                        if (v.getRoadSubEvent().getBaseLayer().getLanesCount() > 0) {
                            this.numLanes = v.getRoadSubEvent().getBaseLayer().getLanesCount();
                        }
                    });
        }
    }

    public RoadEventWrapper updatePropertiesFrom(RoadEventWrapper latest, RoadEventUpdateStatus updateStatus) {
        RoadEventWrapper updated = new RoadEventWrapper();

        // Merge road events
        RoadEvent.Builder mergedRoadEventBuilder = latest.roadEvent.toBuilder();
        if (this.roadEvent != null) {
            // Preserve certain fields from the existing road event
            mergedRoadEventBuilder.setId(this.roadEvent.getId());
            if (this.roadEvent.hasProjectId() && !latest.roadEvent.hasProjectId()) {
                mergedRoadEventBuilder.setProjectId(this.roadEvent.getProjectId());
            }
            if (this.numLanes != null) {
                updated.setNumLanes(this.numLanes);
            } else {
                updated.setNumLanes(latest.getNumLanes());
            }
        }
        updated.setRoadEvent(mergedRoadEventBuilder.build());
        updated.setRoadSubEvents(latest.getRoadSubEvents());
        updated.setObservations(latest.getObservations());
        updated.setRouteAndMeasureRange(latest.getRouteAndMeasureRange());
        updated.setLastUpdated(latest.getLastUpdated());
        updated.setUpdateHistory(Stream.concat(latest.getUpdateHistory().stream(), Stream.of(updateStatus)).toList());
        return updated;
    }

    public Pair<LatLng, LatLng> getStartAndEndPositions() {
        switch (this.roadEvent.getGeometryCase()) {
            case POINT:
                return new Pair<>(this.roadEvent.getPoint().getCoordinates(),
                        this.roadEvent.getPoint().getCoordinates());
            case LINE_STRING:
                if (this.roadEvent.getLineString().getCoordinates().getCoordinatesCount() > 0) {
                    LatLng startPosition = this.roadEvent.getLineString().getCoordinates().getCoordinates(0);
                    LatLng endPosition = this.roadEvent.getLineString().getCoordinates()
                            .getCoordinates(this.roadEvent.getLineString().getCoordinates().getCoordinatesCount() - 1);
                    return new Pair<>(startPosition, endPosition);
                }
                return null;
            case POLYGON:
                return null;
            default:
                return null;
        }
    }

    public List<RoadSubEvent> getUnwrappedRoadSubEvents() {
        return roadSubEvents.stream().map((v) -> v.getRoadSubEvent()).toList();
    }

    public EventStatus getStatus() {
        if (roadSubEvents == null || roadSubEvents.isEmpty()) {
            return EventStatus.ERROR;
        }
        Instant startDate = ProtobufUtils.instantFromTimestamp(roadEvent.getStartDate());
        Instant endDate = ProtobufUtils.instantFromTimestamp(roadEvent.getEndDate());
        if (startDate.isAfter(Instant.now())) {
            return EventStatus.UPCOMING;
        }
        if (endDate.isBefore(Instant.now())) {
            return EventStatus.COMPLETED;
        }
        return EventStatus.ONGOING;
    }

    public interface RoadEventIdOnly {
        Long getId();
    }
}
