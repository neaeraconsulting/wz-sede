package com.wydot.wz_datahub.api.models.wz.con_admin;

public enum ProjectStatus {
    ACTIVE("active"),
    SUSPENDED("suspended");

    private final String status;

    ProjectStatus(String status) {
        this.status = status;
    }

    public String getValue() {
        return status;
    }
}