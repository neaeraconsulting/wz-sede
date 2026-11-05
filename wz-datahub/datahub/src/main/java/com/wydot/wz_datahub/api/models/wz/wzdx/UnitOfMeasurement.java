package com.wydot.wz_datahub.api.models.wz.wzdx;

import com.fasterxml.jackson.annotation.JsonProperty;

// Value	Description
// feet	Imperial system 'feet'
// inches	Imperial system 'inches'
// centimeters	Metric system 'centimeters'
// pounds	Imperial system 'pounds'
// tons	Imperial system 'tons'
// kilograms	Metric system 'kilograms'

/**
 * Enum representing a unit of measurement
 * 
 * @see <a href=
 *      "https://github.com/usdot-jpo-ode/wzdx/blob/main/spec-content/enumerated-types/UnitOfMeasurement.md">UnitOfMeasurement</a>
 */
public enum UnitOfMeasurement {
    @JsonProperty("feet")
    FEET,
    @JsonProperty("inches")
    INCHES,
    @JsonProperty("centimeters")
    CENTIMETERS,
    @JsonProperty("pounds")
    POUNDS,
    @JsonProperty("tons")
    TONS,
    @JsonProperty("kilograms")
    KILOGRAMS;
}
