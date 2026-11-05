package com.wydot.wz_datahub.api.models.wz.device_feed.properties.marked_location;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

public @Data class MarkedLocation {
    @JsonProperty("type")
    private MarkedLocationType locationType;
    @JsonProperty("road_event_id")
    private String roadEventId;
}
