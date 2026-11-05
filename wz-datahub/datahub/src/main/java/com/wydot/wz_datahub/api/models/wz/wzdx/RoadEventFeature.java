package com.wydot.wz_datahub.api.models.wz.wzdx;

import lombok.Data;
import org.geojson.Geometry;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

/**
 * Class representing the road event feature object
 * 
 * @see <a href=
 *      "https://github.com/usdot-jpo-ode/wzdx/blob/main/spec-content/objects/RoadEventFeature.md">RoadEventFeature</a>
 */
@Data
public class RoadEventFeature {
    @JsonProperty("id")
    private String id;
    @JsonProperty("type")
    private String type;
    @JsonProperty("properties")
    private WorkZoneRoadEvent properties;
    @JsonProperty("geometry")
    private Geometry<?> geometry;
    @JsonProperty("bbox")
    private List<Double> bbox;
}
