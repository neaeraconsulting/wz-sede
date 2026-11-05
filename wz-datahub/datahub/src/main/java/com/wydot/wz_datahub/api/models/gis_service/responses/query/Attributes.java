package com.wydot.wz_datahub.api.models.gis_service.responses.query;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Attributes {
    @JsonProperty("routeid")
    private String routeId;

    @JsonProperty("beginpoint")
    private Double beginPoint;

    @JsonProperty("endpoint")
    private Double endpoint;

    @JsonProperty("full_name")
    private String fullName;

    @JsonProperty("roadway_name_type")
    private String roadwayNameType;

    @JsonProperty("objectid")
    private Integer objectId;
}
