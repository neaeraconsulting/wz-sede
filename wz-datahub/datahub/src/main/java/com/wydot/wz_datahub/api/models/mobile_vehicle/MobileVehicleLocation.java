package com.wydot.wz_datahub.api.models.mobile_vehicle;

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
public class MobileVehicleLocation {
    @JsonSerialize(using = InstantToMillisSerializer.class)
    @JsonDeserialize(using = InstantFromMillisDeserializer.class)
    @JsonProperty(value = "timestamp", required = true)
    private Instant timestamp;
    @JsonProperty("road_event_id")
    private Long roadEventId;
    @JsonProperty(value = "worker_id", required = true)
    private String workerId; // this is a user's keycloak ID
    @JsonProperty(value = "is_active", required = true)
    private Boolean isActive; // true if actively working, false if moving to work zone
    @JsonProperty("app_version")
    private String appVersion;
    @JsonProperty(value = "velocity_kph", required = true)
    private double velocityKph;
    @JsonProperty(value = "heading", required = true)
    private double heading;
    @JsonProperty("license_plate")
    private String licensePlate;
    @JsonProperty(value = "operation_type", required = true)
    private MobileVehicleOperationType operationType;
    @JsonSerialize(using = LatLngJsonConverter.LatLngSerializer.class)
    @JsonDeserialize(using = LatLngJsonConverter.LatLngDeserializer.class)
    @JsonProperty(value = "location", required = true)
    private LatLng location;
    @JsonSerialize(using = LatLngJsonConverter.LatLngListSerializer.class)
    @JsonDeserialize(using = LatLngJsonConverter.LatLngListDeserializer.class)
    @JsonProperty("location_history")
    private List<LatLng> locationHistory;
}
