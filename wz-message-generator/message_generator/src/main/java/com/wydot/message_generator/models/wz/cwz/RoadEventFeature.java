package com.wydot.message_generator.models.wz.cwz;

import lombok.Builder;
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
@Builder
public class RoadEventFeature {
    @JsonProperty("id")
    private String id;
    @JsonProperty("type")
    private final String type = "Feature";
    @JsonProperty("properties")
    private WorkZoneRoadEvent properties;
    @JsonProperty("geometry")
    private Geometry<?> geometry;
    @JsonProperty("bbox")
    private List<Double> bbox;
}
