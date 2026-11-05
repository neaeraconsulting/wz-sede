package com.wydot.wz_datahub.api.update_processors;

import java.util.List;
import java.util.Objects;

import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.ProtobufUtils;
import com.wydot.wz_datahub.api.accessors.recordings.RecordingRepository;
import com.wydot.wz_datahub.api.accessors.road_event.RoadEventRepository;
import com.wydot.wz_datahub.api.keycloak.KeycloakApi;
import com.wydot.wz_datahub.api.models.audit.AuditLogSeverity;
import com.wydot.wz_datahub.api.models.keycloak.KeycloakUserInfo;
import com.wydot.wz_datahub.api.models.recordings.RecordingPoint;
import com.wydot.wz_datahub.api.models.recordings.RecordingWithId;
import com.wydot.wz_datahub.api.models.update_processing.Observation;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventAudit;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventWrapper;
import com.wydot.wz_datahub.api.update_processors.field_device.FieldDeviceUpdateProcessor;
import com.wydot.wz_datahub.api.utilities.gis_service.GisService;

import lombok.RequiredArgsConstructor;

import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.ContactInfo;
import wyo.dot.protobuf.CreateRoadEvent;
import wyo.dot.protobuf.DataHubRoadEventUpdate;
import wyo.dot.protobuf.DataHubUpdateSource;
import wyo.dot.protobuf.RecordingSummary;
import wyo.dot.protobuf.UpdateRoadEvent;

@Slf4j
@Component
@RequiredArgsConstructor
public class RecordingUpdateProcessor {
    static long DATAHUB_ROAD_EVENT_ID_PREFIX_RECORDING = 44991L;
    private final AuditBus auditBus;
    private final RecordingRepository recordingRepository;
    private final RoadEventRepository roadEventRepository;
    private final GisService gisService;
    private final ObservationUpdateProcessor observationUpdateProcessor;
    private final FieldDeviceUpdateProcessor fieldDeviceUpdateProcessor;
    private final KeycloakApi keycloakApi;

    public DataHubRoadEventUpdate createDataHubRoadEventFromRecording(RecordingWithId recording) {
        long requestId = ProtobufUtils.generateRequestId(recording.getId());
        DataHubRoadEventUpdate.Builder builder = DataHubRoadEventUpdate.newBuilder()
                .setRequestId(requestId)
                .setTimestamp(ProtobufUtils.timestampFromMillis(System.currentTimeMillis()));

        long id = UpdateProcessorUtils.concatIds(DATAHUB_ROAD_EVENT_ID_PREFIX_RECORDING, recording.getId());

        auditBus.startSession(id, null);
        auditBus.record(id, "Creating RoadEvent from Recording ID " + recording.getId(), AuditLogSeverity.INFO);

        // Update road event ID and save recording
        recording.setRoadEventId(id);
        recordingRepository.update(recording.getId(), recording, true);

        List<Observation<?>> observations = Observation.fromRecording(recording, id, gisService);

        RoadEventWrapper roadEventWrapper = observationUpdateProcessor.newRoadEventFromObservations(id, observations);
        if (roadEventWrapper == null) {
            // Unable to create road event from recording - recording was invalid or out of
            // date
            auditBus.terminateSession(id,
                    "Unable to create RoadEvent from Recording ID, null roadEventWrapper");
            return null;
        }
        roadEventRepository.update(id, roadEventWrapper);

        // Update field device links
        if (recording.getLinkedFieldDeviceIds() != null && !recording.getLinkedFieldDeviceIds().isEmpty()) {
            try {
                recording.getLinkedFieldDeviceIds().forEach(
                        deviceId -> fieldDeviceUpdateProcessor.updateFieldDeviceLink(deviceId, id));
            } catch (Exception e) {
                log.error("Error updating field device links for Recording ID {}: {}", recording.getId(),
                        e.getMessage());
            }
        }

        KeycloakUserInfo userInfo = keycloakApi.getUserInfo(recording.getUserId()).block();
        ContactInfo contactInfo = ContactInfo.newBuilder().setFirstName(userInfo.getFirstName())
                .setLastName(userInfo.getLastName()).setEmail(userInfo.getEmail())
                .setPhoneNumber(userInfo.getAttributes().toProto()).build();

        double lengthMeters = roadEventWrapper.getRouteAndMeasureRange() != null
                ? roadEventWrapper.getRouteAndMeasureRange().getLengthMeters()
                : 0.0;
        double positionAccuracy = 0.0;
        for (RecordingPoint point : recording.getPoints()) {
            positionAccuracy += point.getAccuracy();
        }
        positionAccuracy = recording.getPoints().size() > 0 ? positionAccuracy / recording.getPoints().size() : 0.0;

        RecordingSummary summary = RecordingSummary.newBuilder()
                .setId(recording.getId())
                .setName(recording.getName())
                .setDescription(recording.getSourceType().toString() + ": "
                        + Objects.requireNonNullElse(recording.getDescription(), ""))
                .setTimestamp(ProtobufUtils.timestampFromInstant(recording.getTimestamp()))
                .setLengthMeters(lengthMeters)
                .setPositionAccuracyMeters(positionAccuracy)
                .setContactInfo(contactInfo)
                .build();
        DataHubUpdateSource source = DataHubUpdateSource.newBuilder()
                .setRecordingSummary(summary)
                .build();
        CreateRoadEvent createEvent = CreateRoadEvent.newBuilder()
                .setRoadEvent(roadEventWrapper.getRoadEvent())
                .setSource(source)
                .addAllRoadSubEvents(roadEventWrapper.getUnwrappedRoadSubEvents())
                .build();

        builder.setCreated(createEvent);
        DataHubRoadEventUpdate update = builder.build();

        RoadEventAudit audit = UpdateProcessorUtils.auditFromWrapper(roadEventWrapper, null, update);
        auditBus.submitAudit(id, audit);

        return update;

    }

