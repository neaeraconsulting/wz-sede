package com.wydot.wz_datahub.api.controllers.kafka;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.wydot.wz_datahub.api.ProtobufUtils;
import com.wydot.wz_datahub.api.accessors.road_event.RoadEventAuditRepository;
import com.wydot.wz_datahub.api.accessors.road_event.RoadEventRepository;
import com.wydot.wz_datahub.api.kafka.KafkaTopics;
import com.wydot.wz_datahub.api.models.update_processing.Observation;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventAudit;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventUpdateStatus;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventWrapper;
import com.wydot.wz_datahub.api.models.wrappers.RoadSubEventWrapper;
import com.wydot.wz_datahub.api.update_processors.AuditBus;
import com.wydot.wz_datahub.api.update_processors.UpdateProcessorUtils;
import com.wydot.wz_datahub.api.utilities.gis_service.GisService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;
import wyo.dot.protobuf.DataHubRoadEventUpdate;
import wyo.dot.protobuf.RoadEvent;
import wyo.dot.protobuf.RoadSubEvent;
import wyo.dot.protobuf.conadmin.ConAdminRoadEventUpdate;

@RestController
@Slf4j
@RequestMapping("/kafka")
@RequiredArgsConstructor
public class RoadEventUpdateController {
    private final RoadEventAuditRepository roadEventAuditRepository;
    private final RoadEventRepository roadEventRepository;
    private final GisService gisService;
    private final AuditBus auditBus;

    @Autowired
    private KafkaTemplate<String, DataHubRoadEventUpdate> template;

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @PostMapping("/road_events")
    public Mono<Void> submitRoadEventUpdate(@RequestBody DataHubRoadEventUpdate request) {
        this.template.send(KafkaTopics.DATAHUB_ROAD_EVENT, String.valueOf(request.getRequestId()), request);
        return Mono.empty();
    }

    public void handleRoadEventUpdate(ConAdminRoadEventUpdate update) {
        log.info("Received road event update: {}", update.getRequestId());

        switch (update.getTypeCase()) {
            case CREATED:
                handleRoadEventCreated(update);
                break;
            case UPDATED:
                handleRoadEventUpdated(update);
                break;
            case REMOVED:
                handleRoadEventRemoved(update);
                break;
            default:
                log.warn("Received unrecognized road event update: {}", update.getRequestId());
        }
    }

    private void handleRoadEventCreated(ConAdminRoadEventUpdate update) {
        RoadEvent roadEvent = update.getCreated().getRoadEvent();
        List<RoadSubEventWrapper> roadSubEvents = update.getCreated().getRoadSubEventsList().stream()
                .map((RoadSubEvent v) -> new RoadSubEventWrapper(v, List.of(), gisService))
                .collect(Collectors.toList());

        RoadEventUpdateStatus updateStatus = new RoadEventUpdateStatus(
                RoadEventUpdateStatus.SourceType.CON_ADMIN,
                RoadEventUpdateStatus.ApprovalStatus.APPROVED,
                UpdateProcessorUtils.determineEventStatus(roadEvent),
                ProtobufUtils.instantFromTimestamp(update.getTimestamp()),
                ProtobufUtils.instantFromTimestamp(update.getTimestamp()),
                update.getTypeCase().toString());
        RoadEventWrapper roadEventWrapper = new RoadEventWrapper(roadEvent, roadSubEvents,
                List.of(), ProtobufUtils.instantFromTimestamp(update.getTimestamp()), null, List.of(updateStatus));
        List<Observation<?>> observations = Observation.fromConAdmin(roadEventWrapper, roadSubEvents);
        roadEventWrapper.setObservations(observations);

        RoadEventAudit audit = new RoadEventAudit();
        audit.setRoadEventId(roadEventWrapper.getRoadEvent().getId());
        audit.setUpdatedRoadEventContext(UpdateProcessorUtils.contextFromWrapper(roadEventWrapper));
        audit.setPreviousRoadEventContext(null);
        audit.setRoadEventUpdateMessage(null);
        audit.setConAdminUpdateMessage(update);
        audit.setConAdminApprovalMessage(null);
        audit.setChanges(null);
        audit.setRequestId(update.getRequestId());
        audit.setTimestamp(Instant.now().toEpochMilli());
        auditBus.startSession(audit.getRoadEventId(), audit.getUpdatedRoadEventContext().getRoadEvent());

        auditBus.submitAudit(audit.getRoadEventId(), audit);

        roadEventRepository.update(roadEvent.getId(), roadEventWrapper);
    }

