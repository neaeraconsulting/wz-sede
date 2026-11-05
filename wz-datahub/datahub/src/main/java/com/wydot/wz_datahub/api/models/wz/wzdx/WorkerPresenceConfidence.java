package com.wydot.wz_datahub.api.models.wz.wzdx;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Enum representing the type of event
 * 
 * @see <a href=
 *      "https://github.com/usdot-jpo-ode/wzdx/blob/main/spec-content/enumerated-types/WorkerPresenceConfidence.md">WorkerPresenceConfidence</a>
 */
public enum WorkerPresenceConfidence {
    @JsonProperty("low")
    LOW,
    @JsonProperty("medium")
    MEDIUM,
    @JsonProperty("high")
    HIGH;
}
