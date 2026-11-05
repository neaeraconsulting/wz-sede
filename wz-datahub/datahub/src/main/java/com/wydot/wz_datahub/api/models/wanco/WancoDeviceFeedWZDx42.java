package com.wydot.wz_datahub.api.models.wanco;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.wydot.wz_datahub.api.models.wz.device_feed.DeviceFeed;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
@EqualsAndHashCode(callSuper = true)
public class WancoDeviceFeedWZDx42 extends WancoDeviceFeed {
    @JsonProperty("data")
    private DeviceFeed data;
}