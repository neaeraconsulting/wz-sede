package com.wydot.wz_datahub.api.models.wz.device_feed.properties.hybrid_sign;

import com.fasterxml.jackson.annotation.JsonProperty;

import com.wydot.wz_datahub.api.models.wz.device_feed.properties.FieldDeviceProperties;

import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
public @Data class HybridSign extends FieldDeviceProperties {
    @JsonProperty("dynamic_message_function")
    private HybridSignDynamicMessageFunction dynamicMessageFunction;
    @JsonProperty("dynamic_message_text")
    private String dynamicMessageText;
    @JsonProperty("static_sign_text")
    private String staticSignText;
}
