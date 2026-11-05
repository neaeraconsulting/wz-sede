package com.wydot.wz_datahub.api.models.gis_service;

import com.google.type.LatLng;

public enum State {
    COLORADO, WYOMING, UNKNOWN;

    public static State fromLatLng(LatLng point) {
        double lat = point.getLatitude();
        double lng = point.getLongitude();
        
        // Colorado bounding box
        if (lat >= 36.99 && lat <= 41.0012 && lng >= -109.06 && lng <= -102.04) {
            return State.COLORADO;
        }
        
        // Wyoming bounding box
        if (lat >= 41.0012 && lat <= 45.01 && lng >= -111.06 && lng <= -104.04) {
            return State.WYOMING;
        }
        
        return State.UNKNOWN;
    }

    public static State fromRouteId(String routeId) {
        if (routeId == null || routeId.equals("UNKNOWN")) {
            return State.UNKNOWN;
        }
        else if (routeId.startsWith("ML") || routeId.startsWith("RMML")) {
            return State.WYOMING;
        }
        return State.COLORADO;
    }

    public boolean isRouteIdDec(String routeId) {
        return switch (this) {
            case State.WYOMING -> routeId.toLowerCase().endsWith("d");
            case State.COLORADO -> routeId.toLowerCase().endsWith("_dec");
            default -> false;
        };
    }
}
