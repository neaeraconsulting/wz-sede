package com.wydot.wz_datahub.api.models.gis_service.responses.query_attribute_set;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Attributes {
    @JsonProperty("route_id")
    private String routeId;

    @JsonProperty("from_measure")
    private Double fromMeasure;

    @JsonProperty("to_measure")
    private Double toMeasure;

    @JsonProperty("full_name")
    private String fullName;

    @JsonProperty("prefix_type")
    private String prefixType;

    @JsonProperty("suffix_type")
    private String suffixType;

    @JsonProperty("objectid")
    private Integer objectId;
}
