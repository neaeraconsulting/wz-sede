package com.wydot.wz_datahub.api.models.wz.wzdx;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Enum representing the direction of a roadway
 * 
 * @see <a href=
 *      "https://github.com/usdot-jpo-ode/wzdx/blob/main/spec-content/enumerated-types/Direction.md">Direction</a>
 */
public enum RoadwayDirection {
    @JsonProperty("northbound")
    NORTHBOUND,
    @JsonProperty("eastbound")
    EASTBOUND,
    @JsonProperty("southbound")
    SOUTHBOUND,
    @JsonProperty("westbound")
    WESTBOUND,
    @JsonProperty("inner-loop")
    INNER_LOOP,
    @JsonProperty("outer-loop")
    OUTER_LOOP,
    @JsonProperty("undefined")
    UNDEFINED,
    @JsonProperty("unknown")
    UNKNOWN;
}