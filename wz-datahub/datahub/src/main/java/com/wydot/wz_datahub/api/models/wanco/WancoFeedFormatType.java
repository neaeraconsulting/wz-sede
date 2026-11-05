package com.wydot.wz_datahub.api.models.wanco;

import com.fasterxml.jackson.annotation.JsonProperty;

public enum WancoFeedFormatType {
    @JsonProperty("WZDx4.2")
    WZDX_42,
    @JsonProperty("SABP")
    SABP;
}
