package com.wydot.wz_datahub.api.models.wanco.sabp;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

@Data
public class WancoSABPDocument {
    @JsonProperty("format")
    private String format;

    @JsonProperty("version")
    private String version;

    @JsonProperty("source")
    private String source;

    @JsonProperty("tier")
    private Integer tier;

    @JsonProperty("timestamp")
    private String timestamp;
}