package com.wydot.wz_datahub.api.models.wz.wzdx.geometry;

import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
public @Data class GeoJsonMultiPoint extends GeoJsonGeometry {
    private List<List<Double>> coordinates; // [[longitude, latitude], [longitude, latitude], ...]
}