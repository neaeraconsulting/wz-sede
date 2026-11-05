package com.wydot.wz_datahub.api.models.wz.device_feed.properties.marked_location;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.wydot.wz_datahub.api.models.wz.device_feed.properties.FieldDeviceProperties;

import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
public @Data class LocationMarker extends FieldDeviceProperties {
    @JsonProperty("marked_locations")
    private List<MarkedLocation> markedLocations;
}
