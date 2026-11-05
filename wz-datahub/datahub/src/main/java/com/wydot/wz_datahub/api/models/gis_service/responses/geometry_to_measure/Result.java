package com.wydot.wz_datahub.api.models.gis_service.responses.geometry_to_measure;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Result {
    @JsonProperty("routeId")
    private String routeId;

    @JsonProperty("measure")
    private Double measure;

    @JsonProperty("distance")
    private Double distance;

    @JsonProperty("geometryType")
    private String geometryType;

    @JsonProperty("geometry")
    private Geometry geometry;
}