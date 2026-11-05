package com.wydot.wz_datahub.api.update_processors.field_device;

import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.ProtobufUtils;
import com.wydot.wz_datahub.api.accessors.field_devices.FieldDeviceReadingRepository;
import com.wydot.wz_datahub.api.accessors.field_devices.FieldDeviceLinkRepository;
import com.wydot.wz_datahub.api.accessors.road_event.RoadEventRepository;
import com.wydot.wz_datahub.api.controllers.kafka.FieldDeviceUpdateController;
import com.wydot.wz_datahub.api.kafka.KafkaTopics;
import com.wydot.wz_datahub.api.models.mobile_vehicle.MobileVehicleLocation;
import com.wydot.wz_datahub.api.models.audit.AuditLogSeverity;
import com.wydot.wz_datahub.api.models.field_devices.FieldDeviceLink;
import com.wydot.wz_datahub.api.models.field_devices.FieldDeviceReading;
import com.wydot.wz_datahub.api.models.update_processing.Observation;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventAudit;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventUpdateStatus;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventWrapper;
import com.wydot.wz_datahub.api.update_processors.AuditBus;
import com.wydot.wz_datahub.api.update_processors.ObservationUpdateProcessor;
import com.wydot.wz_datahub.api.update_processors.UpdateProcessorProperties;
import com.wydot.wz_datahub.api.update_processors.UpdateProcessorUtils;
import com.wydot.wz_datahub.api.utilities.gis_service.GisService;

import jakarta.annotation.PostConstruct;
import kotlin.Pair;

import com.wydot.wz_datahub.api.models.raw_data.RawDataType;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Sinks;
import reactor.core.publisher.Sinks.Many;
import reactor.core.scheduler.Schedulers;
import wyo.dot.protobuf.DataHubFieldDeviceUpdate;
import wyo.dot.protobuf.DataHubRoadEventUpdate;
import wyo.dot.protobuf.DataHubUpdateSource;
import wyo.dot.protobuf.FieldDevice;
import wyo.dot.protobuf.FieldDevice.FieldDeviceCoreDetails;
import wyo.dot.protobuf.FieldDevice.FieldDeviceStatus;
import wyo.dot.protobuf.FieldDevice.MobileVehicle;
import wyo.dot.protobuf.FieldDevice.MobileVehicle.VehicleOperationType;
import wyo.dot.protobuf.FieldDeviceSummary;
import wyo.dot.protobuf.FieldDeviceSummaryArray;
import wyo.dot.protobuf.MarkedLocationType;
import wyo.dot.protobuf.PointGeometry;
import wyo.dot.protobuf.UpdateRoadEvent;

@Slf4j
@Component
@RequiredArgsConstructor
public class VehicleLocationUpdateProcessor {
    static long DATAHUB_ROAD_EVENT_ID_PREFIX_MOBILE_VEHICLE = 44992L;
    private final AuditBus auditBus;
    private final RoadEventRepository roadEventRepository;
    private final FieldDeviceLinkRepository fieldDeviceLinkRepository;
    private final FieldDeviceReadingRepository fieldDeviceReadingRepository;
    private final FieldDeviceUpdateController fieldDeviceUpdateController;
    private final GisService gisService;
    private final ObservationUpdateProcessor observationUpdateProcessor;
    private final UpdateProcessorProperties updateProcessorProperties;

    @Autowired
    private KafkaTemplate<String, DataHubRoadEventUpdate> template;

    // Multicast sink allows multiple subscribers
    Many<Pair<Long, Pair<MobileVehicleLocation, FieldDeviceReading>>> updateSink = Sinks.many().multicast()
            .onBackpressureBuffer();

