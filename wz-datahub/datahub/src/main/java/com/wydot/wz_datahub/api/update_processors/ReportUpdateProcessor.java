package com.wydot.wz_datahub.api.update_processors;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;

import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.keycloak.KeycloakApi;
import com.wydot.wz_datahub.api.models.audit.AuditLogSeverity;
import com.wydot.wz_datahub.api.models.keycloak.KeycloakUserInfo;
import com.wydot.wz_datahub.api.ProtobufUtils;
import com.wydot.wz_datahub.api.accessors.reports.ReportRepository;
import com.wydot.wz_datahub.api.accessors.road_event.RoadEventRepository;
import com.wydot.wz_datahub.api.models.reports.ReportPatch;
import com.wydot.wz_datahub.api.models.reports.ReportWithId;
import com.wydot.wz_datahub.api.models.reports.WorkerPresenceReport;
import com.wydot.wz_datahub.api.models.update_processing.Observation;
import com.wydot.wz_datahub.api.models.update_processing.ObservationMetadata;
import com.wydot.wz_datahub.api.models.update_processing.ObservationType;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventAudit;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventWrapper;
import com.wydot.wz_datahub.api.update_processors.field_device.FieldDeviceUpdateProcessor;
import com.wydot.wz_datahub.api.utilities.gis_service.GisService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.CreateRoadEvent;
import wyo.dot.protobuf.DataHubRoadEventUpdate;
import wyo.dot.protobuf.DataHubUpdateSource;
import wyo.dot.protobuf.ReportSummary;
import wyo.dot.protobuf.UpdateRoadEvent;
import wyo.dot.protobuf.ContactInfo;

@Slf4j
@Component
@RequiredArgsConstructor
public class ReportUpdateProcessor {
    static long DATAHUB_ROAD_EVENT_ID_PREFIX_REPORT = 44990L;
    private final AuditBus auditBus;
    private final ReportRepository reportRepository;
    private final RoadEventRepository roadEventRepository;
    private final GisService gisService;
    private final ObservationUpdateProcessor observationUpdateProcessor;
    private final FieldDeviceUpdateProcessor fieldDeviceUpdateProcessor;
    private final KeycloakApi keycloakApi;

    public DataHubRoadEventUpdate createDataHubRoadEventFromReport(ReportWithId report) {
        long requestId = ProtobufUtils.generateRequestId(report.getId());
        DataHubRoadEventUpdate.Builder builder = DataHubRoadEventUpdate.newBuilder()
                .setRequestId(requestId)
                .setTimestamp(ProtobufUtils.timestampFromMillis(System.currentTimeMillis()));

        long id = UpdateProcessorUtils.concatIds(DATAHUB_ROAD_EVENT_ID_PREFIX_REPORT, report.getId());

        auditBus.startSession(id, null);
        auditBus.record(id, "Creating RoadEvent from Report ID " + report.getId(), AuditLogSeverity.INFO);

        List<Observation<?>> observations = Observation.fromReport(report, id, gisService);

        RoadEventWrapper roadEventWrapper = observationUpdateProcessor.newRoadEventFromObservations(id, observations);
        if (roadEventWrapper == null) {
            // Unable to create road event from report - report was invalid or out of date
            auditBus.terminateSession(id, "Unable to create RoadEvent from Report ID, null roadEventWrapper");
            return null;
        }
        roadEventRepository.update(id, roadEventWrapper);

        // Update field device links
        if (report.getLinkedFieldDeviceIds() != null && !report.getLinkedFieldDeviceIds().isEmpty()) {
            try {
                report.getLinkedFieldDeviceIds().forEach(
                        deviceId -> fieldDeviceUpdateProcessor.updateFieldDeviceLink(deviceId, id));
            } catch (Exception e) {
                log.error("Error updating field device links for Report ID {}: {}", report.getId(),
                        e.getMessage());
            }
        }

        KeycloakUserInfo userInfo = keycloakApi.getUserInfo(report.getUserId()).block();
        ContactInfo contactInfo = ContactInfo.newBuilder().setFirstName(userInfo.getFirstName())
                .setLastName(userInfo.getLastName()).setEmail(userInfo.getEmail())
                .setPhoneNumber(userInfo.getAttributes().toProto()).build();

        ReportSummary summary = ReportSummary.newBuilder()
                .setId(report.getId())
                .setName(report.getName())
                .setDescription(Objects.requireNonNullElse(report.getDescription(), ""))
                .setTimestamp(ProtobufUtils.timestampFromInstant(report.getTimestamp()))
                .setContactInfo(contactInfo)
                .build();
        DataHubUpdateSource source = DataHubUpdateSource.newBuilder()
                .setReportSummary(summary)
                .build();
        CreateRoadEvent createEvent = CreateRoadEvent.newBuilder()
                .setRoadEvent(roadEventWrapper.getRoadEvent())
                .setSource(source)
                .addAllRoadSubEvents(roadEventWrapper.getUnwrappedRoadSubEvents())
                .build();

        builder.setCreated(createEvent);

        // Update road event ID in saved report
        report.setRoadEventId(id);
        reportRepository.update(report.getId(), report, true);

        DataHubRoadEventUpdate update = builder.build();

        RoadEventAudit audit = UpdateProcessorUtils.auditFromWrapper(roadEventWrapper, null, update);
        auditBus.submitAudit(id, audit);

        return update;
    }

