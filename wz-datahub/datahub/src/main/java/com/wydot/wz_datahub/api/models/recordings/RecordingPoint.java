package com.wydot.wz_datahub.api.models.recordings;

import lombok.Data;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.google.type.LatLng;

@Data
public class RecordingPoint {
    @JsonProperty("timestamp")
    private long timestamp;
    @JsonProperty("num_satellites")
    private int numSatellites;
    @JsonProperty("accuracy")
    private float accuracy;
    @JsonProperty("latitude")
    private float latitude;
    @JsonProperty("longitude")
    private float longitude;
    @JsonProperty("altitude")
    private float altitude;
    @JsonProperty("speed")
    private float speed;
    @JsonProperty("heading")
    private float heading;
    @JsonProperty("marking")
    private RecordingMarking marking;

    public LatLng latLng() {
        return LatLng.newBuilder()
                .setLatitude(latitude)
                .setLongitude(longitude)
                .build();
    }
}
