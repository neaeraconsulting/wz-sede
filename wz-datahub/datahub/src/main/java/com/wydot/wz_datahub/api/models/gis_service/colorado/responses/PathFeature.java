package com.wydot.wz_datahub.api.models.gis_service.colorado.responses;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class PathFeature {
    @JsonProperty("attributes")
    private PathAttributes attributes;

    @JsonProperty("geometry")
    private PathGeometry geometry;
}