    public DataHubRoadEventUpdate updateDataHubRoadEventFromReport(ReportPatch report,
            RoadEventWrapper prevRoadEventWrapper) {
        long requestId = ProtobufUtils.generateRequestId(report.getId());
        DataHubRoadEventUpdate.Builder builder = DataHubRoadEventUpdate.newBuilder()
                .setRequestId(requestId)
                .setTimestamp(ProtobufUtils.timestampFromMillis(System.currentTimeMillis()));

        long id = prevRoadEventWrapper.getRoadEvent().getId();

        auditBus.startSession(id, prevRoadEventWrapper);
        auditBus.record(id, "Updating RoadEvent from Report ID " + report.getId(), AuditLogSeverity.INFO);

        List<Observation<?>> observations = new ArrayList<>(prevRoadEventWrapper.getObservations());
        @SuppressWarnings("unchecked") // Safe cast since we filter by type
        Observation<ObservationMetadata> metadataObservation = observations.stream()
                .filter(obs -> obs.getType() == ObservationType.METADATA)
                .map(obs -> (Observation<ObservationMetadata>) obs)
                .sorted(Comparator.comparing(Observation::getTimestamp)) // sorted descending to get latest metadata
                .findFirst()
                .orElse(null);
        observations.addAll(Observation.fromReportPatch(report, id, gisService, metadataObservation));

        RoadEventWrapper roadEventWrapper = observationUpdateProcessor.newRoadEventFromObservations(id, observations);
        if (roadEventWrapper == null) {
            auditBus.terminateSession(id,
                    "Unable to create RoadEvent from Report " + report.getId() + ", null roadEventWrapper");
            return null;
        }
        roadEventRepository.update(id, roadEventWrapper);

        // Update field device links
        if (report.getLinkedFieldDeviceIds() != null && !report.getLinkedFieldDeviceIds().isEmpty()) {
            try {
                report.getLinkedFieldDeviceIds().forEach(
                        deviceId -> fieldDeviceUpdateProcessor.updateFieldDeviceLink(deviceId, id));
            } catch (Exception e) {
                log.error("Error updating field device links for Report ID {}: {}", report.getId(),
                        e.getMessage());
            }
        }

        KeycloakUserInfo userInfo = keycloakApi.getUserInfo(report.getUserId()).block();
        ContactInfo contactInfo = ContactInfo.newBuilder().setFirstName(userInfo.getFirstName())
                .setLastName(userInfo.getLastName()).setEmail(userInfo.getEmail())
                .setPhoneNumber(userInfo.getAttributes().toProto()).build();

        ReportSummary summary = ReportSummary.newBuilder()
                .setId(report.getId())
                .setName(Objects.requireNonNullElse(report.getName(), prevRoadEventWrapper.getRoadEvent().getName()))
                .setDescription(Objects.requireNonNullElse(report.getDescription(),
                        prevRoadEventWrapper.getRoadEvent().getDescription()))
                .setTimestamp(ProtobufUtils.timestampFromInstant(report.getTimestamp()))
                .setContactInfo(contactInfo)
                .build();
        DataHubUpdateSource source = DataHubUpdateSource.newBuilder()
                .setReportSummary(summary)
                .build();
        UpdateRoadEvent updateEvent = UpdateRoadEvent.newBuilder()
                .setRoadEvent(roadEventWrapper.getRoadEvent())
                .setSource(source)
                .addAllRoadSubEvents(roadEventWrapper.getUnwrappedRoadSubEvents())
                .build();

        builder.setUpdated(updateEvent);

        DataHubRoadEventUpdate update = builder.build();

        RoadEventAudit audit = UpdateProcessorUtils.auditFromWrapper(roadEventWrapper, prevRoadEventWrapper, update);
        auditBus.submitAudit(id, audit);

        return update;
    }

