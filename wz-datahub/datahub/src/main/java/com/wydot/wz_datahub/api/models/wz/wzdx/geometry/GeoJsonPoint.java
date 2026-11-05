package com.wydot.wz_datahub.api.models.wz.wzdx.geometry;

import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
public @Data class GeoJsonPoint extends GeoJsonGeometry {
    private List<Double> coordinates; // [longitude, latitude]
}