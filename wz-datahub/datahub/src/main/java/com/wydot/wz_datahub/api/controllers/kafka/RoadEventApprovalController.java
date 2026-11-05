package com.wydot.wz_datahub.api.controllers.kafka;

import java.time.Instant;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.wydot.wz_datahub.api.ProtobufUtils;
import com.wydot.wz_datahub.api.accessors.road_event.RoadEventAuditRepository;
import com.wydot.wz_datahub.api.accessors.road_event.RoadEventRepository;
import com.wydot.wz_datahub.api.models.audit.AuditLogSeverity;
import com.wydot.wz_datahub.api.models.update_processing.Observation;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventAudit;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventUpdateStatus;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventWithContext;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventWrapper;
import com.wydot.wz_datahub.api.models.wrappers.RoadSubEventWrapper;
import com.wydot.wz_datahub.api.update_processors.AuditBus;
import com.wydot.wz_datahub.api.update_processors.UpdateProcessorUtils;
import com.wydot.wz_datahub.api.utilities.gis_service.GisService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.RoadEvent;
import wyo.dot.protobuf.RoadSubEvent;
import wyo.dot.protobuf.conadmin.ConAdminRoadEventApproval;
import wyo.dot.protobuf.conadmin.RoadEventUpdateApproved;

@RestController
@Slf4j
@RequestMapping("/kafka")
@RequiredArgsConstructor
public class RoadEventApprovalController {
    private final RoadEventRepository roadEventRepository;
    private final RoadEventAuditRepository roadEventAuditRepository;
    private final GisService gisService;
    private final AuditBus auditBus;

    public void handleRoadEventApproval(ConAdminRoadEventApproval approval) {
        log.info("Received road event approval: {}", approval.getRequestId());

        switch (approval.getTypeCase()) {
            case APPROVED:
                handleRoadEventApproved(approval);
                break;
            case REJECTED:
                handleRoadEventRejected(approval);
                break;
            default:
                log.warn("Received unrecognized road event approval: {}", approval.getRequestId());
        }
    }

    private void handleRoadEventApproved(ConAdminRoadEventApproval approval) {
        RoadEventUpdateApproved approved = approval.getApproved();
        RoadEvent roadEvent = approved.getRoadEvent();

        RoadEventWrapper previousRoadEvent = roadEventRepository.findOne(roadEvent.getId(), null, null, null, null,
                null, null, null);

        List<RoadSubEventWrapper> roadSubEvents = approved.getRoadSubEventsList().stream()
                .map((RoadSubEvent v) -> new RoadSubEventWrapper(v, List.of(), gisService))
                .collect(Collectors.toList());
        List<RoadEventUpdateStatus> updateStatuses = previousRoadEvent.getUpdateHistory();
        RoadEventUpdateStatus updateStatus = updateStatuses.getLast();
        if (updateStatus != null && updateStatus.getApprovalStatus() == RoadEventUpdateStatus.ApprovalStatus.PENDING) {
            updateStatus.setApprovalStatus(RoadEventUpdateStatus.ApprovalStatus.APPROVED);
            updateStatus.setUpdateReviewTimestamp(ProtobufUtils.instantFromTimestamp(approval.getTimestamp()));
        } else {
            updateStatus = new RoadEventUpdateStatus(
                    RoadEventUpdateStatus.SourceType.CON_ADMIN,
                    RoadEventUpdateStatus.ApprovalStatus.APPROVED,
                    UpdateProcessorUtils.determineEventStatus(roadEvent),
                    previousRoadEvent.getLastUpdated(),
                    ProtobufUtils.instantFromTimestamp(approval.getTimestamp()),
                    approval.getTypeCase().toString());
            updateStatuses.add(updateStatus);
        }
        RoadEventWrapper roadEventWrapper = new RoadEventWrapper(roadEvent, roadSubEvents,
                List.of(), ProtobufUtils.instantFromTimestamp(approval.getTimestamp()), null,
                Stream.concat(previousRoadEvent.getUpdateHistory().stream(), Stream.of(updateStatus)).toList());
        List<Observation<?>> observations = Observation.fromConAdmin(roadEventWrapper, roadSubEvents);
        roadEventWrapper.setObservations(observations);

        roadEventRepository.update(roadEvent.getId(), roadEventWrapper);

        RoadEventAudit audit = new RoadEventAudit();
        audit.setRoadEventId(roadEventWrapper.getRoadEvent().getId());
        audit.setUpdatedRoadEventContext(UpdateProcessorUtils.contextFromWrapper(roadEventWrapper));
        audit.setPreviousRoadEventContext(UpdateProcessorUtils.contextFromWrapper(previousRoadEvent));
        audit.setRoadEventUpdateMessage(null);
        audit.setConAdminUpdateMessage(null);
        audit.setConAdminApprovalMessage(approval);
        audit.setChanges(null);
        audit.setRequestId(approval.getRequestId());
        audit.setTimestamp(Instant.now().toEpochMilli());

        auditBus.startSession(roadEvent.getId(), roadEventWrapper);
        auditBus.submitAudit(audit.getRoadEventId(), new RoadEventAudit(
                audit.getRoadEventId(),
                null,
                audit.getUpdatedRoadEventContext(),
                null,
                null,
                approval,
                List.of(),
                List.of(),
                approval.getRequestId(),
                Instant.now().toEpochMilli()));
    }

