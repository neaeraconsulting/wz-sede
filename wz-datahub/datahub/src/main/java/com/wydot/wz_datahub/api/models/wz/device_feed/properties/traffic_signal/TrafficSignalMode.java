package com.wydot.wz_datahub.api.models.wz.device_feed.properties.traffic_signal;

import com.fasterxml.jackson.annotation.JsonProperty;

public enum TrafficSignalMode {
    @JsonProperty("blank")
    BLANK,
    @JsonProperty("flashing-red")
    FLASHING_RED,
    @JsonProperty("flashing-yellow")
    FLASHING_YELLOW,
    @JsonProperty("fully-actuated")
    FULLY_ACTUATED,
    @JsonProperty("manual")
    MANUAL,
    @JsonProperty("pre-timed")
    PRE_TIMED,
    @JsonProperty("semi-actuated")
    SEMI_ACTUATED,
    @JsonProperty("unknown")
    UNKNOWN;
}
