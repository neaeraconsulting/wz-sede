package com.wydot.wz_datahub.api.models.gis_service;

import com.wydot.wz_datahub.api.utilities.Units;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class RouteAndMeasure {
    private String routeId;
    private String translatedRouteId;
    private Double measure;
    private Double translatedMeasure;

    public boolean compareAndUpdateRouteId(String otherRouteId) {
        boolean doesMatch = compareRouteId(otherRouteId);
        if (doesMatch) {
            this.routeId = otherRouteId;
        }
        return doesMatch;
    }

    public boolean compareRouteId(String otherRouteId) {
        if (otherRouteId == null) {
            return false;
        }
        return removeLastChar(routeId).equals(removeLastChar(otherRouteId));
    }

    public static boolean isRouteIdDec(String routeId) {
        State state = State.fromRouteId(routeId);
        return state.isRouteIdDec(routeId);
    }

    public RouteAndMeasureRange addRange(double distanceMeters, Boolean isDec) {
        // TODO: Confirm that the new measures are usable, since they didn't come from
        // the GIS server
        double distanceMiles = Units.convertMetersToMiles(distanceMeters);
        if (isDec == null) {
            isDec = isRouteIdDec(this.routeId);
        }
        if (isDec) {
            // Measures decrease, so start is higher than end
            return new RouteAndMeasureRange(routeId, translatedRouteId,
                    measure + distanceMiles / 2,
                    translatedMeasure + distanceMiles / 2,
                    measure - distanceMiles / 2,
                    translatedMeasure - distanceMiles / 2);
        } else {
            return new RouteAndMeasureRange(routeId, translatedRouteId,
                    measure - distanceMiles / 2,
                    translatedMeasure - distanceMiles / 2,
                    measure + distanceMiles,
                    translatedMeasure + distanceMiles);
        }
    }

    private static String removeLastChar(String str) {
        if (str == null || str.length() == 0) {
            return str;
        }
        return str.substring(0, str.length() - 1);
    }
}
