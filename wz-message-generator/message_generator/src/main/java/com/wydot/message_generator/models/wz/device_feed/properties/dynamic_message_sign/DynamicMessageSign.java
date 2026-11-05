package com.wydot.message_generator.models.wz.device_feed.properties.dynamic_message_sign;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.wydot.message_generator.models.wz.device_feed.properties.FieldDeviceProperties;

import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
public @Data @Builder class DynamicMessageSign extends FieldDeviceProperties {
    @JsonProperty("message_multi_string")
    private String messageMultiString;
}
