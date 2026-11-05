package com.wydot.wz_datahub.api.models.wz.wzdx;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Enum representing the type of lane.
 * 
 * @see <a href=
 *      "https://github.com/usdot-jpo-ode/wzdx/blob/main/spec-content/enumerated-types/LaneType.md">LaneType</a>
 */
public enum LaneType {
    @JsonProperty("general")
    GENERAL,
    @JsonProperty("exit-lane")
    EXIT_LANE,
    @JsonProperty("exit-ramp")
    EXIT_RAMP,
    @JsonProperty("entrance-lane")
    ENTRANCE_LANE,
    @JsonProperty("entrance-ramp")
    ENTRANCE_RAMP,
    @JsonProperty("sidewalk")
    SIDEWALK,
    @JsonProperty("bike-lane")
    BIKE_LANE,
    @JsonProperty("shoulder")
    SHOULDER,
    @JsonProperty("parking")
    PARKING,
    @JsonProperty("median")
    MEDIAN,
    @JsonProperty("two-way-center-turn-lane")
    TWO_WAY_CENTER_TURN_LANE,
}