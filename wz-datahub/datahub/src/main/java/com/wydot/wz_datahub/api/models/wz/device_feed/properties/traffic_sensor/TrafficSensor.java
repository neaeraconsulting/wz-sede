package com.wydot.wz_datahub.api.models.wz.device_feed.properties.traffic_sensor;

import java.time.Instant;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.wydot.wz_datahub.api.models.serialization.instant.InstantFromIsoString;
import com.wydot.wz_datahub.api.models.wz.device_feed.properties.FieldDeviceProperties;

import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
public @Data class TrafficSensor extends FieldDeviceProperties {
    @JsonProperty("collection_interval_start_date")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss'Z'", timezone = "UTC")
    @JsonDeserialize(using = InstantFromIsoString.class)
    private Instant collectionIntervalStartDate;
    @JsonProperty("collection_interval_end_date")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss'Z'", timezone = "UTC")
    @JsonDeserialize(using = InstantFromIsoString.class)
    private Instant collectionIntervalEndDate;
    @JsonProperty("average_speed_kph")
    private Double averageSpeedKph;
    @JsonProperty("volume_vph")
    private Double volumeVph;
    @JsonProperty("occupancy_percent")
    private Double occupancyPercent;
    @JsonProperty("lane_data")
    private List<TrafficSensorLaneData> laneData;
}
