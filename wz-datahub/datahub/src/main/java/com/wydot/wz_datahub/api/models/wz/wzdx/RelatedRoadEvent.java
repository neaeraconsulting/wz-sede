package com.wydot.wz_datahub.api.models.wz.wzdx;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

/**
 * Class representing the a road event which is related to the parent road event.
 * @see <a href="https://github.com/usdot-jpo-ode/wzdx/blob/main/spec-content/objects/RelatedRoadEvent.md">RelatedRoadEvent</a>
 */
@Data
public class RelatedRoadEvent {
    @JsonProperty("type")
    private RelatedRoadEventType type;
    @JsonProperty("id")
    private String id;
}
