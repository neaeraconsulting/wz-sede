package com.wydot.wz_datahub.api.models.icone;

import java.time.Instant;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.wydot.wz_datahub.api.models.serialization.instant.InstantFromIsoString;
import com.wydot.wz_datahub.api.models.serialization.instant.InstantToIsoString;

import lombok.Data;

@Data
public class FieldDevicePropertiesIconeCustom {
    @JsonProperty("isPublic")
    private Boolean isPublic;
    @JsonProperty("isActive")
    private Boolean isActive;
    @JsonProperty("voltage")
    private Double voltage;
    @JsonProperty("start_date")
    @JsonSerialize(using = InstantToIsoString.class)
    @JsonDeserialize(using = InstantFromIsoString.class)
    private Instant startDate;
    @JsonProperty("location_details")
    private FieldDevicePropertiesIconeCustomLocationDetails locationDetails;
}