    private void handleRoadEventUpdated(ConAdminRoadEventUpdate update) {
        Long roadEventId = update.getUpdated().getRoadEvent().getId();
        RoadEvent roadEvent = update.getUpdated().getRoadEvent();
        List<RoadSubEventWrapper> roadSubEvents = update.getUpdated().getRoadSubEventsList().stream()
                .map((v) -> new RoadSubEventWrapper(v, List.of(), gisService))
                .collect(Collectors.toList());

        RoadEventAudit prevAudit = roadEventAuditRepository.findLatest(roadEventId, null, null, null);

        if (prevAudit != null) {
            auditBus.startSession(roadEventId, prevAudit.getUpdatedRoadEventContext().getRoadEvent());
        } else {
            auditBus.startSession(roadEventId, null);
        }
        List<RoadEventUpdateStatus> existingStatuses = prevAudit != null
                ? prevAudit.getUpdatedRoadEventContext().getRoadEvent().getUpdateHistory()
                : new ArrayList<>();

        RoadEventUpdateStatus updateStatus = new RoadEventUpdateStatus(
                RoadEventUpdateStatus.SourceType.CON_ADMIN,
                RoadEventUpdateStatus.ApprovalStatus.APPROVED,
                UpdateProcessorUtils.determineEventStatus(roadEvent),
                ProtobufUtils.instantFromTimestamp(update.getTimestamp()),
                ProtobufUtils.instantFromTimestamp(update.getTimestamp()),
                update.getTypeCase().toString());
        existingStatuses.add(updateStatus);
        RoadEventWrapper roadEventWrapper = new RoadEventWrapper(roadEvent, roadSubEvents,
                List.of(), ProtobufUtils.instantFromTimestamp(update.getTimestamp()), null, existingStatuses);

        List<Observation<?>> observations = new ArrayList<>(); // TODO: Lookup previous observations
        observations.addAll(Observation.fromConAdmin(roadEventWrapper, roadSubEvents));
        // TODO: Handle diff of existing data to ensure no links are lost

        RoadEventAudit newAudit = new RoadEventAudit();
        newAudit.setRoadEventId(roadEventWrapper.getRoadEvent().getId());
        newAudit.setUpdatedRoadEventContext(UpdateProcessorUtils.contextFromWrapper(roadEventWrapper));
        newAudit.setPreviousRoadEventContext(prevAudit != null ? prevAudit.getUpdatedRoadEventContext() : null);
        newAudit.setRoadEventUpdateMessage(null);
        newAudit.setConAdminUpdateMessage(update);
        newAudit.setConAdminApprovalMessage(null);
        newAudit.setChanges(null);
        newAudit.setRequestId(update.getRequestId());
        newAudit.setTimestamp(Instant.now().toEpochMilli());

        auditBus.submitAudit(roadEventId, newAudit);

        roadEventRepository.update(roadEventId, roadEventWrapper);
    }

    private void handleRoadEventRemoved(ConAdminRoadEventUpdate update) {
        Long roadEventId = update.getRemoved().getRoadEventId();

        RoadEventAudit prevAudit = roadEventAuditRepository.findLatest(roadEventId, null, null, null);

        if (prevAudit != null) {
            auditBus.startSession(roadEventId, prevAudit.getUpdatedRoadEventContext().getRoadEvent());
        } else {
            auditBus.startSession(roadEventId, null);
        }

        List<RoadEventUpdateStatus> existingStatuses = prevAudit != null
                ? prevAudit.getUpdatedRoadEventContext().getRoadEvent().getUpdateHistory()
                : new ArrayList<>();

        RoadEventUpdateStatus updateStatus = new RoadEventUpdateStatus(
                RoadEventUpdateStatus.SourceType.CON_ADMIN,
                RoadEventUpdateStatus.ApprovalStatus.APPROVED,
                RoadEventUpdateStatus.EventStatus.COMPLETED,
                ProtobufUtils.instantFromTimestamp(update.getTimestamp()),
                ProtobufUtils.instantFromTimestamp(update.getTimestamp()),
                update.getTypeCase().toString());
        existingStatuses.add(updateStatus);

        RoadEventAudit newAudit = new RoadEventAudit();
        newAudit.setRoadEventId(roadEventId);
        newAudit.setUpdatedRoadEventContext(null);
        newAudit.setPreviousRoadEventContext(prevAudit != null ? prevAudit.getUpdatedRoadEventContext() : null);
        newAudit.setRoadEventUpdateMessage(null);
        newAudit.setConAdminUpdateMessage(update);
        newAudit.setConAdminApprovalMessage(null);
        newAudit.setChanges(null);
        newAudit.setRequestId(update.getRequestId());
        newAudit.setTimestamp(Instant.now().toEpochMilli());

        auditBus.submitAudit(roadEventId, newAudit);

        roadEventRepository.delete(roadEventId);
    }
}
