package com.wydot.wz_datahub.api.models.wz.wzdx;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Enum representing the impact on vehicle traffic.
 * 
 * @see <a href=
 *      "https://github.com/usdot-jpo-ode/wzdx/blob/main/spec-content/enumerated-types/VehicleImpact.md">VehicleImpact</a>
 */
public enum VehicleImpact {
    @JsonProperty("all-lanes-closed")
    ALL_LANES_CLOSED,
    @JsonProperty("some-lanes-closed")
    SOME_LANES_CLOSED,
    @JsonProperty("all-lanes-open")
    ALL_LANES_OPEN,
    @JsonProperty("alternating-one-way")
    ALTERNATING_ONE_WAY,
    @JsonProperty("some-lanes-closed-merge-left")
    SOME_LANES_CLOSED_MERGE_LEFT,
    @JsonProperty("some-lanes-closed-merge-right")
    SOME_LANES_CLOSED_MERGE_RIGHT,
    @JsonProperty("all-lanes-open-shift-left")
    ALL_LANES_OPEN_SHIFT_LEFT,
    @JsonProperty("all-lanes-open-shift-right")
    ALL_LANES_OPEN_SHIFT_RIGHT,
    @JsonProperty("some-lanes-closed-split")
    SOME_LANES_CLOSED_SPLIT,
    @JsonProperty("flagging")
    FLAGGING,
    @JsonProperty("temporary-traffic-signal")
    TEMPORARY_TRAFFIC_SIGNAL,
    @JsonProperty("unknown")
    UNKNOWN;
}