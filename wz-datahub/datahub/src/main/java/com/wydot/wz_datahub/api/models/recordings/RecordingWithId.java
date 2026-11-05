package com.wydot.wz_datahub.api.models.recordings;

import org.springframework.data.mongodb.core.mapping.Document;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@Document(collection = "datahub.recordings")
public class RecordingWithId extends Recording {
    @JsonProperty("id")
    private Long id;

    // Default constructor required by Spring Data
    public RecordingWithId() {
        super();
    }

    public RecordingWithId(Long id, Recording recording) {
        super(
                recording.getProjectId(),
                recording.getRoadEventId(),
                recording.getName(),
                recording.getDescription(),
                recording.getTypesOfWork(),
                recording.getRoadName(),
                recording.getDirection(),
                recording.getStartDate(),
                recording.getEndDate(),
                recording.getTimestamp(),
                recording.getAreaType(),
                recording.getVehicleImpact(),
                recording.getSurfaceType(),
                recording.getPoints(),
                recording.getUserId(),
                recording.getEventSchedule(),
                recording.getWorkerPresenceSchedule(),
                recording.getLinkedFieldDeviceIds(),
                recording.getSourceType());
        this.id = id;
    }
}
