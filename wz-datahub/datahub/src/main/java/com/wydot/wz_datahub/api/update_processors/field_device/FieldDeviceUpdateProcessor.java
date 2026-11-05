package com.wydot.wz_datahub.api.update_processors.field_device;

import java.time.Instant;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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
import com.wydot.wz_datahub.api.models.audit.AuditLogSeverity;
import com.wydot.wz_datahub.api.models.field_devices.FieldDeviceLink;
import com.wydot.wz_datahub.api.models.field_devices.FieldDeviceReading;
import com.wydot.wz_datahub.api.models.update_processing.Observation;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventAudit;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventWrapper;
import com.wydot.wz_datahub.api.update_processors.AuditBus;
import com.wydot.wz_datahub.api.update_processors.ObservationUpdateProcessor;
import com.wydot.wz_datahub.api.update_processors.UpdateProcessorProperties;
import com.wydot.wz_datahub.api.update_processors.UpdateProcessorUtils;
import com.wydot.wz_datahub.api.utilities.gis_service.GisService;

import jakarta.annotation.PostConstruct;
import kotlin.Pair;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Sinks;
import reactor.core.publisher.Sinks.Many;
import reactor.core.scheduler.Schedulers;
import wyo.dot.protobuf.CreateFieldDevice;
import wyo.dot.protobuf.DataHubFieldDeviceUpdate;
import wyo.dot.protobuf.DataHubRoadEventUpdate;
import wyo.dot.protobuf.DataHubUpdateSource;
import wyo.dot.protobuf.FieldDevice;
import wyo.dot.protobuf.FieldDeviceSummary;
import wyo.dot.protobuf.FieldDeviceSummaryArray;
import wyo.dot.protobuf.RoadEvent;
import wyo.dot.protobuf.UpdateFieldDevice;
import wyo.dot.protobuf.RoadEvent.RoadEventActiveStatus;
import wyo.dot.protobuf.RoadSubEvent;
import wyo.dot.protobuf.UpdateRoadEvent;

/*
 * Assumptions:
 * 1. The FieldDevice location_type is to be trusted completely
 * 2. Each time an update is requested, 
 * 
 * Methodology:
 * - Each time an update is requested, the 'change' will be compared against the state 
 * of the system at last update
 * - If that component has changed sufficiently*, then the message will be updated
 * and the update will be pushed out, including the new updated state
 * - If that component has not changed sufficiently*, then no update is issued. 
 * - TODO: Flag discrepencies between data types and submit to ConAdmin for review
 *     - This change tracking is used to ensure that conflicting updates do not occur,
 * such as a recording and a field device offering different information
 * 
 * Change criteria
 * - report - any change
 * - recording - any change
 * - field_device
 *     - update_time: no
 *     - position: moved by position-filter-radius-meters (configurable)
 *     - 
 * 
 * Thoughts
 * - Utilize a priority? If a report is submitted which minorly disagrees with a recording or field devices... which to trust?
 *     - what could cause a disagreement
 *     i. true change - latest report should always be trusted
 *     ii. incorrect field device location_type
 *     iii. lack of accuracy in either value
 * - Identify when information is lacking in some areas/events, and note that - possibly 
 * submit request to ConAdmin for additional information
 * 
 * Allowed update types
 * 1. report -> change geometry and metadata
 * 2. recording -> change geometry and some metadata
 * 3. field_device
 *      i. static - point
 *          1. device_type is worker
 *              i. Update event location to worker location
 *      ii. static - LineString
 *          1. device_type is worker
 *              i. If within road event geometry, add worker presence zone around worker
 *              ii. If outside, NO ACTION TAKEN
 *      iii. static - polygon
 *          1. If within polygon, update properties based on state
 *          2. Else, NO ACTION TAKEN
 *      ii. planned_moving_area - any
 *          1. device_type: vehicle, mobile worker, arrow board (is_moving=true)
 *              i. overwrite event location with mobile location, ideally generating geometry ahead
 *          2. Else, NO ACTION TAKEN
 * 
 * 
 *  Field device 
 *  // TODO: Define how to handle static arrow board states
 *  1. ArrowBoard
 *      State: ARROW_BOARD_PATTERN_RIGHT_ARROW_FLASHING, ARROW_BOARD_PATTERN_RIGHT_ARROW_SEQUENTIAL
 *          1. vehicle_impact: some-lanes-closed-merge-left
 *      State: ARROW_BOARD_PATTERN_LEFT_ARROW_FLASHING, ARROW_BOARD_PATTERN_LEFT_ARROW_SEQUENTIAL
 *          1. vehicle_impact: some-lanes-closed-merge-right
 *      State: ARROW_BOARD_PATTERN_RIGHT_CHEVRON_FLASHING, ARROW_BOARD_PATTERN_RIGHT_CHEVRON_SEQUENTIAL
 *          1. all-lanes-open-shift-left
 *      State: ARROW_BOARD_PATTERN_LEFT_CHEVRON_FLASHING, ARROW_BOARD_PATTERN_LEFT_CHEVRON_SEQUENTIAL
 *          1. all-lanes-open-shift-right
 *      State: ARROW_BOARD_PATTERN_BIDIRECTIONAL_ARROW_FLASHING
 *          1. some-lanes-closed-split
 *  2. LocationMarker
 *      i. MarkedLocationType.MARKED_LOCATION_TYPE_ROAD_EVENT_START
 *      ii. MarkedLocationType.MARKED_LOCATION_TYPE_ROAD_EVENT_END
 *          
 *  3. MobileVehicle
 *  4. FieldWorker
 */

