package com.wydot.wz_datahub.api.models.workers;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.google.type.LatLng;
import com.wydot.wz_datahub.api.models.serialization.LatLngJsonConverter;
import com.wydot.wz_datahub.api.models.serialization.instant.InstantFromMillisDeserializer;
import com.wydot.wz_datahub.api.models.serialization.instant.InstantToMillisSerializer;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class LiveWorkerLocation {
    @JsonSerialize(using = InstantToMillisSerializer.class)
    @JsonDeserialize(using = InstantFromMillisDeserializer.class)
    @JsonProperty("timestamp")
    private Instant timestamp;
    @JsonProperty("road_event_id")
    private Long roadEventId;
    @JsonProperty("worker_id")
    private String workerId; // this is a user's keycloak ID
    @JsonProperty("is_active")
    private Boolean isActive; // true if actively working, false if moving to work zone
    @JsonProperty("app_version")
    private String appVersion;
    @JsonProperty("velocity_kph")
    private double velocityKph;
    @JsonProperty("heading")
    private double heading;
    @JsonProperty("location_type")
    private WorkerLocationType locationType;
    @JsonSerialize(using = LatLngJsonConverter.LatLngSerializer.class)
    @JsonDeserialize(using = LatLngJsonConverter.LatLngDeserializer.class)
    @JsonProperty("location")
    private LatLng location;
    @JsonSerialize(using = LatLngJsonConverter.LatLngListSerializer.class)
    @JsonDeserialize(using = LatLngJsonConverter.LatLngListDeserializer.class)
    @JsonProperty("location_history")
    private List<LatLng> locationHistory;
}
