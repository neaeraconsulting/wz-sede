package com.wydot.wz_datahub.api.models.reports;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.google.type.LatLng;
import com.wydot.wz_datahub.api.models.gis_service.RouteAndMeasure;
import com.wydot.wz_datahub.api.models.gis_service.RouteAndMeasureRange;
import com.wydot.wz_datahub.api.models.serialization.LatLngJsonConverter;
import com.wydot.wz_datahub.api.models.serialization.instant.InstantFromMillisDeserializer;
import com.wydot.wz_datahub.api.models.serialization.instant.InstantToMillisSerializer;
import com.wydot.wz_datahub.api.models.wz.wzdx.RoadwayDirection;
import com.wydot.wz_datahub.api.models.wz.wzdx.TypeOfWork;
import com.wydot.wz_datahub.api.utilities.gis_service.GisService;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.LineStringGeometry;
import wyo.dot.protobuf.PointArray;
import wyo.dot.protobuf.RoadEvent;
import wyo.dot.protobuf.RoadSubEvent;

import java.time.Instant;
import java.util.List;

@Slf4j
@Data
@AllArgsConstructor
@NoArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
public class ReportPatch {
    @NotNull
    @JsonProperty("id")
    private Long id;
    @NotNull
    @JsonProperty("road_event_id")
    private Long roadEventId;
    @NotNull
    @JsonSerialize(using = InstantToMillisSerializer.class)
    @JsonDeserialize(using = InstantFromMillisDeserializer.class)
    @JsonProperty("timestamp")
    private Instant timestamp;
    @NotNull
    @JsonProperty("user_id")
    private String userId;

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
    @JsonSerialize(using = InstantToMillisSerializer.class)
    @JsonDeserialize(using = InstantFromMillisDeserializer.class)
    @JsonProperty("start_date")
    private Instant startDate;
    @JsonSerialize(using = InstantToMillisSerializer.class)
    @JsonDeserialize(using = InstantFromMillisDeserializer.class)
    @JsonProperty("end_date")
    private Instant endDate;
    @JsonSerialize(using = LatLngJsonConverter.LatLngListSerializer.class)
    @JsonDeserialize(using = LatLngJsonConverter.LatLngListDeserializer.class)
    @JsonProperty("geometry")
    private List<LatLng> geometry;
    @JsonProperty("license_plate")
    private String licensePlate;
    @JsonProperty("event_schedule")
    private EventRecurrence eventSchedule;
    @JsonProperty("linked_field_device_ids")
    private List<String> linkedFieldDeviceIds;

    public static ReportPatch fromReportWithId(ReportWithId report) {
        return new ReportPatch(
                report.getId(),
                report.getRoadEventId(),
                report.getTimestamp(),
                report.getUserId(),
                report.getName(),
                report.getDescription(),
                report.getTypesOfWork(),
                report.getRoadName(),
                report.getDirection(),
                report.getStartDate(),
                report.getEndDate(),
                report.getGeometry(),
                report.getLicensePlate(),
                report.getEventSchedule(),
                report.getLinkedFieldDeviceIds());
    }

    public ReportWithId toReportWithId() {
        return new ReportWithId(
                this.id,
                new Report(
                        null,
                        this.roadEventId,
                        this.name,
                        this.description,
                        this.typesOfWork,
                        this.roadName,
                        this.direction,
                        null,
                        this.startDate,
                        this.endDate,
                        this.timestamp,
                        null,
                        null,
                        null,
                        null,
                        this.geometry,
                        null,
                        this.licensePlate,
                        null,
                        this.userId,
                        this.eventSchedule,
                        null,
                        this.linkedFieldDeviceIds));
    }

    public RoadSubEvent.Builder getRseGeometry(RoadSubEvent.Builder builder) {
        builder.setLineString(LineStringGeometry.newBuilder()
                .setCoordinates(PointArray.newBuilder()
                        .addAllCoordinates(this.geometry)));
        return builder;
    }

    public RoadEvent.Builder getReGeometry(RoadEvent.Builder builder) {
        builder.setLineString(LineStringGeometry.newBuilder()
                .setCoordinates(PointArray.newBuilder()
                        .addAllCoordinates(this.geometry)));
        return builder;
    }

    public RouteAndMeasureRange getRouteAndMeasureRangeWithDefault(GisService gisService,
            RouteAndMeasureRange defaultRange) {
        if (this.getGeometry() == null || this.getGeometry().isEmpty()) {
            return defaultRange;
        }

        RouteAndMeasure startRouteAndMeasure = gisService
                .getClosestRouteAndMeasure(this.getGeometry().getFirst(), 100).block();
        RouteAndMeasure endRouteAndMeasure = gisService
                .getClosestRouteAndMeasure(this.getGeometry().getLast(), 100).block();

        if (startRouteAndMeasure == null || endRouteAndMeasure == null) {
            return defaultRange;
        }
        return RouteAndMeasureRange.fromMeasures(startRouteAndMeasure, endRouteAndMeasure);
    }
}
