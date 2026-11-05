package com.wydot.message_generator.models.wz.device_feed;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.wydot.message_generator.models.wz.cwz.FeedInfo;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class DeviceFeed {
    @JsonProperty("feed_info")
    private FeedInfo feedInfo;
    @JsonProperty("type")
    private String type;
    @JsonProperty("features")
    private List<FieldDeviceFeature> features;
    @JsonProperty("bbox")
    private List<Double> bbox;
}
