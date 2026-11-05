package com.wydot.wz_datahub.api.models.gis_service.responses.query;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Feature {
    @JsonProperty("attributes")
    private Attributes attributes;

    @JsonProperty("geometry")
    private Geometry geometry;
}