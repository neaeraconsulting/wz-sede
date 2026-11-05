package com.wydot.wz_datahub.api.models.wrappers;

import java.time.Instant;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class RoadEventUpdateStatus {
    @JsonProperty("source_type")
    private SourceType sourceType;
    @JsonProperty("approval_status")
    private ApprovalStatus approvalStatus;
    @JsonProperty("event_status")
    private EventStatus eventStatus;
    @JsonProperty("update_submitted_timestamp")
    private Instant updateSubmittedTimestamp;
    @JsonProperty("update_review_timestamp")
    private Instant updateReviewTimestamp; // can be null if not reviewed yet
    @JsonProperty("source")
    private Object source; // can be a Report, Recording, MobileVehicleReport, or MobileWorkerReport

    public enum SourceType {
        REPORT, RECORDING, MOBILE_VEHICLE, MOBILE_WORKER, CON_ADMIN
    }

    public enum ApprovalStatus {
        APPROVED, AUTO_APPROVED, REJECTED, PENDING
    }

    public enum EventStatus {
        ERROR, NOT_CREATED, UPCOMING, ONGOING, COMPLETED
    }
}
