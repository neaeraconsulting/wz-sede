package com.wydot.wz_datahub.api.models.wz.device_feed;

import com.fasterxml.jackson.annotation.JsonProperty;

public enum FieldDeviceStatus {
    @JsonProperty("ok")
    OK,
    @JsonProperty("warning")
    WARNING,
    @JsonProperty("error")
    ERROR,
    @JsonProperty("unknown")
    UNKNOWN;
}
