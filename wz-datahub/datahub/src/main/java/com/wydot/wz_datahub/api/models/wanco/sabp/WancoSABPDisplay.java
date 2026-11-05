package com.wydot.wz_datahub.api.models.wanco.sabp;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

@Data
public class WancoSABPDisplay {
    @JsonProperty("compass")
    private Integer compass;

    @JsonProperty("pattern")
    private DisplayPattern pattern;

    @JsonProperty("deployed")
    private Boolean deployed;
}