    public DataHubRoadEventUpdate updateDataHubRoadEventFromRecording(RecordingWithId recording,
            RoadEventWrapper prevRoadEventWrapper) {
        long requestId = ProtobufUtils.generateRequestId(recording.getId());
        DataHubRoadEventUpdate.Builder builder = DataHubRoadEventUpdate.newBuilder()
                .setRequestId(requestId)
                .setTimestamp(ProtobufUtils.timestampFromMillis(System.currentTimeMillis()));

        long id = prevRoadEventWrapper.getRoadEvent().getId();

        auditBus.startSession(id, prevRoadEventWrapper);
        auditBus.record(id, "Updating RoadEvent from Recording ID " + recording.getId(), AuditLogSeverity.INFO);

        List<Observation<?>> observations = Observation.fromRecording(recording, id, gisService);

        RoadEventWrapper roadEventWrapper = observationUpdateProcessor.newRoadEventFromObservations(id, observations);
        roadEventRepository.update(id, roadEventWrapper);

        // Update field device links
        if (recording.getLinkedFieldDeviceIds() != null && !recording.getLinkedFieldDeviceIds().isEmpty()) {
            try {
                recording.getLinkedFieldDeviceIds().forEach(
                        deviceId -> fieldDeviceUpdateProcessor.updateFieldDeviceLink(deviceId, id));
            } catch (Exception e) {
                log.error("Error updating field device links for Recording ID {}: {}", recording.getId(),
                        e.getMessage());
            }
        }

        double lengthMeters = roadEventWrapper.getRouteAndMeasureRange() != null
                ? roadEventWrapper.getRouteAndMeasureRange().getLengthMeters()
                : 0.0;
        double positionAccuracy = 0.0;
        for (RecordingPoint point : recording.getPoints()) {
            positionAccuracy += point.getAccuracy();
        }
        positionAccuracy = recording.getPoints().size() > 0 ? positionAccuracy / recording.getPoints().size() : 0.0;

        RecordingSummary summary = RecordingSummary.newBuilder()
                .setId(recording.getId())
                .setName(recording.getName())
                .setDescription(
                        recording.getSourceType().toString() + ": "
                                + Objects.requireNonNullElse(recording.getDescription(), ""))
                .setTimestamp(ProtobufUtils.timestampFromInstant(recording.getTimestamp()))
                .setLengthMeters(lengthMeters)
                .setPositionAccuracyMeters(positionAccuracy)
                .build();
        DataHubUpdateSource source = DataHubUpdateSource.newBuilder()
                .setRecordingSummary(summary)
                .build();

        UpdateRoadEvent updateEvent = UpdateRoadEvent.newBuilder()
                .setRoadEvent(roadEventWrapper.getRoadEvent())
                .setSource(source)
                .addAllRoadSubEvents(roadEventWrapper.getUnwrappedRoadSubEvents())
                .build();

        builder.setUpdated(updateEvent);

        // Update road event ID in saved recording
        recording.setRoadEventId(id);
        recordingRepository.update(recording.getId(), recording, true);

        DataHubRoadEventUpdate update = builder.build();

        RoadEventAudit audit = UpdateProcessorUtils.auditFromWrapper(roadEventWrapper, prevRoadEventWrapper, update);
        auditBus.submitAudit(id, audit);

        return update;
    }
}