package com.wydot.wz_datahub.api.models.wz.con_admin;

import com.fasterxml.jackson.annotation.JsonProperty;

public enum MobilityType {
    @JsonProperty("static")
    STATIC,
    @JsonProperty("mobile")
    MOBILE;
}