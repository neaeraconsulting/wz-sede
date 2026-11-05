package com.wydot.wz_datahub.api.models.reports;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.google.type.LatLng;
import com.wydot.wz_datahub.api.models.serialization.LatLngJsonConverter;
import com.wydot.wz_datahub.api.models.serialization.instant.InstantFromMillisDeserializer;
import com.wydot.wz_datahub.api.models.serialization.instant.InstantToMillisSerializer;
import com.wydot.wz_datahub.api.models.wz.con_admin.GeometryType;
import com.wydot.wz_datahub.api.models.wz.con_admin.RoadSurfaceType;
import com.wydot.wz_datahub.api.models.wz.wzdx.RoadwayDirection;
import com.wydot.wz_datahub.api.models.wz.wzdx.TypeOfWork;
import com.wydot.wz_datahub.api.models.wz.wzdx.VehicleImpact;
import com.wydot.wz_datahub.api.models.wz.wzdx.WorkZoneType;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.LineStringGeometry;
import wyo.dot.protobuf.PointArray;
import wyo.dot.protobuf.PointGeometry;
import wyo.dot.protobuf.PolygonGeometry;
import wyo.dot.protobuf.RoadEvent;
import wyo.dot.protobuf.RoadSubEvent;

import java.time.Instant;
import java.util.List;

@Slf4j
@Data
@AllArgsConstructor
@NoArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
public class Report {
    @JsonProperty("project_id")
    private Long projectId;
    @JsonProperty("road_event_id")
    private Long roadEventId;
    @JsonProperty("name")
    private String name;
    @JsonProperty("description")
    private String description;
    @JsonProperty("types_of_work")
    private List<TypeOfWork> typesOfWork;
    @JsonProperty("road_name")
    private String roadName;
    @JsonProperty("direction")
    private RoadwayDirection direction;
    @JsonProperty("workers_present")
    private Boolean workersPresent;
    @JsonSerialize(using = InstantToMillisSerializer.class)
    @JsonDeserialize(using = InstantFromMillisDeserializer.class)
    @JsonProperty("start_date")
    private Instant startDate;
    @JsonSerialize(using = InstantToMillisSerializer.class)
    @JsonDeserialize(using = InstantFromMillisDeserializer.class)
    @JsonProperty("end_date")
    private Instant endDate;
    @JsonSerialize(using = InstantToMillisSerializer.class)
    @JsonDeserialize(using = InstantFromMillisDeserializer.class)
    @JsonProperty("timestamp")
    private Instant timestamp;
    @JsonProperty("area_type")
    private WorkZoneType areaType;
    @JsonProperty("vehicle_impact")
    private VehicleImpact vehicleImpact;
    @JsonProperty("speed_limit_mph")
    private Float speedLimitMph;
    @JsonProperty("geometry_type")
    private GeometryType geometryType;
    @JsonSerialize(using = LatLngJsonConverter.LatLngListSerializer.class)
    @JsonDeserialize(using = LatLngJsonConverter.LatLngListDeserializer.class)
    @JsonProperty("geometry")
    private List<LatLng> geometry;
    @JsonProperty("geometry_line_width")
    private Float geometryLineWidth;
    @JsonProperty("license_plate")
    private String licensePlate;
    @JsonProperty("surface_type")
    private RoadSurfaceType surfaceType;
    @JsonProperty("user_id")
    private String userId;
    @JsonProperty("event_schedule")
    private EventRecurrence eventSchedule;
    @JsonProperty("worker_presence_schedule")
    private EventRecurrence workerPresenceSchedule;
    @JsonProperty("linked_field_device_ids")
    private List<String> linkedFieldDeviceIds;

    public RoadSubEvent.Builder getRseGeometry(RoadSubEvent.Builder builder) {
        switch (this.getGeometryType()) {
            case GeometryType.MULTIPOINT:
                builder.setPoint(PointGeometry.newBuilder()
                        .setCoordinates(this.geometry.getFirst()));
                break;
            case GeometryType.LINESTRING:
                builder.setLineString(LineStringGeometry.newBuilder()
                        .setCoordinates(PointArray.newBuilder()
                                .addAllCoordinates(this.geometry)));
                break;
            case GeometryType.POLYGON:
                builder.setPolygon(PolygonGeometry.newBuilder()
                        .setCoordinates(PointArray.newBuilder()
                                .addAllCoordinates(this.geometry)));
                break;
        }
        return builder;
    }

    public RoadEvent.Builder getReGeometry(RoadEvent.Builder builder) {
        switch (this.getGeometryType()) {
            case GeometryType.MULTIPOINT:
                builder.setPoint(PointGeometry.newBuilder()
                        .setCoordinates(this.geometry.getFirst()));
                break;
            case GeometryType.LINESTRING:
                builder.setLineString(LineStringGeometry.newBuilder()
                        .setCoordinates(PointArray.newBuilder()
                                .addAllCoordinates(this.geometry)));
                break;
            case GeometryType.POLYGON:
                builder.setPolygon(PolygonGeometry.newBuilder()
                        .setCoordinates(PointArray.newBuilder()
                                .addAllCoordinates(this.geometry)));
                break;
        }
        return builder;
    }
}