    private void handleRoadEventRejected(ConAdminRoadEventApproval approval) {
        Long requestId = approval.getRejected().getOriginalRequestId();

        RoadEventAudit audit = roadEventAuditRepository.findLatest(null, requestId, null, null);
        if (audit == null) {
            log.warn("No audit found for rejected road event update with request ID {}", requestId);
            return;
        }
        auditBus.startSession(audit.getRoadEventId(), audit.getUpdatedRoadEventContext().getRoadEvent());

        auditBus.record(audit.getRoadEventId(), "Road event update rejected by ConAdmin, reverting to previous state",
                AuditLogSeverity.INFO);
        RoadEventWithContext revertedRoadEvent = audit.getPreviousRoadEventContext();
        RoadEventWrapper previousRoadEvent = revertedRoadEvent.getRoadEvent();

        List<RoadEventUpdateStatus> updateStatuses = revertedRoadEvent.getRoadEvent().getUpdateHistory();
        RoadEventUpdateStatus updateStatus = updateStatuses.getLast();
        if (updateStatus != null && updateStatus.getApprovalStatus() == RoadEventUpdateStatus.ApprovalStatus.PENDING) {
            updateStatus.setApprovalStatus(RoadEventUpdateStatus.ApprovalStatus.REJECTED);
            updateStatus.setUpdateReviewTimestamp(ProtobufUtils.instantFromTimestamp(approval.getTimestamp()));
        } else {
            updateStatus = new RoadEventUpdateStatus(
                    RoadEventUpdateStatus.SourceType.CON_ADMIN,
                    RoadEventUpdateStatus.ApprovalStatus.REJECTED,
                    UpdateProcessorUtils.determineEventStatus(previousRoadEvent.getRoadEvent()),
                    previousRoadEvent.getLastUpdated(),
                    ProtobufUtils.instantFromTimestamp(approval.getTimestamp()),
                    approval.getTypeCase().toString());
            updateStatuses.add(updateStatus);
        }
        previousRoadEvent.setUpdateHistory(updateStatuses);

        if (revertedRoadEvent == null || revertedRoadEvent.getRoadEvent() == null) {
            roadEventRepository.delete(audit.getRoadEventId());
            auditBus.submitAudit(audit.getRoadEventId(), new RoadEventAudit(
                    audit.getRoadEventId(),
                    null,
                    audit.getUpdatedRoadEventContext(),
                    null,
                    null,
                    approval,
                    List.of(),
                    List.of(),
                    approval.getRequestId(),
                    Instant.now().toEpochMilli()));
            return;
        } else {
            roadEventRepository.update(audit.getRoadEventId(), previousRoadEvent);
            auditBus.submitAudit(audit.getRoadEventId(), new RoadEventAudit(
                    audit.getRoadEventId(),
                    revertedRoadEvent,
                    audit.getUpdatedRoadEventContext(),
                    null,
                    null,
                    approval,
                    List.of(),
                    List.of(),
                    approval.getRequestId(),
                    Instant.now().toEpochMilli()));
        }

        // TODO: Re-apply pending updates to the road event
    }
}
