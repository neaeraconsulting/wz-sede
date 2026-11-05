package com.wydot.wz_datahub.api.models.wz.wzdx;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Enum representing the type of event
 * 
 * @see <a href=
 *      "https://github.com/usdot-jpo-ode/wzdx/blob/main/spec-content/enumerated-types/EventType.md">EventType</a>
 */
public enum EventType {
    @JsonProperty("work-zone")
    WORK_ZONE,
    @JsonProperty("detour")
    DETOUR,
}