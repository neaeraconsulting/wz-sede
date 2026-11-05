package com.wydot.wz_datahub.api.models.wz.cwz;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.wydot.wz_datahub.api.models.wz.wzdx.FeedInfo;
import com.wydot.wz_datahub.api.models.wz.wzdx.WorkZoneRoadEvent;
import lombok.Data;

import java.util.List;

@Data
public class CwzFeed {
    @JsonProperty("feed_info")
    private FeedInfo feedInfo;
    @JsonProperty("type")
    private String type;
    @JsonProperty("features")
    private List<WorkZoneRoadEvent> features;
    @JsonProperty("bbox")
    private List<Double> bbox;
}
