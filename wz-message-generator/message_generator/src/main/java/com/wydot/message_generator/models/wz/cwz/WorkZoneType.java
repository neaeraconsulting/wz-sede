package com.wydot.message_generator.models.wz.cwz;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Enum representing the type of work zone.
 * 
 * @see <a href=
 *      "https://github.com/usdot-jpo-ode/wzdx/blob/main/spec-content/enumerated-types/WorkZoneType.md">WorkZoneType</a>
 */
public enum WorkZoneType {
    @JsonProperty("static")
    STATIC,
    @JsonProperty("moving")
    MOVING,
    @JsonProperty("planned-moving-area")
    PLANNED_MOVING_AREA,
}
