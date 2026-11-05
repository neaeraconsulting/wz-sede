package com.wydot.wz_datahub.api.models.wanco.sabp;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

@Data
public class WancoSABPData {
    @JsonProperty("document")
    private WancoSABPDocument document;

    @JsonProperty("arrowboards")
    private List<WancoSABPArrowboard> arrowboards;
}