    /**
     * Initialize the observation stream listener on bean creation
     * This starts processing observations automatically
     */
    @PostConstruct
    public void startObservationListener() {
        getObservationStream()
                .publishOn(Schedulers.boundedElastic()) // allow blocking calls
                .subscribe(
                        pair -> {
                            Long roadEventId = pair.getFirst();
                            Pair<MobileVehicleLocation, FieldDeviceReading> innerPair = pair.getSecond();
                            MobileVehicleLocation mobileVehicleLocation = innerPair.getFirst();
                            FieldDeviceReading fieldDeviceReading = innerPair.getSecond();
                            String workerId = mobileVehicleLocation.getWorkerId();

                            try {
                                this.processVehicleLocationUpdate(roadEventId, fieldDeviceReading,
                                        mobileVehicleLocation);
                            } catch (Exception e) {
                                log.error("Error processing observations for worker ID {}", workerId, e);
                            }
                        },
                        error -> log.error("Error in observation stream", error),
                        () -> log.info("Observation stream completed"));
    }

    public void addReading(Long id, Pair<MobileVehicleLocation, FieldDeviceReading> obj) {
        updateSink.tryEmitNext(new Pair<>(id, obj));
    }

    /**
     * Get the observation stream grouped by worker ID.
     * Buffers all updates for 1 minute starting from the first event.
     * Emits ONLY the final state once the minute is over.
     */
    public Flux<Pair<Long, Pair<MobileVehicleLocation, FieldDeviceReading>>> getObservationStream() {
        return updateSink.asFlux()
                .subscribeOn(reactor.core.scheduler.Schedulers.boundedElastic()) // Allow blocking calls
                .groupBy(Pair::getFirst, Pair::getSecond)
                .flatMap(group -> group
                        .windowTimeout(Integer.MAX_VALUE, updateProcessorProperties.getVehicleMaxReUpdatePeriod())
                        .flatMap(window -> window.takeLast(1))
                        .map(finalValue -> new Pair<>(group.key(), finalValue)));
    }

    public FieldDeviceReading processVehicleLocationUpdate(MobileVehicleLocation vehicleLocation) {
        log.debug("Processing vehicle location update: {}", vehicleLocation);

        String id = UpdateProcessorUtils.generateDeterministicUuid(vehicleLocation.getWorkerId(), "VEHICLE_LOCATION");
        VehicleOperationType operation = UpdateProcessorUtils
                .getVehicleOperationType(vehicleLocation.getOperationType());
        MarkedLocationType markedLocationType = MarkedLocationType.MARKED_LOCATION_TYPE_WORKER_POSITION;

        MobileVehicle.Builder mobileVehicle = MobileVehicle.newBuilder().setOperationType(operation)
                .setHeading((int) vehicleLocation.getHeading());
        ProtobufUtils.setIfNotNull(vehicleLocation.getLicensePlate(), mobileVehicle::setLicensePlate);

        String serialNumber = vehicleLocation.getLicensePlate();
        if (serialNumber == null || serialNumber.isEmpty()) {
            serialNumber = vehicleLocation.getWorkerId();
        }

        FieldDevice.Builder builder = FieldDevice.newBuilder()
                .setMobileVehicle(mobileVehicle)
                .setId(id)
                .setLocationType(markedLocationType)
                .setGeometry(PointGeometry.newBuilder()
                        .setCoordinates(vehicleLocation.getLocation()))
                // .setBbox() // TODO
                .setCoreDetails(FieldDeviceCoreDetails.newBuilder()
                        .setDeviceStatus(FieldDeviceStatus.FIELD_DEVICE_STATUS_OK)
                        .setHasAutomaticLocation(true)
                        .setName("Mobile Vehicle: " + vehicleLocation.getWorkerId())
                        // .setDescription() // TODO
                        // .setStatusMessages() // TODO
                        .setIsMoving(false) // TODO
                        .setMake(RawDataType.WZAM_VEHICLE.getDeviceMake(null)) // TODO
                        .setModel(operation.name()) // TODO
                        .setSerialNumber(serialNumber)
                        // .setFirmwareVersion() // TODO
                        .setVelocityKph(vehicleLocation.getVelocityKph()));

        ProtobufUtils.setIfNotNull(vehicleLocation.getRoadEventId(), builder::setRoadEventId);

        FieldDevice device = builder.build();
        FieldDeviceReading fieldDeviceReading = FieldDeviceReading.fromDevice(device,
                vehicleLocation.getTimestamp(), gisService).block();

        handleNewVehicleLocation(fieldDeviceReading, vehicleLocation);

        return fieldDeviceReading;
    }

