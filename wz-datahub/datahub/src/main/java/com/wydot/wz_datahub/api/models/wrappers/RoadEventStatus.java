package com.wydot.wz_datahub.api.models.wrappers;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class RoadEventStatus {
    @JsonProperty("road_event")
    private RoadEventWrapper roadEvent;
    @JsonProperty("updates")
    private List<RoadEventUpdateStatus> updates;
}
