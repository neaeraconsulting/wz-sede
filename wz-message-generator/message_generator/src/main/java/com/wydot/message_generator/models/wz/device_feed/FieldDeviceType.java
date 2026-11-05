package com.wydot.message_generator.models.wz.device_feed;

import com.fasterxml.jackson.annotation.JsonProperty;

public enum FieldDeviceType {
    @JsonProperty("arrow-board")
    ARROW_BOARD,
    @JsonProperty("camera")
    CAMERA,
    @JsonProperty("dynamic-message-sign")
    DYNAMIC_MESSAGE_SIGN,
    @JsonProperty("flashing-beacon")
    FLASHING_BEACON,
    @JsonProperty("hybrid-sign")
    HYBRID_SIGN,
    @JsonProperty("location-marker")
    LOCATION_MARKER,
    @JsonProperty("traffic-sensor")
    TRAFFIC_SENSOR,
    @JsonProperty("traffic-signal")
    TRAFFIC_SIGNAL;
}
