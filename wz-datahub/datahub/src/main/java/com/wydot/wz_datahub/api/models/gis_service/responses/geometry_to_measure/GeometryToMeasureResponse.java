package com.wydot.wz_datahub.api.models.gis_service.responses.geometry_to_measure;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.wydot.wz_datahub.api.models.gis_service.responses.SpatialReference;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class GeometryToMeasureResponse {
    @JsonProperty("unitsOfMeasure")
    private String unitsOfMeasure;

    @JsonProperty("spatialReference")
    private SpatialReference spatialReference;

    @JsonProperty("locations")
    private List<Location> locations;
}