    public void handleNewVehicleLocation(FieldDeviceReading fieldDeviceReading,
            MobileVehicleLocation mobileVehicleLocation) {
        Pair<Long, Boolean> response = getAndSyncRoadEventIdForReading(fieldDeviceReading);
        Long roadEventId = response.getFirst();
        Boolean isNew = response.getSecond();

        fieldDeviceReadingRepository.insert(fieldDeviceReading);

        if (!updateProcessorProperties.isVehicleLocationUpdatesEnabled()) {
            log.debug("Vehicle location updates are disabled. Skipping update for device ID {}.",
                    fieldDeviceReading.getDevice().getId());
            return;
        }
        DataHubFieldDeviceUpdate update = FieldDeviceUpdateProcessor.createFieldDeviceUpdate(fieldDeviceReading, isNew);
        fieldDeviceUpdateController.submitFieldDeviceUpdate(update);

        log.debug("Field device reading processed for device ID {} at timestamp {}.",
                fieldDeviceReading.getDevice().getId(), DateTimeFormatter.ISO_INSTANT
                        .format(fieldDeviceReading.getLastUpdated()));

        if (roadEventId != null) {
            if (fieldDeviceReading.getRouteAndMeasure() == null) {
                log.warn(
                        "Update from field device {} will not be utilized for road event updates because it is not on a known roadway",
                        fieldDeviceReading.getDevice().getId());
                return;
            } else {
                addReading(roadEventId, new Pair<>(mobileVehicleLocation, fieldDeviceReading));
            }
        } else {
            log.info("No RoadEvent linked to FieldDevice ID {}. Skipping update.",
                    fieldDeviceReading.getDevice().getId());
        }
    }

    public Pair<Long, Boolean> getAndSyncRoadEventIdForReading(FieldDeviceReading reading) {
        FieldDevice fieldDevice = reading.getDevice();
        List<FieldDeviceLink> links = fieldDeviceLinkRepository
                .find(fieldDevice.getId(), null, null, null, null,
                        PageRequest.of(0, 1))
                .getContent();

        Long roadEventId = UpdateProcessorUtils.concatIds(DATAHUB_ROAD_EVENT_ID_PREFIX_MOBILE_VEHICLE,
                Math.abs(fieldDevice.getId().hashCode()));
        if (fieldDevice.hasRoadEventId()) {
            roadEventId = fieldDevice.getRoadEventId();
        }

        FieldDeviceLink fieldDeviceLink = null;
        if (links.size() == 0) {
            // New field device - create link
            log.debug("New field device reading for device ID {}. Creating new link.",
                    fieldDevice.getId());
            fieldDeviceLink = new FieldDeviceLink(System.currentTimeMillis(), fieldDevice);
            fieldDeviceLink.setRoadEventId(roadEventId);
            fieldDeviceLinkRepository.update(fieldDeviceLink.getDeviceId(), fieldDeviceLink);
        } else {
            fieldDeviceLink = links.getFirst();
        }

        if (fieldDeviceLink.getRoadEventId() == null
                || (fieldDevice.hasRoadEventId()
                        && !fieldDeviceLink.getRoadEventId().equals(fieldDevice.getRoadEventId()))) {
            fieldDeviceLink.setRoadEventId(roadEventId);
            fieldDeviceLinkRepository.update(fieldDeviceLink.getDeviceId(), fieldDeviceLink);
        }

        return new Pair<>(roadEventId, links.size() == 0);
    }

