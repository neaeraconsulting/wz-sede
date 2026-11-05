package com.wydot.wz_datahub.api.models.gis_service.responses.query_attribute_set;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.wydot.wz_datahub.api.models.gis_service.responses.SpatialReference;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class QueryAttributeSetResponse {
    @JsonProperty("success")
    private Boolean success;

    @JsonProperty("displayFieldName")
    private String displayFieldName;

    @JsonProperty("features")
    private List<Feature> features;

    @JsonProperty("fields")
    private List<Field> fields;

    @JsonProperty("fieldAliases")
    private FieldAliases fieldAliases;

    @JsonProperty("geometryType")
    private String geometryType;

    @JsonProperty("spatialReference")
    private SpatialReference spatialReference;
}