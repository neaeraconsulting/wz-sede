package com.wydot.wz_datahub.api.models.recordings;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.wydot.wz_datahub.api.models.reports.EventRecurrence;
import com.wydot.wz_datahub.api.models.serialization.instant.InstantFromMillisDeserializer;
import com.wydot.wz_datahub.api.models.serialization.instant.InstantToMillisSerializer;
import com.wydot.wz_datahub.api.models.wz.con_admin.RoadSurfaceType;
import com.wydot.wz_datahub.api.models.wz.wzdx.RoadwayDirection;
import com.wydot.wz_datahub.api.models.wz.wzdx.TypeOfWork;
import com.wydot.wz_datahub.api.models.wz.wzdx.VehicleImpact;
import com.wydot.wz_datahub.api.models.wz.wzdx.WorkZoneType;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
public class Recording {
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
    @JsonProperty("surface_type")
    private RoadSurfaceType surfaceType;
    @JsonProperty("points")
    private List<RecordingPoint> points;
    @JsonProperty("user_id")
    private String userId;
    @JsonProperty("event_schedule")
    private EventRecurrence eventSchedule;
    @JsonProperty("worker_presence_schedule")
    private EventRecurrence workerPresenceSchedule;
    @JsonProperty("linked_field_device_ids")
    private List<String> linkedFieldDeviceIds;
    @JsonProperty("source_type")
    private RecordingSourceType sourceType = RecordingSourceType.DRIVE; // Default to DRIVE if not provided
}