    public void processVehicleLocationUpdate(Long roadEventId, FieldDeviceReading fieldDeviceReading,
            MobileVehicleLocation mobileVehicleLocation) {
        FieldDevice fieldDevice = fieldDeviceReading.getDevice();

        RoadEventWrapper roadEvent = roadEventRepository
                .find(roadEventId, null, null, null, null, null, null, null, PageRequest.of(0, 1))
                .getContent().stream().findFirst().orElse(null);

        // TODO: Set project ID
        // Long projectId = fieldDeviceLink.getProjectId();
        FieldDevice.Builder builder = fieldDevice.toBuilder();
        builder.setRoadEventId(roadEventId);
        // ProtobufUtils.setIfNotNull(projectId, builder::setProjectId);
        FieldDevice newFieldDevice = builder.build();
        fieldDeviceReading = fieldDeviceReading.withUpdatedDevice(newFieldDevice);

        DataHubRoadEventUpdate updateMessage = null;
        if (roadEvent == null) {
            // New road event
            updateMessage = createDataHubRoadEventUpdateFromMobileVehicleLocation(
                    fieldDeviceReading, mobileVehicleLocation, roadEventId);
        } else {
            List<Observation<?>> fieldDeviceObservations = Observation.fromFieldDevice(gisService, fieldDeviceReading,
                    roadEvent.getRouteAndMeasureRange());
            List<Observation<?>> allObservations = new ArrayList<>(roadEvent.getObservations());
            allObservations.addAll(fieldDeviceObservations);
            updateMessage = updateDataHubRoadEventFromMobileVehicleLocation(
                    fieldDeviceReading, mobileVehicleLocation,
                    roadEvent);
        }

        if (updateMessage != null) {
            this.template.send(KafkaTopics.DATAHUB_ROAD_EVENT, String.valueOf(updateMessage.getRequestId()),
                    updateMessage);
            return;
        } else {
            log.warn("No RoadEvent update created for field device ID {}.",
                    newFieldDevice.getId());
            return;
        }
    }

    public DataHubRoadEventUpdate createDataHubRoadEventUpdateFromMobileVehicleLocation(
            FieldDeviceReading fieldDeviceReading, MobileVehicleLocation mobileVehicleLocation,
            Long roadEventId) {
        long requestId = ProtobufUtils.generateRequestId(mobileVehicleLocation.getWorkerId()); // convert ID to long
        DataHubRoadEventUpdate.Builder builder = DataHubRoadEventUpdate.newBuilder()
                .setRequestId(requestId)
                .setTimestamp(ProtobufUtils.timestampFromMillis(System.currentTimeMillis()));
        // TODO: Update field device link table

        auditBus.startSession(roadEventId, null);
        auditBus.record(roadEventId,
                "Creating new RoadEvent from FieldDevice ID " + fieldDeviceReading.getDevice().getId(),
                AuditLogSeverity.INFO);

        List<Observation<?>> observations = Observation.fromMobileVehicleLocation(gisService, mobileVehicleLocation,
                roadEventId);
        RoadEventWrapper roadEventWrapper = observationUpdateProcessor.newRoadEventFromObservations(roadEventId,
                observations);

        if (roadEventWrapper == null) {
            // Unable to create road event from report - report was invalid or out of date
            log.warn("Unable to create RoadEvent from FieldDevice ID {}", fieldDeviceReading.getDevice().getId());
            auditBus.terminateSession(roadEventId,
                    "Unable to create RoadEvent from FieldDevice ID, null roadEventWrapper");
            return null;
        }
        roadEventRepository.update(roadEventId, roadEventWrapper);

        FieldDeviceSummary summary = FieldDeviceSummary.newBuilder()
                .setId(Math.abs(
                        fieldDeviceReading.getDevice().getId()
                                .hashCode()))
                .setDevice(fieldDeviceReading.getDevice())
                .setUpdateDate(ProtobufUtils.timestampFromInstant(fieldDeviceReading.getLastUpdated()))
                .build();
        FieldDeviceSummaryArray summaryArray = FieldDeviceSummaryArray.newBuilder()
                .addFieldDeviceSummary(summary)
                .build();
        DataHubUpdateSource source = DataHubUpdateSource.newBuilder()
                .setFieldDeviceSummaries(summaryArray)
                .build();
        UpdateRoadEvent updateEvent = UpdateRoadEvent.newBuilder()
                .setRoadEvent(roadEventWrapper.getRoadEvent())
                .setSource(source)
                .addAllRoadSubEvents(roadEventWrapper.getUnwrappedRoadSubEvents())
                .build();

        builder.setUpdated(updateEvent);

        DataHubRoadEventUpdate update = builder.build();

        RoadEventAudit audit = UpdateProcessorUtils.auditFromWrapper(roadEventWrapper, null, update);
        auditBus.submitAudit(roadEventWrapper.getRoadEvent().getId(), audit);

        return update;
    }

