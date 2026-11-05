package com.wydot.wz_datahub.api.models.wz.con_admin;

import com.fasterxml.jackson.annotation.JsonProperty;

public enum RoadSurfaceType {
    @JsonProperty("paved")
    PAVED,
    @JsonProperty("gravel")
    GRAVEL,
    @JsonProperty("dirt")
    DIRT,
    @JsonProperty("grooved")
    GROOVED,
}