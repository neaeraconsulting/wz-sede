package com.wydot.wz_datahub.api.models.appversion;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class AppVersionResponse {
    @JsonProperty("minimum_version")
    private String minimumVersion;

    @JsonProperty("latest_version")
    private String latestVersion;
}