    public DataHubRoadEventUpdate updateDataHubRoadEventFromWorkerPresenceReport(WorkerPresenceReport wpReport,
            RoadEventWrapper prevRoadEventWrapper) {
        long requestId = ProtobufUtils.generateRequestId(wpReport.getId());
        DataHubRoadEventUpdate.Builder builder = DataHubRoadEventUpdate.newBuilder()
                .setRequestId(requestId)
                .setTimestamp(ProtobufUtils.timestampFromMillis(System.currentTimeMillis()));

        long id = prevRoadEventWrapper.getRoadEvent().getId();

        auditBus.startSession(id, prevRoadEventWrapper);
        auditBus.record(id, "Updating RoadEvent from WorkerPresenceReport ID " + wpReport.getId(),
                AuditLogSeverity.INFO);

        List<Observation<?>> observations = new ArrayList<>(prevRoadEventWrapper.getObservations());
        @SuppressWarnings("unchecked") // Safe cast since we filter by type
        Observation<ObservationMetadata> metadataObservation = observations.stream()
                .filter(obs -> obs.getType() == ObservationType.METADATA)
                .map(obs -> (Observation<ObservationMetadata>) obs)
                .sorted(Comparator.comparing(Observation::getTimestamp)) // sorted descending to get latest metadata
                .findFirst()
                .orElse(null);
        observations.addAll(Observation.fromWorkerPresenceReport(wpReport, id, gisService, metadataObservation));

        RoadEventWrapper roadEventWrapper = observationUpdateProcessor.newRoadEventFromObservations(id, observations);
        if (roadEventWrapper == null) {
            auditBus.terminateSession(id,
                    "Unable to create RoadEvent from WorkerPresenceReport " + wpReport.getId()
                            + ", null roadEventWrapper");
            return null;
        }
        roadEventRepository.update(id, roadEventWrapper);

        KeycloakUserInfo userInfo = keycloakApi.getUserInfo(wpReport.getUserId()).block();
        ContactInfo contactInfo = ContactInfo.newBuilder().setFirstName(userInfo.getFirstName())
                .setLastName(userInfo.getLastName()).setEmail(userInfo.getEmail())
                .setPhoneNumber(userInfo.getAttributes().toProto()).build();

        ReportSummary summary = ReportSummary.newBuilder()
                .setId(wpReport.getId())
                .setName("Worker Presence Report")
                .setDescription("")
                .setTimestamp(ProtobufUtils.timestampFromInstant(wpReport.getTimestamp()))
                .setContactInfo(contactInfo)
                .build();
        DataHubUpdateSource source = DataHubUpdateSource.newBuilder()
                .setReportSummary(summary)
                .build();
        UpdateRoadEvent updateEvent = UpdateRoadEvent.newBuilder()
                .setRoadEvent(roadEventWrapper.getRoadEvent())
                .setSource(source)
                .addAllRoadSubEvents(roadEventWrapper.getUnwrappedRoadSubEvents())
                .build();

        builder.setUpdated(updateEvent);

        DataHubRoadEventUpdate update = builder.build();

        RoadEventAudit audit = UpdateProcessorUtils.auditFromWrapper(roadEventWrapper, prevRoadEventWrapper, update);
        auditBus.submitAudit(id, audit);

        return update;
    }
}
