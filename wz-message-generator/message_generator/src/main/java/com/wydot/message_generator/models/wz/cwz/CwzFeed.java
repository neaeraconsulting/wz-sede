package com.wydot.message_generator.models.wz.cwz;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;

import java.util.List;

/**
 * Class representing a CWZ work zone feed
 * 
 */
@Data
@Builder
public class CwzFeed {
    @JsonProperty("feed_info")
    private FeedInfo feedInfo;
    @JsonProperty("type")
    private final String type = "FeatureCollection";
    @JsonProperty("features")
    private List<RoadEventFeature> features;
    @JsonProperty("bbox")
    private List<Double> bbox;
}
