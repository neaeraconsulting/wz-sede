package com.wydot.wz_datahub.api.models.wanco;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import com.wydot.wz_datahub.api.models.wanco.sabp.WancoDeviceFeedSABP;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, include = JsonTypeInfo.As.PROPERTY, property = "format")
@JsonSubTypes({
        @JsonSubTypes.Type(value = WancoDeviceFeedWZDx42.class, name = "WZDx4.2"),
        @JsonSubTypes.Type(value = WancoDeviceFeedSABP.class, name = "SABP")
})
public class WancoDeviceFeed {
    @JsonProperty("source")
    private String source;
    @JsonProperty("version")
    private String version;
    @JsonProperty("format")
    private WancoFeedFormatType format;
    @JsonProperty("time")
    private String time;
    @JsonProperty("endpoint")
    private String endpoint;
    @JsonProperty("continued")
    private String continued;
}