package com.wydot.wz_datahub.api.models.wz.device_feed.properties.traffic_signal;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.wydot.wz_datahub.api.models.wz.device_feed.properties.FieldDeviceProperties;

import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
public @Data class TrafficSignal extends FieldDeviceProperties {
    @JsonProperty("mode")
    private TrafficSignalMode mode;
}
