package com.wydot.message_generator.models.wz.cwz;

import com.fasterxml.jackson.annotation.JsonProperty;

public enum WorkTypeName {
    @JsonProperty("non-encroachment")
    NON_ENCROACHMENT,
    @JsonProperty("minor-road-defect-repair")
    MINOR_ROAD_DEFECT_REPAIR,
    @JsonProperty("roadside-work")
    ROADSIDE_WORK,
    @JsonProperty("overhead-work")
    OVERHEAD_WORK,
    @JsonProperty("below-road-work")
    BELOW_ROAD_WORK,
    @JsonProperty("barrier-work")
    BARRIER_WORK,
    @JsonProperty("surface-work")
    SURFACE_WORK,
    @JsonProperty("painting")
    PAINTING,
    @JsonProperty("roadway-relocation")
    ROADWAY_RELOCATION,
    @JsonProperty("roadway-creation")
    ROADWAY_CREATION,
}