@Slf4j
@Component
@RequiredArgsConstructor
public class FieldDeviceUpdateProcessor {
    static long DATAHUB_ROAD_EVENT_ID_PREFIX_FIELD_DEVICE = 44992L;
    private final AuditBus auditBus;
    private final RoadEventRepository roadEventRepository;
    private final FieldDeviceLinkRepository fieldDeviceRepository;
    private final FieldDeviceReadingRepository fieldDeviceReadingRepository;
    private final FieldDeviceUpdateController fieldDeviceUpdateController;
    private final UpdateProcessorProperties updateProcessorProperties;
    private final GisService gisService;
    private final ObservationUpdateProcessor observationUpdateProcessor;

    @Autowired
    private KafkaTemplate<String, DataHubRoadEventUpdate> template; // Multicast sink allows multiple subscribers
    Many<Pair<Long, FieldDeviceReading>> updateSink = Sinks.many().multicast().onBackpressureBuffer();

    /**
     * Initialize the observation stream listener on bean creation
     * This starts processing observations automatically
     */
    @PostConstruct
    public void startObservationListener() {
        getObservationStream()
                .filter(v -> !v.getSecond().isEmpty())
                .publishOn(Schedulers.boundedElastic()) // allow blocking calls
                .subscribe(
                        pair -> {
                            Long roadEventId = pair.getFirst();
                            Map<String, FieldDeviceReading> readingMap = pair.getSecond();
                            List<FieldDeviceReading> readings = new ArrayList<>(readingMap.values());

                            handleMultipleReadingsAtOnce(roadEventId, readings);
                        },
                        error -> log.error("Error in observation stream", error),
                        () -> log.info("Observation stream completed"));
    }

    public void addReading(Long roadEventId, FieldDeviceReading obj) {
        updateSink.tryEmitNext(new Pair<>(roadEventId, obj));
    }

    /**
     * Get the observation stream grouped by worker ID.
     * Buffers all updates for 1 minute starting from the first event.
     * Emits ONLY the final aggregated state once the minute is over.
     */
    public Flux<Pair<Long, Map<String, FieldDeviceReading>>> getObservationStream() {
        return updateSink.asFlux()
                .subscribeOn(reactor.core.scheduler.Schedulers.boundedElastic()) // Allow blocking calls
                .groupBy(Pair::getFirst, Pair::getSecond)
                .flatMap(group -> group
                        // Create a window that starts on the first event
                        .windowTimeout(Integer.MAX_VALUE, updateProcessorProperties.getFieldDeviceMaxReUpdatePeriod())
                        .flatMap(window -> window
                                // reduce() collects everything until the window closes,
                                // then emits exactly one Map.
                                .reduce(new HashMap<String, FieldDeviceReading>(), (acc, update) -> {
                                    acc.put(update.getDevice().getId(), update);
                                    return acc;
                                }))
                        // Map the final aggregated result to your Pair
                        .map(finalMap -> new Pair<>(group.key(), finalMap)));
    }

    public void handleNewFieldDeviceReading(FieldDeviceReading fieldDeviceReading, Boolean shouldProcessUpdate) {
        handleNewFieldDeviceReading(fieldDeviceReading, shouldProcessUpdate, null);
    }

