package com.wydot.wz_datahub.api.models.icone;

import java.time.Instant;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.wydot.wz_datahub.api.models.serialization.instant.InstantFromIsoString;
import com.wydot.wz_datahub.api.models.serialization.instant.InstantToIsoString;

import lombok.Data;

@Data
public class FieldDevicePropertiesIconeCustomLocationDetails {
    @JsonProperty("first_date")
    @JsonSerialize(using = InstantToIsoString.class)
    @JsonDeserialize(using = InstantFromIsoString.class)
    private Instant firstDate;
    @JsonProperty("update_date")
    @JsonSerialize(using = InstantToIsoString.class)
    @JsonDeserialize(using = InstantFromIsoString.class)
    private Instant updateDate;
}
