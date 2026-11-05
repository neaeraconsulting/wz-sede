package com.wydot.wz_datahub.api.models.gis_service.responses;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class SpatialReference {
    @JsonProperty("wkid")
    private Integer wkid;
    @JsonProperty("wkt")
    private String wkt;
}