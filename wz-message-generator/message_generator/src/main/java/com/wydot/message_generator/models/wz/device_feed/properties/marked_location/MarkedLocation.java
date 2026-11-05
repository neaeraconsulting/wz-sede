package com.wydot.message_generator.models.wz.device_feed.properties.marked_location;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Builder;
import lombok.Data;

public @Data @Builder class MarkedLocation {
    @JsonProperty("type")
    private MarkedLocationType locationType;
    @JsonProperty("road_event_id")
    private String roadEventId;
}
