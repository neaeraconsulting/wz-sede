package com.wydot.wz_datahub.api.models.gis_service.responses.measure_to_geometry;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.wydot.wz_datahub.api.models.gis_service.responses.SpatialReference;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class MeasureToGeometryResponse {
    @JsonProperty("spatialReference")
    private SpatialReference spatialReference;

    @JsonProperty("locations")
    private List<Location> locations;
}