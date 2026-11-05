package com.wydot.wz_datahub.api.models.wz.wzdx;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

/**
 * Class representing a lane in the work zone.
 * 
 * @see <a href=
 *      "https://github.com/usdot-jpo-ode/wzdx/blob/main/spec-content/objects/Lane.md">Lane</a>
 */
@Data
public class Lane {
    @JsonProperty("order")
    private int order;
    @JsonProperty("type")
    private LaneType type;
    @JsonProperty("status")
    private LaneStatus status;
    @JsonProperty("restrictions")
    private List<Restriction> restrictions;
}