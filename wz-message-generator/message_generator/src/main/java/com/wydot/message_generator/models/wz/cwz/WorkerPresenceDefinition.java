package com.wydot.message_generator.models.wz.cwz;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Enum representing the definition of worker presence
 * 
 * @see <a href=
 *      "https://github.com/usdot-jpo-ode/wzdx/blob/main/spec-content/enumerated-types/WorkerPresenceDefinition.md">WorkerPresenceDefinition</a>
 */
public enum WorkerPresenceDefinition {
    @JsonProperty("workers-in-work-zone-working")
    WORKERS_IN_WORK_ZONE_WORKING,
    @JsonProperty("workers-in-work-zone-not-working")
    WORKERS_IN_WORK_ZONE_NOT_WORKING,
    @JsonProperty("mobile-equipment-in-work-zone-moving")
    MOBILE_EQUIPMENT_IN_WORK_ZONE_MOVING,
    @JsonProperty("mobile-equipment-in-work-zone-not-moving")
    MOBILE_EQUIPMENT_IN_WORK_ZONE_NOT_MOVING,
    @JsonProperty("fixed-equipment-in-work-zone")
    FIXED_EQUIPMENT_IN_WORK_ZONE,
    @JsonProperty("humans-behind-barrier")
    HUMANS_BEHIND_BARRIER,
    @JsonProperty("humans-in-right-of-way")
    HUMANS_IN_RIGHT_OF_WAY;
}
