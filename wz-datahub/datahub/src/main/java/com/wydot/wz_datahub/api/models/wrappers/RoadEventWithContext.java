package com.wydot.wz_datahub.api.models.wrappers;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.wydot.wz_datahub.api.models.recordings.Recording;
import com.wydot.wz_datahub.api.models.reports.Report;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import wyo.dot.protobuf.FieldDevice;
import wyo.dot.protobuf.Project;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class RoadEventWithContext {
    @JsonProperty("road_event")
    private RoadEventWrapper roadEvent;
    @JsonProperty("project")
    private Project project;
    @JsonProperty("field_devices")
    private List<FieldDevice> fieldDevices;
    @JsonProperty("report")
    private Report report;
    @JsonProperty("recording")
    private Recording recording;
}
