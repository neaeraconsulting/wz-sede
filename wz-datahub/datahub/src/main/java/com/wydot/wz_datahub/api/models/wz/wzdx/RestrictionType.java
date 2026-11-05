package com.wydot.wz_datahub.api.models.wz.wzdx;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * The type of vehicle restriction on a roadway.
 * 
 * @see <a href=
 *      "https://github.com/usdot-jpo-ode/wzdx/blob/main/spec-content/enumerated-types/RestrictionType.md">RestrictionType</a>
 */

public enum RestrictionType {
    @JsonProperty("local-access-only")
    LOCAL_ACCESS_ONLY,
    @JsonProperty("no-trucks")
    NO_TRUCKS,
    @JsonProperty("travel-peak-hours-only")
    TRAVEL_PEAK_HOURS_ONLY,
    @JsonProperty("hov-3")
    HOV_3,
    @JsonProperty("hov-2")
    HOV_2,
    @JsonProperty("no-parking")
    NO_PARKING,
    @JsonProperty("reduced-width")
    REDUCED_WIDTH,
    @JsonProperty("reduced-height")
    REDUCED_HEIGHT,
    @JsonProperty("reduced-length")
    REDUCED_LENGTH,
    @JsonProperty("reduced-weight")
    REDUCED_WEIGHT,
    @JsonProperty("axle-load-limit")
    AXLE_LOAD_LIMIT,
    @JsonProperty("gross-weight-limit")
    GROSS_WEIGHT_LIMIT,
    @JsonProperty("towing-prohibited")
    TOWING_PROHIBITED,
    @JsonProperty("permitted-oversize-loads-prohibited")
    PERMITTED_OVERSIZE_LOADS_PROHIBITED,
    @JsonProperty("no-passing")
    NO_PASSING
}