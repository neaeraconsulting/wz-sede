package com.wydot.message_generator.models.wz.cwz.geometry;

import java.util.List;

import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
public @Data @Builder class GeoJsonPoint extends GeoJsonGeometry {
    private List<Double> coordinates; // [longitude, latitude]
}