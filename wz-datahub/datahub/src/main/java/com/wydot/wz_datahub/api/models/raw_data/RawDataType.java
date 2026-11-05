package com.wydot.wz_datahub.api.models.raw_data;

import com.fasterxml.jackson.annotation.JsonProperty;

public enum RawDataType {
    @JsonProperty("icone")
    ICONE,
    @JsonProperty("ver_mac")
    VER_MAC,
    @JsonProperty("wanco")
    WANCO,
    @JsonProperty("pi_lit")
    PI_LIT,
    @JsonProperty("wzam_report")
    WZAM_REPORT,
    @JsonProperty("wzam_mini_report")
    WZAM_MINI_REPORT,
    @JsonProperty("wzam_recording")
    WZAM_RECORDING,
    @JsonProperty("wzam_worker")
    WZAM_WORKER,
    @JsonProperty("wzam_vehicle")
    WZAM_VEHICLE,
    @JsonProperty("avl_vehicle")
    AVL_VEHICLE;

    public String getCollectionName() {
        switch (this) {
            case ICONE:
                return "raw.icone";
            case VER_MAC:
                return "raw.ver_mac";
            case WANCO:
                return "raw.wanco";
            case PI_LIT:
                return "raw.pi_lit";
            case WZAM_REPORT:
                return "raw.wzam_reports";
            case WZAM_MINI_REPORT:
                return "raw.wzam_mini_reports";
            case WZAM_RECORDING:
                return "raw.wzam_recordings";
            case WZAM_WORKER:
                return "raw.wzam_mobile_reports";
            case WZAM_VEHICLE:
                return "raw.wzam_mobile_reports";
            case AVL_VEHICLE:
                return "raw.avl_vehicle_locations";
            default:
                throw new IllegalArgumentException("Unknown RawDataType: " + this);
        }
    }

    public String getDeviceMake(String defaultValue) {
        return switch (this) {
            case ICONE -> "iCone";
            case VER_MAC -> "Ver-Mac";
            case PI_LIT -> "Pi-Lit";
            case WZAM_REPORT -> "WZAM Report";
            case WZAM_RECORDING -> "WZAM Recording";
            case WZAM_WORKER -> "WZAM Worker";
            case WZAM_VEHICLE -> "WZAM Vehicle";
            case AVL_VEHICLE -> "WYDOT AVL";
            default -> defaultValue != null ? defaultValue : "unknown";
        };
    }

    public static RawDataType fromDeviceMake(String make) {
        if (make == null) {
            return null;
        }
        return switch (make) {
            case "iCone" -> ICONE;
            case "Ver-Mac" -> VER_MAC;
            case "Pi-Lit" -> PI_LIT;
            case "WZAM Report" -> WZAM_REPORT;
            case "WZAM Recording" -> WZAM_RECORDING;
            case "WZAM Worker" -> WZAM_WORKER;
            case "WZAM Vehicle" -> WZAM_VEHICLE;
            case "WYDOT AVL" -> AVL_VEHICLE;
            default -> null;
        };
    }
}
