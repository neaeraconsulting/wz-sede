package com.wydot.wz_datahub.api.models.update_processing;

import java.time.Instant;
import java.util.List;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.wydot.wz_datahub.api.models.gis_service.RouteAndMeasureRange;
import com.wydot.wz_datahub.api.models.serialization.instant.InstantFromMillisDeserializer;
import com.wydot.wz_datahub.api.models.serialization.instant.InstantToMillisSerializer;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@NoArgsConstructor
@AllArgsConstructor
@Data
public class DelayObservation {
    private DelayObservationType type;
    private ObservationSource source;
    @JsonSerialize(using = InstantToMillisSerializer.class)
    @JsonDeserialize(using = InstantFromMillisDeserializer.class)
    private Instant timestamp;
    private double confidence;
    private RouteAndMeasureRange measureRange;
    private Boolean workersPresent;
    private Integer speedLimit;
    private List<Integer> closedLanes;

    public DelayObservation(DelayObservationType type, ObservationSource source, Instant timestamp, Double confidence,
            RouteAndMeasureRange measureRange,
            Boolean workersPresent) {
        this.type = type;
        this.source = source;
        this.timestamp = timestamp;
        this.measureRange = measureRange;
        this.workersPresent = workersPresent;
    }

    public DelayObservation(DelayObservationType type, ObservationSource source, Instant timestamp, Double confidence,
            RouteAndMeasureRange measureRange,
            Integer speedLimit) {
        this.type = type;
        this.source = source;
        this.timestamp = timestamp;
        this.measureRange = measureRange;
        this.speedLimit = speedLimit;
    }

    public DelayObservation(DelayObservationType type, ObservationSource source, Instant timestamp, Double confidence,
            RouteAndMeasureRange measureRange,
            List<Integer> closedLanes) {
        this.type = type;
        this.source = source;
        this.timestamp = timestamp;
        this.measureRange = measureRange;
        this.closedLanes = closedLanes;
    }

    public DelayObservation copyWith(Double confidence, RouteAndMeasureRange measureRange, Boolean newWorkersPresent,
            Integer newSpeedLimit,
            List<Integer> newClosedLanes) {
        return new DelayObservation(this.type, this.source, this.timestamp,
                confidence != null ? confidence : this.confidence,
                measureRange != null ? measureRange : this.measureRange,
                newWorkersPresent != null ? newWorkersPresent : this.workersPresent,
                newSpeedLimit != null ? newSpeedLimit : this.speedLimit,
                newClosedLanes != null ? newClosedLanes : this.closedLanes);
    }
}
