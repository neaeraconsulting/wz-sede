package com.wydot.wz_datahub.api.models.wz.device_feed.properties;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.wydot.wz_datahub.api.models.wz.device_feed.FieldDeviceCoreDetails;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public abstract class FieldDeviceProperties {
    @JsonProperty("core_details")
    private FieldDeviceCoreDetails coreDetails;
}