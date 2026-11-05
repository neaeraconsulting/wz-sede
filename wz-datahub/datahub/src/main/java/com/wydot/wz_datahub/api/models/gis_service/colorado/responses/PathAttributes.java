package com.wydot.wz_datahub.api.models.gis_service.colorado.responses;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class PathAttributes {
    @JsonProperty("OBJECTID")
    private Integer objectId;

    @JsonProperty("Route")
    private String route;

    @JsonProperty("FromMeasure")
    private Double fromMeasure;

    @JsonProperty("ToMeasure")
    private Double toMeasure;

    @JsonProperty("Distance")
    private Double distance;

    @JsonProperty("MMin")
    private Double mMin;

    @JsonProperty("MMax")
    private Double mMax;

    @JsonProperty("SHAPE_Length")
    private Double shapeLength;
}