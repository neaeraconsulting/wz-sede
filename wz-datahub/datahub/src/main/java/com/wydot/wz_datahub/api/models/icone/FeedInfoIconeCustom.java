package com.wydot.wz_datahub.api.models.icone;

import java.time.Instant;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.wydot.wz_datahub.api.models.serialization.instant.InstantFromIsoString;
import com.wydot.wz_datahub.api.models.serialization.instant.InstantToIsoString;

import lombok.Data;

@Data
public class FeedInfoIconeCustom {
    @JsonProperty("oldest_feature")
    @JsonSerialize(using = InstantToIsoString.class)
    @JsonDeserialize(using = InstantFromIsoString.class)
    private Instant oldestFeature;
    @JsonProperty("oldest_location")
    @JsonSerialize(using = InstantToIsoString.class)
    @JsonDeserialize(using = InstantFromIsoString.class)
    private Instant oldestLocation;
    @JsonProperty("username")
    private String username;
    @JsonProperty("active_only")
    private Boolean activeOnly;
    @JsonProperty("require_location")
    private Boolean requireLocation;
    @JsonProperty("allow_custom_enums")
    private Boolean allowCustomEnums;
    @JsonProperty("include_custom")
    private Boolean includeCustom;
    @JsonProperty("force_spec_required")
    private Boolean forceSpecRequired;
}
