package com.wydot.wz_datahub.api.models.wz.wzdx.geometry;

import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.List;

@EqualsAndHashCode(callSuper = true)
public @Data class GeoJsonLineString extends GeoJsonGeometry {
    private List<List<Double>> coordinates; // [[longitude, latitude], [longitude, latitude], ...]
}