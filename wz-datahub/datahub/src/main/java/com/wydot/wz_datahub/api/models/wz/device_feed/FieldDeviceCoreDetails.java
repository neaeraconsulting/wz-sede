package com.wydot.wz_datahub.api.models.wz.device_feed;

import java.time.Instant;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.wydot.wz_datahub.api.models.serialization.instant.InstantFromIsoString;
import com.wydot.wz_datahub.api.models.wz.wzdx.RoadwayDirection;

import lombok.Data;

@Data
public class FieldDeviceCoreDetails {
    @JsonProperty("device_type")
    private FieldDeviceType deviceType; // The type of field device (Required)

    @JsonProperty("data_source_id")
    private String dataSourceId; // Identifies the data source from which the field device data originates
                                 // (Required)

    @JsonProperty("device_status")
    private FieldDeviceStatus deviceStatus; // The operational status of the field device (Required)

    @JsonProperty("update_date")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss'Z'", timezone = "UTC")
    @JsonDeserialize(using = InstantFromIsoString.class)
    private Instant updateDate; // The UTC time and date when the field device information was updated
                                // (Required)

    @JsonProperty("has_automatic_location")
    private Boolean hasAutomaticLocation; // Indicates if the field device location is determined automatically
                                          // (Required)

    @JsonProperty("road_direction")
    private RoadwayDirection roadDirection; // The direction of the road the field device is on (Optional)

    @JsonProperty("road_names")
    private List<String> roadNames; // A list of publicly known names of the road (Optional)

    @JsonProperty("name")
    private String name; // A human-readable name for the field device (Optional)

    @JsonProperty("description")
    private String description; // A description of the field device (Optional)

    @JsonProperty("status_messages")
    private List<String> statusMessages; // Messages associated with the device's status (Optional)

    @JsonProperty("is_moving")
    private Boolean isMoving; // Indicates if the device is actively moving (Optional)

    @JsonProperty("road_event_ids")
    private List<String> roadEventIds; // IDs of RoadEventFeature associated with the device (Optional)

    @JsonProperty("milepost")
    private Double milepost; // The linear distance measured against a milepost marker (Optional)

    @JsonProperty("make")
    private String make; // The make or manufacturer of the device (Optional)

    @JsonProperty("model")
    private String model; // The model of the device (Optional)

    @JsonProperty("serial_number")
    private String serialNumber; // The serial number of the device (Optional)

    @JsonProperty("firmware_version")
    private String firmwareVersion; // The version of firmware the device is using (Optional)

    @JsonProperty("velocity_kph")
    private Double velocityKph; // The velocity of the device in kilometers per hour (Optional)
}
