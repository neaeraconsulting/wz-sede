package com.wydot.wz_datahub.api.models.wanco.sabp;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

@Data
public class WancoSABPOwner {
    @JsonProperty("company")
    private String company;
}