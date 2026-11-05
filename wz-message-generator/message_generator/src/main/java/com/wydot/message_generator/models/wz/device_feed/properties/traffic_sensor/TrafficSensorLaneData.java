package com.wydot.message_generator.models.wz.device_feed.properties.traffic_sensor;

import com.fasterxml.jackson.annotation.JsonProperty;

public class TrafficSensorLaneData {
    @JsonProperty("lane_order")
    private Integer laneOrder;
    @JsonProperty("road_event_id")
    private String roadEventId;
    @JsonProperty("average_speed_kph")
    private Double averageSpeedKph;
    @JsonProperty("volume_vph")
    private Double VolumeVph;
    @JsonProperty("occupancy_percent")
    private Double occupancyPercent;
}
