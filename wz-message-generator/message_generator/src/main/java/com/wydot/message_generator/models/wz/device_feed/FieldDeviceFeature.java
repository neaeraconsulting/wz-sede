package com.wydot.message_generator.models.wz.device_feed;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.wydot.message_generator.models.wz.device_feed.properties.FieldDeviceProperties;
import com.wydot.message_generator.models.wz.device_feed.properties.FieldDevicePropertiesDeserializer;
import com.wydot.message_generator.models.wz.cwz.geometry.GeoJsonGeometry;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class FieldDeviceFeature {
    @JsonProperty("id")
    private String id; // Unique identifier (UUID)
    @JsonProperty("type")
    private String type; // MUST be "Feature"
    @JsonProperty("properties")
    @JsonDeserialize(using = FieldDevicePropertiesDeserializer.class)
    private FieldDeviceProperties properties; // Specific details of the field device (ArrowBoard, Camera, etc.)
    @JsonProperty("geometry")
    private GeoJsonGeometry geometry; // GeoJSON Geometry object (type MUST be Point)
    @JsonProperty("bbox")
    private List<Double> bbox; // Optional GeoJSON Bounding Box (array of coordinates)
}