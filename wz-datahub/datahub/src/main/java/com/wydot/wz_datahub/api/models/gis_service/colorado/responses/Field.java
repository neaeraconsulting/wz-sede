package com.wydot.wz_datahub.api.models.gis_service.colorado.responses;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Field {
    @JsonProperty("name")
    private String name;

    @JsonProperty("type")
    private String type;

    @JsonProperty("alias")
    private String alias;

    @JsonProperty("length")
    private Integer length; // Optional field, only present for string types
}