    public DataHubRoadEventUpdate updateDataHubRoadEventFromMobileVehicleLocation(FieldDeviceReading fieldDeviceReading,
            MobileVehicleLocation mobileVehicleLocation,
            RoadEventWrapper prevRoadEventWrapper) {
        long requestId = ProtobufUtils.generateRequestId(fieldDeviceReading.getDevice().getId());
        DataHubRoadEventUpdate.Builder builder = DataHubRoadEventUpdate.newBuilder()
                .setRequestId(requestId)
                .setTimestamp(ProtobufUtils.timestampFromMillis(System.currentTimeMillis()));

        auditBus.startSession(prevRoadEventWrapper.getRoadEvent().getId(), prevRoadEventWrapper);
        auditBus.record(prevRoadEventWrapper.getRoadEvent().getId(),
                "Updating RoadEvent from FieldDevice ID " + fieldDeviceReading.getDevice().getId(),
                AuditLogSeverity.INFO);

        List<Observation<?>> observations = new ArrayList<>(prevRoadEventWrapper.getObservations());
        observations.addAll(Observation.fromMobileVehicleLocation(gisService, mobileVehicleLocation,
                prevRoadEventWrapper.getRoadEvent().getId()));

        RoadEventWrapper roadEventWrapper = observationUpdateProcessor
                .newRoadEventFromObservations(prevRoadEventWrapper.getRoadEvent().getId(), observations);

        if (roadEventWrapper == null) {
            // End event now
            RoadEventUpdateStatus updateStatus = new RoadEventUpdateStatus(
                    RoadEventUpdateStatus.SourceType.MOBILE_VEHICLE,
                    RoadEventUpdateStatus.ApprovalStatus.AUTO_APPROVED,
                    RoadEventUpdateStatus.EventStatus.COMPLETED,
                    fieldDeviceReading.getLastUpdated(),
                    fieldDeviceReading.getLastUpdated(),
                    fieldDeviceReading);
            roadEventWrapper = ObservationUpdateProcessor.terminateRoadEvent(prevRoadEventWrapper,
                    fieldDeviceReading.getLastUpdated(), updateStatus);
        } else if (UpdateProcessorUtils.compareRoadEventWrappers(roadEventWrapper, prevRoadEventWrapper,
                updateProcessorProperties)) {
            // No changes detected
            auditBus.terminateSession(prevRoadEventWrapper.getRoadEvent().getId(),
                    "No changes detected for RoadEvent from FieldDevice update, skipping update");
            return null;
        }
        roadEventRepository.update(prevRoadEventWrapper.getRoadEvent().getId(), roadEventWrapper);

        FieldDeviceSummary summary = FieldDeviceSummary.newBuilder()
                .setId(Math.abs(
                        fieldDeviceReading.getDevice().getId()
                                .hashCode()))
                .setDevice(fieldDeviceReading.getDevice())
                .setUpdateDate(ProtobufUtils.timestampFromInstant(fieldDeviceReading.getLastUpdated()))
                .build();
        FieldDeviceSummaryArray summaryArray = FieldDeviceSummaryArray.newBuilder()
                .addFieldDeviceSummary(summary)
                .build();
        DataHubUpdateSource source = DataHubUpdateSource.newBuilder()
                .setFieldDeviceSummaries(summaryArray)
                .build();
        UpdateRoadEvent updateEvent = UpdateRoadEvent.newBuilder()
                .setRoadEvent(roadEventWrapper.getRoadEvent())
                .setSource(source)
                .addAllRoadSubEvents(roadEventWrapper.getUnwrappedRoadSubEvents())
                .build();

        builder.setUpdated(updateEvent);

        DataHubRoadEventUpdate update = builder.build();

        RoadEventAudit audit = UpdateProcessorUtils.auditFromWrapper(roadEventWrapper, prevRoadEventWrapper, update);
        auditBus.submitAudit(roadEventWrapper.getRoadEvent().getId(), audit);

        return update;
    }
}
