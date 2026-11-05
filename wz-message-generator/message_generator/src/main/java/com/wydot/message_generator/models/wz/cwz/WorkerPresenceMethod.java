package com.wydot.message_generator.models.wz.cwz;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Enum representing the type of event
 * 
 * @see <a href=
 *      "https://github.com/usdot-jpo-ode/wzdx/blob/main/spec-content/enumerated-types/WorkerPresenceMethod.md">WorkerPresenceMethod</a>
 */
public enum WorkerPresenceMethod {
    @JsonProperty("camera-monitoring")
    CAMERA_MONITORING,
    @JsonProperty("maintenance-vehicle-present")
    MAINTENANCE_VEHICLE_PRESENT,
    @JsonProperty("wearables-present")
    WEARABLES_PRESENT,
    @JsonProperty("mobile-device-present")
    MOBILE_DEVICE_PRESENT,
    @JsonProperty("check-in-app")
    CHECK_IN_APP,
    @JsonProperty("check-in-verbal")
    CHECK_IN_VERBAL,
    @JsonProperty("other")
    OTHER;
}
