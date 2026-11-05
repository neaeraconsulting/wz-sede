package com.wydot.wz_datahub.api.models.wz.device_feed.properties.hybrid_sign;

import com.fasterxml.jackson.annotation.JsonProperty;

public enum HybridSignDynamicMessageFunction {
    @JsonProperty("speed-limit")
    SPEED_LIMIT,
    @JsonProperty("travel-time")
    TRAVEL_TIME,
    @JsonProperty("other")
    OTHER;
}
