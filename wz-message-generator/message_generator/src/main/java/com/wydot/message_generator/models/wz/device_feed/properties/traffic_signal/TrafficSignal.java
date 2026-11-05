package com.wydot.message_generator.models.wz.device_feed.properties.traffic_signal;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.wydot.message_generator.models.wz.device_feed.properties.FieldDeviceProperties;

import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
public @Data @Builder class TrafficSignal extends FieldDeviceProperties {
    @JsonProperty("mode")
    private TrafficSignalMode mode;
}
