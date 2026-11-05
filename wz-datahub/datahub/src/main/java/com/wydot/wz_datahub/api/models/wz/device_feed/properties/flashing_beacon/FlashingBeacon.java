package com.wydot.wz_datahub.api.models.wz.device_feed.properties.flashing_beacon;

import com.fasterxml.jackson.annotation.JsonProperty;

import com.wydot.wz_datahub.api.models.wz.device_feed.properties.FieldDeviceProperties;

import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
public @Data class FlashingBeacon extends FieldDeviceProperties {
    @JsonProperty("function")
    private FlashingBeaconFunction function;
    @JsonProperty("is_flashing")
    private Boolean isFlashing;
    @JsonProperty("sign_text")
    private String signText;
}
