package com.wydot.wz_datahub.api.models.gis_service;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class GisRouteQuery {
    String routeId;
    Double fromMeasure;
    Double toMeasure;

    // (UPPER(full_name) LIKE '%ML30B%' OR routeid LIKE 'ML30B%' ESCAPE '\') AND beginpoint <= 15 AND endpoint >= 10
    public String toQueryString() {
        return String.format("(UPPER(full_name) LIKE '%%%s%%' OR routeid LIKE '%%%s%%' ESCAPE '\\') AND beginpoint <= %f AND endpoint >= %f",
                routeId.toUpperCase(), routeId.toUpperCase(), toMeasure, fromMeasure);
    }
}
