package com.wydot.wz_datahub.api.models.wz.wzdx;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Enum representing the method used to locate the work zone.
 * 
 * @see <a href=
 *      "https://github.com/usdot-jpo-ode/wzdx/blob/main/spec-content/enumerated-types/LocationMethod.md">LocationMethod</a>
 */
public enum LocationMethod {
    @JsonProperty("channel-device-method")
    CHANNEL_DEVICE_METHOD,
    @JsonProperty("sign-method")
    SIGN_METHOD,
    @JsonProperty("junction-method")
    JUNCTION_METHOD,
    @JsonProperty("other")
    OTHER,
    @JsonProperty("unknown")
    UNKNOWN;
}