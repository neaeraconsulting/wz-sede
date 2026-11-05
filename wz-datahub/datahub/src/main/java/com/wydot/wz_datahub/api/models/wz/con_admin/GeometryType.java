package com.wydot.wz_datahub.api.models.wz.con_admin;

import com.fasterxml.jackson.annotation.JsonProperty;

public enum GeometryType {
    @JsonProperty("multipoint")
    MULTIPOINT,
    @JsonProperty("linestring")
    LINESTRING,
    @JsonProperty("polygon")
    POLYGON;
}
