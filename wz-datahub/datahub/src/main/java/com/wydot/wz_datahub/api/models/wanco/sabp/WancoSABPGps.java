package com.wydot.wz_datahub.api.models.wanco.sabp;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

@Data
public class WancoSABPGps {
    @JsonProperty("lock")
    private Integer lock;

    @JsonProperty("sampled")
    private String sampled;

    @JsonProperty("lat")
    private Double lat;

    @JsonProperty("lon")
    private Double lon;

    @JsonProperty("tried")
    private String tried;
}