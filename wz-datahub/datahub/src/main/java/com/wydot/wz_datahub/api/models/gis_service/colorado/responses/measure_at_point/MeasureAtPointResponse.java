package com.wydot.wz_datahub.api.models.gis_service.colorado.responses.measure_at_point;

import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.wydot.wz_datahub.api.models.gis_service.colorado.responses.PointFeature;
import com.wydot.wz_datahub.api.models.gis_service.colorado.responses.Field;
import com.wydot.wz_datahub.api.models.gis_service.colorado.responses.SpatialReference;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class MeasureAtPointResponse {
    @JsonProperty("displayFieldName")
    private String displayFieldName;

    @JsonProperty("fieldAliases")
    private Map<String, String> fieldAliases;

    @JsonProperty("geometryType")
    private String geometryType;

    @JsonProperty("spatialReference")
    private SpatialReference spatialReference;

    @JsonProperty("fields")
    private List<Field> fields;

    @JsonProperty("features")
    private List<PointFeature> features;
}