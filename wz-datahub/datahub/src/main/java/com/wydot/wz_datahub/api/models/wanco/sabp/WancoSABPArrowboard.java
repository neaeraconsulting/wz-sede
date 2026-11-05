package com.wydot.wz_datahub.api.models.wanco.sabp;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

@Data
public class WancoSABPArrowboard {
    @JsonProperty("id")
    private String id;

    @JsonProperty("name")
    private String name;

    @JsonProperty("lastContact")
    private String lastContact;

    @JsonProperty("firmware")
    private String firmware;

    @JsonProperty("voltage")
    private Double voltage;

    @JsonProperty("errorCodes")
    private List<ErrorCode> errorCodes;

    @JsonProperty("owner")
    private WancoSABPOwner owner;

    @JsonProperty("gps")
    private WancoSABPGps gps;

    @JsonProperty("display")
    private WancoSABPDisplay display;
}