    public void handleNewFieldDeviceReading(FieldDeviceReading fieldDeviceReading, Boolean shouldProcessUpdate,
            Integer sabpCompass) {
        if (sabpCompass != null) {
            // TODO: Integrate SABP display.compass into field-device update behavior.
            log.debug("SABP compass {} available for device ID {}.", sabpCompass,
                    fieldDeviceReading.getDevice().getId());
        }

        Pair<Long, Boolean> response = getAndSyncRoadEventIdForReading(fieldDeviceReading);
        Long roadEventId = response.getFirst();
        Boolean isNew = response.getSecond();

        fieldDeviceReadingRepository.insert(fieldDeviceReading);
        if (!shouldProcessUpdate) {
            log.debug("Field device updates are disabled. Skipping update for device ID {}.",
                    fieldDeviceReading.getDevice().getId());
            return;
        }
        DataHubFieldDeviceUpdate update = createFieldDeviceUpdate(fieldDeviceReading, isNew);
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
                addReading(roadEventId, fieldDeviceReading);
            }
        } else {
            log.info("No RoadEvent linked to FieldDevice ID {}. Skipping update.",
                    fieldDeviceReading.getDevice().getId());
        }
    }

    public Pair<Long, Boolean> getAndSyncRoadEventIdForReading(FieldDeviceReading reading) {
        FieldDevice fieldDevice = reading.getDevice();
        List<FieldDeviceLink> links = fieldDeviceRepository
                .find(fieldDevice.getId(), null, null, null, null,
                        PageRequest.of(0, 1))
                .getContent();
        FieldDeviceLink fieldDeviceLink = null;
        if (links.size() == 0) {
            // New field device - create link
            log.debug("New field device reading for device ID {}. Creating new link.",
                    fieldDevice.getId());
            fieldDeviceLink = new FieldDeviceLink(System.currentTimeMillis(), fieldDevice);
            fieldDeviceRepository.update(fieldDeviceLink.getDeviceId(), fieldDeviceLink);
        } else {
            fieldDeviceLink = links.getFirst();
        }

        if (fieldDevice.hasRoadEventId()) {
            fieldDeviceLink.setRoadEventId(fieldDevice.getRoadEventId());
            fieldDeviceRepository.update(fieldDeviceLink.getDeviceId(), fieldDeviceLink);
            return new Pair<>(fieldDevice.getRoadEventId(), links.size() == 0);
        } else if (fieldDeviceLink.getRoadEventId() != null) {
            Long roadEventId = fieldDeviceLink.getRoadEventId();
            return new Pair<>(roadEventId, links.size() == 0);
        }
        return new Pair<>(null, links.size() == 0);
    }

    public void updateFieldDeviceLink(String deviceId, Long roadEventId) {
        List<FieldDeviceLink> links = fieldDeviceRepository
                .find(deviceId, null, null, null, null,
                        PageRequest.of(0, 1))
                .getContent();
        if (links.size() == 0) {
            log.warn("Attempted to update FieldDeviceLink for device ID {} but no link was found.",
                    deviceId);
            throw new IllegalArgumentException("No FieldDeviceLink found for device ID " + deviceId);
        }
        FieldDeviceLink fieldDeviceLink = links.getFirst();
        fieldDeviceLink.setRoadEventId(roadEventId);
        fieldDeviceRepository.update(fieldDeviceLink.getDeviceId(), fieldDeviceLink);
    }

    public void handleMultipleReadingsAtOnce(Long roadEventId, List<FieldDeviceReading> fieldDeviceReadings) {
        RoadEventWrapper existingRoadEvent = roadEventRepository
                .find(roadEventId, null, null, null, null, null, null, null, PageRequest.of(0, 1))
                .getContent().stream().findFirst().orElse(null);
        if (existingRoadEvent == null) {
            log.error("No existing RoadEvent found for RoadEvent ID {}. Skipping updates.", roadEventId);
            return;
        }

        fieldDeviceReadings = fieldDeviceReadings.stream()
                .map((reading) -> {
                    // TODO: Set project ID
                    // Long projectId = fieldDeviceLink.getProjectId();
                    FieldDevice.Builder builder = reading.getDevice().toBuilder();
                    builder.setRoadEventId(roadEventId);
                    // ProtobufUtils.setIfNotNull(projectId, builder::setProjectId);
                    FieldDevice newFieldDevice = builder.build();
                    return reading.withUpdatedDevice(newFieldDevice);
                })
                .collect(Collectors.toList());

        List<Observation<?>> allFieldDeviceObservations = new ArrayList<>();
        for (FieldDeviceReading reading : fieldDeviceReadings) {
            List<Observation<?>> fieldDeviceObservations = Observation.fromFieldDevice(gisService, reading,
                    existingRoadEvent.getRouteAndMeasureRange());
            allFieldDeviceObservations.addAll(fieldDeviceObservations);
        }
        DataHubRoadEventUpdate updateMessage = updateDataHubRoadEventFromFieldDevices(
                fieldDeviceReadings,
                allFieldDeviceObservations,
                existingRoadEvent);
        if (updateMessage != null) {
            this.template.send(KafkaTopics.DATAHUB_ROAD_EVENT,
                    String.valueOf(updateMessage.getRequestId()),
                    updateMessage);
        } else {
            log.warn("No RoadEvent update created for RoadEvent ID {}.", roadEventId);
        }
    }

    public DataHubRoadEventUpdate updateDataHubRoadEventFromFieldDevice(FieldDeviceReading fieldDeviceReading,
            List<Observation<?>> fieldDeviceObservations, RoadEventWrapper prevRoadEventWrapper) {
        long requestId = ProtobufUtils.generateRequestId(fieldDeviceReading.getDevice().getId());
        DataHubRoadEventUpdate.Builder builder = DataHubRoadEventUpdate.newBuilder()
                .setRequestId(requestId)
                .setTimestamp(ProtobufUtils.timestampFromMillis(System.currentTimeMillis()));

        auditBus.startSession(prevRoadEventWrapper.getRoadEvent().getId(), prevRoadEventWrapper);
        auditBus.record(prevRoadEventWrapper.getRoadEvent().getId(),
                "Updating RoadEvent from FieldDevice ID " + fieldDeviceReading.getDevice().getId(),
                AuditLogSeverity.INFO);

        List<Observation<?>> observations = new ArrayList<>(prevRoadEventWrapper.getObservations());
        observations.addAll(fieldDeviceObservations);

        RoadEventWrapper roadEventWrapper = observationUpdateProcessor
                .newRoadEventFromObservations(prevRoadEventWrapper.getRoadEvent().getId(), observations);

        if (roadEventWrapper == null) {
            auditBus.terminateSession(prevRoadEventWrapper.getRoadEvent().getId(),
                    "Unable to create RoadEvent from FieldDevice ID, null roadEventWrapper");
            return null;
        } else if (UpdateProcessorUtils.compareRoadEventWrappers(roadEventWrapper, prevRoadEventWrapper,
                updateProcessorProperties)) {
            auditBus.terminateSession(prevRoadEventWrapper.getRoadEvent().getId(),
                    "No changes detected for RoadEvent ID " + prevRoadEventWrapper.getRoadEvent().getId() +
                            " from FieldDevice ID " + fieldDeviceReading.getDevice().getId());
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
        auditBus.submitAudit(prevRoadEventWrapper.getRoadEvent().getId(), audit);

        return update;
    }

    public DataHubRoadEventUpdate updateDataHubRoadEventFromFieldDevices(List<FieldDeviceReading> fieldDeviceReadings,
            List<Observation<?>> fieldDeviceObservations, RoadEventWrapper prevRoadEventWrapper) {
        long requestId = ProtobufUtils.generateRequestId(fieldDeviceReadings.getFirst().getDevice().getId());
        DataHubRoadEventUpdate.Builder builder = DataHubRoadEventUpdate.newBuilder()
                .setRequestId(requestId)
                .setTimestamp(ProtobufUtils.timestampFromMillis(System.currentTimeMillis()));

        auditBus.startSession(prevRoadEventWrapper.getRoadEvent().getId(), prevRoadEventWrapper);
        auditBus.record(prevRoadEventWrapper.getRoadEvent().getId(),
                "Updating RoadEvent from FieldDevices " + fieldDeviceReadings.stream()
                        .map(fd -> fd.getDevice().getId())
                        .collect(Collectors.toList()),
                AuditLogSeverity.INFO);

        List<Observation<?>> observations = new ArrayList<>(prevRoadEventWrapper.getObservations());
        observations.addAll(fieldDeviceObservations);

        RoadEventWrapper roadEventWrapper = observationUpdateProcessor
                .newRoadEventFromObservations(prevRoadEventWrapper.getRoadEvent().getId(), observations);

        if (roadEventWrapper == null) {
            // Unable to create road event from report - report was invalid or out of date
            auditBus.terminateSession(prevRoadEventWrapper.getRoadEvent().getId(),
                    "Unable to create RoadEvent from FieldDevices, null roadEventWrapper");
            return null;
        } else if (UpdateProcessorUtils.compareRoadEventWrappers(roadEventWrapper, prevRoadEventWrapper,
                updateProcessorProperties)) {
            // No changes detected
            auditBus.terminateSession(prevRoadEventWrapper.getRoadEvent().getId(),
                    "No changes detected after field device updates applied");
            return null;
        }
        roadEventRepository.update(prevRoadEventWrapper.getRoadEvent().getId(), roadEventWrapper);

        FieldDeviceSummaryArray.Builder summaryArrayBuilder = FieldDeviceSummaryArray.newBuilder();

        for (FieldDeviceReading fieldDeviceReading : fieldDeviceReadings) {
            FieldDeviceSummary summary = FieldDeviceSummary.newBuilder()
                    .setId(Math.abs(
                            fieldDeviceReading.getDevice().getId()
                                    .hashCode()))
                    .setDevice(fieldDeviceReading.getDevice())
                    .setUpdateDate(ProtobufUtils.timestampFromInstant(fieldDeviceReading.getLastUpdated()))
                    .build();
            summaryArrayBuilder.addFieldDeviceSummary(summary);
        }
        DataHubUpdateSource source = DataHubUpdateSource.newBuilder()
                .setFieldDeviceSummaries(summaryArrayBuilder.build())
                .build();
        UpdateRoadEvent updateEvent = UpdateRoadEvent.newBuilder()
                .setRoadEvent(roadEventWrapper.getRoadEvent())
                .setSource(source)
                .addAllRoadSubEvents(roadEventWrapper.getUnwrappedRoadSubEvents())
                .build();

        builder.setUpdated(updateEvent);

        DataHubRoadEventUpdate update = builder.build();

        RoadEventAudit audit = UpdateProcessorUtils.auditFromWrapper(roadEventWrapper, prevRoadEventWrapper, update);
        auditBus.submitAudit(prevRoadEventWrapper.getRoadEvent().getId(), audit);

        return update;
    }

    public static DataHubFieldDeviceUpdate createFieldDeviceUpdate(
            FieldDeviceReading fieldDeviceReading, boolean isNew) {
        long requestId = ProtobufUtils.generateRequestId(fieldDeviceReading.getDevice().getId()); // convert ID to long
        if (isNew) {
            // create random Long
            return DataHubFieldDeviceUpdate.newBuilder()
                    .setRequestId(requestId)
                    .setCreated(CreateFieldDevice.newBuilder()
                            .setFieldDevice(fieldDeviceReading.getDevice())
                            .build())
                    .build();
        } else {
            return DataHubFieldDeviceUpdate.newBuilder()
                    .setRequestId(requestId)
                    .setUpdated(UpdateFieldDevice.newBuilder()
                            .setFieldDevice(fieldDeviceReading.getDevice())
                            .build())
                    .build();
        }
    }

    public DataHubRoadEventUpdate createDataHubRoadEventUpdateFromFieldDevice(FieldDeviceReading fieldDeviceReading) {
        FieldDevice fieldDevice = fieldDeviceReading.getDevice();
        long requestId = ProtobufUtils.generateRequestId(fieldDevice.getId()); // convert ID to long
        DataHubRoadEventUpdate.Builder builder = DataHubRoadEventUpdate.newBuilder()
                .setRequestId(requestId)
                .setTimestamp(ProtobufUtils.timestampFromMillis(System.currentTimeMillis()));

        if (!fieldDevice.hasRoadEventId()) {
            log.info("Field device is not associated with a RoadEvent. Cannot create RoadEvent update.");
            return null;
        }
        long roadEventId = fieldDevice.getRoadEventId();
        List<FieldDeviceLink> fieldDeviceLinks = fieldDeviceRepository
                .find(null, null, roadEventId, null, null,
                        PageRequest.of(0, 1))
                .getContent();

        List<FieldDeviceReading> fieldDeviceReadings = fieldDeviceLinks.stream()
                .map(fieldDeviceLink -> fieldDeviceReadingRepository.findLatest(
                        fieldDeviceLink.getDeviceId(), null,
                        null))
                .filter(v -> v != null)
                .filter(v -> v.getDevice().getId() != fieldDevice.getId()) // Exclude the current device
                .toList();

        List<RoadEventWrapper> roadEvents = roadEventRepository
                .find(fieldDevice.getRoadEventId(), null, null, null, null, null, null, null, PageRequest.of(0, 1))
                .getContent();
        if (roadEvents.isEmpty()) {
            log.error(
                    "No existing RoadEvent found for fieldDevice ID {} with RoadEvent ID {}. Creating a new RoadEvent.",
                    fieldDevice.getId(), fieldDevice.getRoadEventId());
            throw new IllegalArgumentException(
                    "No existing RoadEvent found for fieldDevice ID " + fieldDevice.getId()
                            + " with RoadEvent ID " + fieldDevice.getRoadEventId());
        }

        RoadEventWrapper existingRoadEvent = roadEvents.getFirst();
        UpdateRoadEvent roadEvent = updateRoadEventFromFieldDevice(existingRoadEvent, fieldDeviceReading,
                fieldDeviceReadings);
        builder.setUpdated(roadEvent);

        return builder.build();
    }

    private UpdateRoadEvent updateRoadEventFromFieldDevice(RoadEventWrapper existingRoadEventWrapper,
            FieldDeviceReading fieldDeviceReading, List<FieldDeviceReading> additionalFieldDeviceReadings) {
        // TODO: Only update non-null fields
        Instant fieldDeviceTimestamp = fieldDeviceReading.getLastUpdated();
        RoadEvent existingRoadEvent = existingRoadEventWrapper.getRoadEvent();
        FieldDeviceReading fieldDevice = fieldDeviceReading;
        Instant startDate = ProtobufUtils.instantFromTimestamp(existingRoadEvent.getStartDate());
        if (startDate == null || startDate.isAfter(fieldDeviceTimestamp)) {
            startDate = fieldDeviceTimestamp;
        }
        Instant endDate = ProtobufUtils.instantFromTimestamp(existingRoadEvent.getEndDate());
        if (endDate != null && endDate.isBefore(fieldDeviceTimestamp)) {
            endDate = fieldDeviceTimestamp
                    .plus(updateProcessorProperties.getFieldDeviceMaxReUpdatePeriod());
        }
        RoadEvent.Builder builder = existingRoadEvent.toBuilder()
                // .clearRoadSections() // Replace road section links
                // .addAllRoadSections(List.of()) // Added below
                .setStatus(RoadEventActiveStatus.ROAD_EVENT_ACTIVE_STATUS_ACTIVE)
                .setStartDate(ProtobufUtils.timestampFromInstant(startDate))
                .setEndDate(ProtobufUtils.timestampFromInstant(startDate));
        // TODO: Update position of event if different from existing event
        // no need to update linked field devices, as they are not included in a
        // FieldDevice

        RoadEvent roadEvent = builder.build();
        List<RoadSubEvent> roadSubEvents = existingRoadEventWrapper.getUnwrappedRoadSubEvents();
        // rseListFromFieldDevice(fieldDevice, roadEvent); // TODO: Regenerate
        // // RoadSubEvents from FieldDevice if geometry or worker presence is altered
        roadSubEvents = UpdateProcessorUtils.addRseLinks(roadSubEvents);
        // builder.addAllRoadSections(rseLinks);
        builder = roadEvent.toBuilder();

        List<FieldDeviceSummary> summaries = new ArrayList<>();
        summaries.add(FieldDeviceSummary.newBuilder()
                .setId(0L)
                .setDevice(fieldDevice.getDevice())
                .setUpdateDate(ProtobufUtils.timestampFromInstant(fieldDeviceTimestamp))
                .build());
        for (FieldDeviceReading reading : additionalFieldDeviceReadings) {
            summaries.add(FieldDeviceSummary.newBuilder()
                    .setId(0L)
                    .setDevice(reading.getDevice())
                    .setUpdateDate(ProtobufUtils.timestampFromInstant(reading.getLastUpdated()))
                    .build());
        }
        DataHubUpdateSource source = DataHubUpdateSource.newBuilder()
                .setFieldDeviceSummaries(FieldDeviceSummaryArray.newBuilder().addAllFieldDeviceSummary(summaries))
                .build();
        UpdateRoadEvent updateEvent = UpdateRoadEvent.newBuilder()
                .setRoadEvent(builder.build())
                .setSource(source)
                .addAllRoadSubEvents(roadSubEvents)
                .build();

        return updateEvent;
    }
}
