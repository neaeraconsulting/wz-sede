package com.wydot.wz_datahub.api.models.icone;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

import lombok.Data;

import java.util.List;

// Example:
// <location>
// <direction>ONE_DIRECTION</direction>
// <polyline>42.1238782,-76.2710492,42.1238782,-76.2710492</polyline>
// </location>

@Data
public class IconeLocation {
    private IconeDirection direction;

    @JsonProperty("polyline")
    @JsonDeserialize(using = PolylineDeserializer.class)
    private List<Double> polyline;
}
