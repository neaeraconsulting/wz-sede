package com.wydot.wz_datahub.api.models.gis_service.responses.query;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.wydot.wz_datahub.api.models.gis_service.responses.SpatialReference;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class QueryResponse {
    @JsonProperty("objectIdFieldName")
    private String objectIdFieldName;

    @JsonProperty("globalIdFieldName")
    private String globalIdFieldName;

    @JsonProperty("hasM")
    private Boolean hasM;

    @JsonProperty("hasZ")
    private Boolean hasZ;

    @JsonProperty("features")
    private List<Feature> features;

    @JsonProperty("fields")
    private List<Field> fields;

    @JsonProperty("geometryType")
    private String geometryType;

    @JsonProperty("spatialReference")
    private SpatialReference spatialReference;
}