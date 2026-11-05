package com.wydot.wz_datahub.api.models.gis_service.responses.translate;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Location {
    @JsonProperty("routeId")
    private String routeId;

    @JsonProperty("measure")
    private Double measure;

    @JsonProperty("translatedLocations")
    private List<TranslatedLocation> translatedLocations;
}