package com.wydot.wz_datahub.api.models.wz.con_admin;

public enum RoadSegmentDirection {
    BOTH("both"),
    NORTHBOUND("northbound"),
    SOUTHBOUND("southbound"),
    EASTBOUND("eastbound"),
    WESTBOUND("westbound");

    private final String direction;

    RoadSegmentDirection(String direction) {
        this.direction = direction;
    }

    public String getValue() {
        return direction;
    }
}
