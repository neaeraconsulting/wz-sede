package com.wydot.wz_datahub.api.models.wz.wzdx;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Enum representing the type of related road event.
 * 
 * @see <a href=
 *      "https://github.com/usdot-jpo-ode/wzdx/blob/main/spec-content/enumerated-types/RelatedRoadEventType.md">RelatedRoadEventType</a>
 */
public enum RelatedRoadEventType {
    @JsonProperty("first-in-sequence")
    FIRST_IN_SEQUENCE,
    @JsonProperty("next-in-sequence")
    NEXT_IN_SEQUENCE,
    @JsonProperty("first-occurrence")
    FIRST_OCCURRENCE,
    @JsonProperty("next-occurrence")
    NEXT_OCCURRENCE,
    @JsonProperty("related-work-zone")
    RELATED_WORK_ZONE,
    @JsonProperty("related-detour")
    RELATED_DETOUR,
    @JsonProperty("planned-moving-operation")
    PLANNED_MOVING_OPERATION,
    @JsonProperty("active-moving-operation")
    ACTIVE_MOVING_OPERATION;
}