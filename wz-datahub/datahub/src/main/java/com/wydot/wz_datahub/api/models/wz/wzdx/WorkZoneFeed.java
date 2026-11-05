package com.wydot.wz_datahub.api.models.wz.wzdx;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.util.List;

/**
 * Class representing a WZDx work zone feed
 * 
 * @see <a href=
 *      "https://github.com/usdot-jpo-ode/wzdx/blob/develop/spec-content/objects/WorkZoneFeed.md">WorkZoneFeed.md</a>
 */
@Data
public class WorkZoneFeed {
    @JsonProperty("feed_info")
    private FeedInfo feedInfo;
    @JsonProperty("type")
    private String type;
    @JsonProperty("features")
    private List<RoadEventFeature> features;
    @JsonProperty("bbox")
    private List<Double> bbox;
}
