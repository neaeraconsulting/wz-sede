package com.wydot.wz_datahub.api.models.wz.device_feed;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.wydot.wz_datahub.api.models.wz.wzdx.FeedInfo;

import lombok.Data;

@Data
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
