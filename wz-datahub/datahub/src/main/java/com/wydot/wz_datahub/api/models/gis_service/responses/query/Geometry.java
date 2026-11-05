package com.wydot.wz_datahub.api.models.gis_service.responses.query;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Geometry {
    @JsonProperty("hasZ")
    private Boolean hasZ;

    @JsonProperty("hasM")
    private Boolean hasM;

    @JsonProperty("paths")
    private List<List<List<Double>>> paths; // Nested lists for the paths
}