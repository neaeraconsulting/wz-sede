package com.wydot.wz_datahub.api.models.wz.con_admin;

public enum RoadSectionType {
    HIGHWAY("highway"),
    COUNTY_ROAD("county_road"),
    LRS("lrs");

    private final String type;

    RoadSectionType(String type) {
        this.type = type;
    }

    public String getValue() {
        return type;
    }
}