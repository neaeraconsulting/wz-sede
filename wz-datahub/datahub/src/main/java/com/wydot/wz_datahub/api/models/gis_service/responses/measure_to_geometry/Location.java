package com.wydot.wz_datahub.api.models.gis_service.responses.measure_to_geometry;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Location {
    @JsonProperty("status")
    private String status;

    @JsonProperty("routeId")
    private String routeId;

    @JsonProperty("geometryType")
    private String geometryType;

    @JsonProperty("geometry")
    private Geometry geometry;
}