package com.wydot.wz_datahub.api.controllers.kafka;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Controller;

import com.wydot.wz_datahub.api.accessors.road_event.RoadEventRepository;
import com.wydot.wz_datahub.api.kafka.KafkaTopics;
import com.wydot.wz_datahub.api.models.reports.ReportPatch;
import com.wydot.wz_datahub.api.models.reports.ReportWithId;
import com.wydot.wz_datahub.api.models.reports.WorkerPresenceReport;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventWrapper;
import com.wydot.wz_datahub.api.update_processors.ReportUpdateProcessor;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.DataHubRoadEventUpdate;

@Controller
@Slf4j
@RequiredArgsConstructor
public class ReportUpdateController {
    private final ReportUpdateProcessor reportUpdateProcessor;
    private final RoadEventRepository roadEventRepository;

    @Autowired
    private KafkaTemplate<String, DataHubRoadEventUpdate> template;

    public Long createNewRoadEvent(ReportWithId report) {
        DataHubRoadEventUpdate updateMessage = reportUpdateProcessor.createDataHubRoadEventFromReport(report);
        Long roadEventId = null;
        if (updateMessage != null) {
            this.template.send(KafkaTopics.DATAHUB_ROAD_EVENT, String.valueOf(updateMessage.getRequestId()),
                    updateMessage);
            return updateMessage.getCreated().getRoadEvent().getId();
        } else {
            log.warn("Failed to create DataHubRoadEventUpdate from report: {}", report);
        }
        return roadEventId;
    }

    public Long updateRoadEvent(ReportPatch report) {
        // If the report does not have a road event ID, try to find it from the
        // repository
        log.info("Handling report update for report ID {}", report.getId());

        // If the report has a road event ID, try to find it from the repository
        RoadEventWrapper roadEventWrapper = roadEventRepository
                .findOne(report.getRoadEventId(), null, null, null, null, null, null, null);
        if (roadEventWrapper == null) {
            log.warn("No road event found for ID {}. Cannot update road event. Creating new road event",
                    report.getRoadEventId());
            throw new IllegalStateException("No road event found for ID " + report.getRoadEventId());
        }

        // Create the update message
        DataHubRoadEventUpdate updateMessage = reportUpdateProcessor.updateDataHubRoadEventFromReport(report,
                roadEventWrapper);
        log.info("Creating update message for report ID {}", report.getId());
        if (updateMessage != null) {
            this.template.send(KafkaTopics.DATAHUB_ROAD_EVENT, String.valueOf(updateMessage.getRequestId()),
                    updateMessage);
        } else {
            log.warn("Failed to create DataHubRoadEventUpdate from report: {}", report);
        }
        return roadEventWrapper.getRoadEvent().getId();
    }

    public Long updateRoadEventWorkerPresence(WorkerPresenceReport report) {
        // If the report does not have a road event ID, try to find it from the
        // repository
        log.info("Handling worker presence report update for report with road event ID {}", report.getRoadEventId());

        // If the report has a road event ID, try to find it from the repository
        RoadEventWrapper roadEventWrapper = roadEventRepository
                .findOne(report.getRoadEventId(), null, null, null, null, null, null, null);
        if (roadEventWrapper == null) {
            log.warn(
                    "No road event found for ID {}. Cannot update road event with worker presence. Creating new road event",
                    report.getRoadEventId());
            throw new IllegalStateException("No road event found for ID " + report.getRoadEventId());
        }

        // Create the update message
        DataHubRoadEventUpdate updateMessage = reportUpdateProcessor.updateDataHubRoadEventFromWorkerPresenceReport(
                report,
                roadEventWrapper);
        log.info("Creating worker presence update message for report with road event ID {}", report.getRoadEventId());
        if (updateMessage != null) {
            this.template.send(KafkaTopics.DATAHUB_ROAD_EVENT, String.valueOf(updateMessage.getRequestId()),
                    updateMessage);
        } else {
            log.warn("Failed to create DataHubRoadEventUpdate worker presence update from report: {}", report);
        }
        return roadEventWrapper.getRoadEvent().getId();
    }
}
