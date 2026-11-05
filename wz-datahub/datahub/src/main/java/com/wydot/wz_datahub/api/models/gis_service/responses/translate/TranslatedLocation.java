package com.wydot.wz_datahub.api.models.gis_service.responses.translate;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class TranslatedLocation {
    @JsonProperty("networkLayerId")
    private Integer networkLayerId;

    @JsonProperty("routeId")
    private String routeId;

    @JsonProperty("measure")
    private Double measure;
}