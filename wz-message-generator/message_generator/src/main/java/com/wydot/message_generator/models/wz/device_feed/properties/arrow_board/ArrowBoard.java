package com.wydot.message_generator.models.wz.device_feed.properties.arrow_board;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.wydot.message_generator.models.wz.device_feed.properties.FieldDeviceProperties;

import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
public @Data @Builder class ArrowBoard extends FieldDeviceProperties {
    @JsonProperty("pattern")
    private ArrowBoardPattern pattern;
    @JsonProperty("is_in_transport_position")
    private Boolean isInTransportPosition;
}
