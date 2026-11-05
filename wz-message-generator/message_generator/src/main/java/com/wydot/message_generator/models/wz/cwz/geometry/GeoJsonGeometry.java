package com.wydot.message_generator.models.wz.cwz.geometry;

import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import lombok.Data;

@Data
@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, include = JsonTypeInfo.As.PROPERTY, property = "type")
@JsonSubTypes({
        @JsonSubTypes.Type(value = GeoJsonPoint.class, name = "Point"),
        @JsonSubTypes.Type(value = GeoJsonLineString.class, name = "LineString"),
        @JsonSubTypes.Type(value = GeoJsonPolygon.class, name = "Polygon")
})
public abstract class GeoJsonGeometry {
    // Base class for GeoJSON geometry types
}