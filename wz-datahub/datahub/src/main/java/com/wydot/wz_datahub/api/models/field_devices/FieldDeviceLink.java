package com.wydot.wz_datahub.api.models.field_devices;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import wyo.dot.protobuf.FieldDevice;
import wyo.dot.protobuf.FieldDevice.FieldDeviceStatus;

import org.springframework.data.mongodb.core.mapping.Field;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.wydot.wz_datahub.api.models.raw_data.RawDataType;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class FieldDeviceLink {
    @Field("last_updated")
    @JsonProperty("last_updated")
    private Long timestamp;
    @Field("device_id")
    @JsonProperty("device_id")
    private String deviceId;
    @Field("project_id")
    @JsonProperty("project_id")
    private Long projectId;
    @Field("road_event_id")
    @JsonProperty("road_event_id")
    private Long roadEventId;
    @Field("device_status")
    @JsonProperty("device_status")
    private FieldDeviceStatus deviceStatus;
    @Field("data_source")
    @JsonProperty("data_source")
    private RawDataType dataSource;

    public FieldDeviceLink(Long timestamp, FieldDevice device) {
        this.timestamp = timestamp;
        this.deviceId = device.getId();
        if (device.hasProjectId())
            this.projectId = device.getProjectId();
        if (device.hasRoadEventId())
            this.roadEventId = device.getRoadEventId();
        this.deviceStatus = device.getCoreDetails().getDeviceStatus();
        this.dataSource = RawDataType.fromDeviceMake(device.getCoreDetails().getMake());
    }
}
