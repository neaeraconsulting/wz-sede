package com.wydot.wz_datahub.api.models.reports;

import java.time.Instant;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
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
@Data
@AllArgsConstructor
@NoArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
public class WorkerPresenceReport {
    @JsonProperty("id")
    private Long id;
    @JsonProperty("road_event_id")
    private Long roadEventId;
    @JsonProperty("route_and_measure_range")
    private RouteAndMeasureRange routeAndMeasureRange;
    @JsonSerialize(using = InstantToMillisSerializer.class)
    @JsonDeserialize(using = InstantFromMillisDeserializer.class)
    @JsonProperty("timestamp")
    private Instant timestamp;
    @JsonProperty("schedule")
    private EventRecurrence schedule;
    @JsonSerialize(using = InstantToMillisSerializer.class)
    @JsonDeserialize(using = InstantFromMillisDeserializer.class)
    @JsonProperty("end_timestamp")
    private Instant endTimestamp;
    @JsonProperty("user_id")
    private String userId;
}
