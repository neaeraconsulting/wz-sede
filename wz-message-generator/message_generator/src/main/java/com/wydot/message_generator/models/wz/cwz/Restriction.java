package com.wydot.message_generator.models.wz.cwz;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Builder;
import lombok.Data;

/**
 * Class representing a restriction in the work zone.
 * 
 * @see <a href=
 *      "https://github.com/usdot-jpo-ode/wzdx/blob/main/spec-content/objects/Restriction.md">Restriction</a>
 */
@Data
@Builder
public class Restriction {
    @JsonProperty("type")
    private RestrictionType type;
    @JsonProperty("value")
    private Float value;
    @JsonProperty("unit")
    private UnitOfMeasurement unit;
}
