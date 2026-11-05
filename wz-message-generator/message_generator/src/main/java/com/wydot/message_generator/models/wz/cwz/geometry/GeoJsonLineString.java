package com.wydot.message_generator.models.wz.cwz.geometry;

import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.List;

@EqualsAndHashCode(callSuper = true)
public @Data @Builder class GeoJsonLineString extends GeoJsonGeometry {
    private List<List<Double>> coordinates; // [[longitude, latitude], [longitude, latitude], ...]
}