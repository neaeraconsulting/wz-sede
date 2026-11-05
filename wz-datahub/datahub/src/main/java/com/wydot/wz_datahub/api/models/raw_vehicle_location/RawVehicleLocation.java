package com.wydot.wz_datahub.api.models.raw_vehicle_location;

import java.time.Instant;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class RawVehicleLocation {
    @JsonProperty("recId")
    private String recordId;

    @JsonProperty("title")
    private String title;

    @JsonProperty("unitId")
    private String unitId;

    @JsonProperty("localTime")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss", timezone = "America/Denver")
    private Instant localTime; // Sender's local time (Mountain Time), stored as UTC Instant

    @JsonProperty("vgroup")
    private String vehicleGroup; // can be null

    @JsonProperty("latitude")
    private Double latitude; // in degrees

    @JsonProperty("longitude")
    private Double longitude; // in degrees

    @JsonProperty("altitude")
    private Double altitude; // in meters

    @JsonProperty("speed")
    private Double speed; // in km/h

    @JsonProperty("heading")
    private Double heading; // in degrees, 0-360

    @JsonProperty("plowUp")
    private Boolean plowUp; // true if plow is up, false if down

    @JsonProperty("sander")
    private Boolean sander; // true if sander is on, false if off

    @JsonProperty("source")
    private String source; // source of the data, e.g., "TABLET", "GPS", etc.
}