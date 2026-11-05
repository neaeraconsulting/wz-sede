package com.wydot.wz_datahub.api.models.gis_service.responses.geometry_to_measure;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Location {
    @JsonProperty("status")
    private String status;

    @JsonProperty("results")
    private List<Result> results;
}