package com.wydot.wz_datahub.api.models.wz.con_admin;

public enum RoadSegmentArmedStatus {
    ARMED("armed"),
    DISARMED("disarmed");

    private final String status;

    RoadSegmentArmedStatus(String status) {
        this.status = status;
    }

    public String getValue() {
        return status;
    }
}