package com.wydot.message_generator.models.wz.device_feed.properties.marked_location;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.wydot.message_generator.models.wz.device_feed.properties.FieldDeviceProperties;

import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
public @Data @Builder class LocationMarker extends FieldDeviceProperties {
    @JsonProperty("marked_locations")
    private List<MarkedLocation> markedLocations;
}
