package com.wydot.wz_datahub.api.update_processors;

import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.ProtobufUtils;
import com.wydot.wz_datahub.api.accessors.road_event.RoadEventRepository;
import com.wydot.wz_datahub.api.models.audit.AuditLogSeverity;
import com.wydot.wz_datahub.api.models.gis_service.LatLngAndMilepost;
import com.wydot.wz_datahub.api.models.gis_service.RouteAndMeasure;
import com.wydot.wz_datahub.api.models.gis_service.RouteAndMeasureRange;
import com.wydot.wz_datahub.api.models.update_processing.Observation;
import com.wydot.wz_datahub.api.models.update_processing.ObservationMetadata;
import com.wydot.wz_datahub.api.models.update_processing.ObservationSource;
import com.wydot.wz_datahub.api.models.update_processing.ObservationType;
import com.wydot.wz_datahub.api.models.update_processing.values.LaneStatusValue;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventUpdateStatus;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventWrapper;
import com.wydot.wz_datahub.api.models.wrappers.RoadSubEventWrapper;
import com.wydot.wz_datahub.api.utilities.Units;
import com.wydot.wz_datahub.api.utilities.gis_service.GisService;

import kotlin.Pair;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.EventRecurrence;
import wyo.dot.protobuf.Lane;
import wyo.dot.protobuf.MarkedLocationType;
import wyo.dot.protobuf.RoadEvent;
import wyo.dot.protobuf.RoadSubEvent;
import wyo.dot.protobuf.VehicleImpact;
import wyo.dot.protobuf.RoadEvent.RoadEventActiveStatus;
import wyo.dot.protobuf.RoadSubEvent.BaseLayer;
import wyo.dot.protobuf.RoadSubEvent.SpeedReductionLayer;
import wyo.dot.protobuf.RoadSubEvent.WorkerPresenceLayer;

@Slf4j
@Component
@RequiredArgsConstructor
public class ObservationUpdateProcessor {
    private final GisService gisService;
    private final AuditBus auditBus;
    private final UpdateProcessorProperties updateProcessorProperties;
    private final RoadEventRepository roadEventRepository;

    public RoadEventWrapper newRoadEventFromObservations(Long roadEventId, List<Observation<?>> observations) {
        // Unhandled Edge Cases
        // 1. Early reading opens event earlier
        // 2. Late reading retains event open longer
        // 3. Observations slightly outside of the start/end expanding event range (this
        // is more for updates though...)

        observations = observations.stream()
                .filter(ObservationUpdateProcessor::filterValidObservation)
                .map((obs) -> updateConfidenceScore(obs))
                .collect(Collectors.toList());
        observations = deduplicateObservationsBySource(observations);

        Map<ObservationType, List<Observation<?>>> partitioned = observations.stream()
                .collect(Collectors.groupingBy(Observation::getType));

        // Start with start and end locations from observations
        List<Observation<?>> startLocations = partitioned.getOrDefault(ObservationType.EVENT_START, List.of());
        auditBus.record(roadEventId, "startLocations: " + startLocations.size(), AuditLogSeverity.INFO);
        List<Observation<?>> endLocations = partitioned.getOrDefault(ObservationType.EVENT_END, List.of());
        auditBus.record(roadEventId, "endLocations: " + endLocations.size(), AuditLogSeverity.INFO);

        if (startLocations.isEmpty() || endLocations.isEmpty()) {
            auditBus.record(roadEventId, "Insufficient start/end observations", AuditLogSeverity.WARN);
            return null;
        }
        RouteAndMeasure startMeasure = getStartMeasure(startLocations);
        RouteAndMeasure endMeasure = getEndMeasure(endLocations);
        if (startMeasure == null || endMeasure == null || !startMeasure.getRouteId().equals(endMeasure.getRouteId())) {
            auditBus.record(roadEventId, "Invalid start/end measures to create RoadEvent", AuditLogSeverity.WARN);
            return null;
        }
        RouteAndMeasureRange routeRange = RouteAndMeasureRange.fromMeasures(startMeasure, endMeasure);

        List<Observation<?>> allObservations = partitioned.values().stream()
                .flatMap(List::stream)
                .toList();
        Pair<List<Observation<?>>, List<Observation<?>>> splitObservations = filterObservationsByRouteId(
                allObservations,
                routeRange);

        List<Observation<?>> within = splitObservations.getFirst();
        Map<ObservationType, List<Observation<?>>> partitionedWithin = within.stream()
                .collect(Collectors.groupingBy(Observation::getType));
        List<Observation<?>> outside = splitObservations.getSecond();
        Map<ObservationType, List<Observation<?>>> partitionedOutside = outside.stream()
                .collect(Collectors.groupingBy(Observation::getType));
        if (!partitionedOutside.isEmpty()) {
            // TODO: Handle new observations outside the event
            auditBus.record(roadEventId,
                    "Some observations are outside the event route range: " + partitionedOutside.size(),
                    AuditLogSeverity.WARN);
        }

        // TODO: Ensure required fields are present
        ObservationMetadata metadata = aggregateLatestMetadata(
                filterByType(partitionedWithin.getOrDefault(ObservationType.METADATA, List.of()),
                        ObservationMetadata.class));
        if (metadata == null) {
            metadata = aggregateLatestMetadata(
                    filterByType(partitionedOutside.getOrDefault(ObservationType.METADATA, List.of()),
                            ObservationMetadata.class));
            if (metadata == null) {
                auditBus.record(roadEventId, "Insufficient metadata observations to create RoadEvent",
                        AuditLogSeverity.WARN);
                return null;
            }
        }

        // TODO: Dynamically define project schedule
        RoadEvent.Builder baseRoadEventBuilder = metadata.applyToRoadEvent(RoadEvent.newBuilder());
        baseRoadEventBuilder.setId(roadEventId);

        // Project ID
        RoadEventWrapper existingRoadEventWrapper = roadEventRepository
                .find(roadEventId, null, null, null, null, null, null, null, PageRequest.of(0, 1))
                .getContent().stream().findFirst().orElse(null);
        if (metadata.getProjectId() != null) {
            baseRoadEventBuilder.setProjectId(metadata.getProjectId());
        } else if (existingRoadEventWrapper != null && existingRoadEventWrapper.getRoadEvent().hasProjectId()) {
            baseRoadEventBuilder.setProjectId(existingRoadEventWrapper.getRoadEvent().getProjectId());
        }

        RoadSubEvent.Builder roadSubEventBuilderBase = metadata.applyToRoadSubEventBase(RoadSubEvent.newBuilder());
        RoadSubEvent.Builder roadSubEventBuilderWorkerPresence = metadata
                .applyToRoadSubEventWorkerPresence(RoadSubEvent.newBuilder());
        RoadSubEvent.Builder roadSubEventBuilderSpeedReduction = metadata
                .applyToRoadSubEventSpeedReduction(RoadSubEvent.newBuilder());

        List<Observation<EventRecurrence>> workerPresenceObservations = filterByType(partitionedWithin.getOrDefault(
                ObservationType.WORKER_PRESENCE,
                List.of()), EventRecurrence.class);
        List<Observation<Integer>> speedReductionObservations = filterByType(partitionedWithin
                .getOrDefault(ObservationType.SPEED_REDUCTION_ZONE, List.of()), Integer.class);
        List<Observation<LaneStatusValue>> laneStatusObservations = filterByType(partitionedWithin.getOrDefault(
                ObservationType.LANE_STATUS_ZONE,
                List.of()), LaneStatusValue.class);

        List<RoadSubEvent> roadSubEvents = generateRoadSubEventsBase(roadSubEventBuilderBase.clone(), routeRange,
                laneStatusObservations, metadata);

        if (roadSubEvents.isEmpty()) {
            log.warn("No base road sub events available to create RoadSubEvent");
            return null;
        }

        roadSubEvents = UpdateProcessorUtils.addRseLinks(roadSubEvents);
        List<RoadSubEvent> speedReductionSubEvents = generateRoadSubEventsSpeedReduction(
                roadSubEventBuilderSpeedReduction.clone(),
                routeRange,
                speedReductionObservations);
        roadSubEvents.addAll(speedReductionSubEvents);
        List<RoadSubEvent> workerPresenceSubEvents = generateRoadSubEventsWorkerPresence(
                roadSubEventBuilderWorkerPresence.clone(), routeRange,
                workerPresenceObservations);
        roadSubEvents.addAll(workerPresenceSubEvents);

        // Add geometry
        List<LatLngAndMilepost> geometry = gisService.getRouteGeometryWithMeasures(routeRange).block();
        if (geometry == null || geometry.isEmpty()) {
            throw new IllegalStateException("No geometry available for route range: " + routeRange.toString());
        }
        baseRoadEventBuilder.setLineString(UpdateProcessorUtils.getLineStringFromLatLngs(
                geometry.stream().map(LatLngAndMilepost::getLatLng).toList()));

        List<RoadSubEventWrapper> roadSubEventWrappers = new ArrayList<>();
        for (RoadSubEvent.Builder subEventBuilder : roadSubEvents.stream().map(RoadSubEvent::toBuilder).toList()) {
            // Don't trust measure values. Need to find the closest measure in geometry
            double beginMeasure = subEventBuilder.getBeginningMilepost();
            double endingMeasure = subEventBuilder.getEndingMilepost();
            Double closestBeginMeasure = findClosestMeasure(geometry, beginMeasure);
            Double closestEndMeasure = findClosestMeasure(geometry, endingMeasure);

            RouteAndMeasure closestBegin = gisService
                    .translateMeasure(
                            new RouteAndMeasure(routeRange.getRouteId(), routeRange.getTranslatedRouteId(),
                                    closestBeginMeasure, null))
                    .block();
            RouteAndMeasure closestEnd = gisService
                    .translateMeasure(
                            new RouteAndMeasure(routeRange.getRouteId(), routeRange.getTranslatedRouteId(),
                                    closestEndMeasure, null))
                    .block();

            if (closestBegin == null || closestEnd == null) {
                auditBus.record(roadEventId,
                        "Could not find closest measure in geometry for subEvent: " + subEventBuilder.getId(),
                        AuditLogSeverity.WARN);
                continue;
            }
            subEventBuilder.setRouteId(closestBegin.getTranslatedRouteId());
            subEventBuilder.setBeginningMilepost(closestBegin.getTranslatedMeasure());
            subEventBuilder.setEndingMilepost(closestEnd.getTranslatedMeasure());
            subEventBuilder.setLineString(UpdateProcessorUtils.getLineStringFromLatLngs(
                    geometry.stream()
                            .filter((p) -> routeRange.isRouteDec()
                                    ? p.getMeasure() <= closestBegin.getMeasure()
                                            && p.getMeasure() >= closestEnd.getMeasure()
                                    : p.getMeasure() >= closestBegin.getMeasure()
                                            && p.getMeasure() <= closestEnd.getMeasure())
                            .map(LatLngAndMilepost::getLatLng)
                            .toList()));
            if (subEventBuilder.getLineString().getCoordinates().getCoordinatesCount() <= 1) {
                // Add next point to LineString
                LatLngAndMilepost nextPoint = geometry.stream()
                        .filter((p) -> routeRange.isRouteDec()
                                ? p.getMeasure() < closestBegin.getMeasure()
                                        && p.getMeasure() > closestEnd.getMeasure()
                                : p.getMeasure() > closestBegin.getMeasure()
                                        && p.getMeasure() < closestEnd.getMeasure())
                        .findFirst().orElse(null);
                if (nextPoint != null) {
                    subEventBuilder.setLineString(UpdateProcessorUtils.getLineStringFromLatLngs(
                            List.of(nextPoint.getLatLng())));
                } else {
                    auditBus.record(roadEventId,
                            "1 or no geometry points found for subEvent, skipping: " + subEventBuilder.getId()
                                    + ", layer: "
                                    + subEventBuilder.getLayerCase(),
                            AuditLogSeverity.WARN);
                    continue;
                }
            }
            RouteAndMeasureRange rmr = RouteAndMeasureRange.fromMeasures(closestBegin, closestEnd);
            String roadName = gisService.getRoadName(rmr).block();
            if (roadName != null) {
                subEventBuilder.addRoadNames(roadName);
            }
            roadSubEventWrappers.add(new RoadSubEventWrapper(subEventBuilder.build(), List.of(), rmr));
        }

        Instant updateDate = Instant.now();
        RoadEvent roadEvent = baseRoadEventBuilder.build();
        RoadEventUpdateStatus updateStatus = new RoadEventUpdateStatus(
                RoadEventUpdateStatus.SourceType.CON_ADMIN,
                RoadEventUpdateStatus.ApprovalStatus.APPROVED,
                UpdateProcessorUtils.determineEventStatus(roadEvent),
                updateDate,
                updateDate,
                "DATAHUB_CREATION");

        RoadEventWrapper roadEventWrapper = new RoadEventWrapper();
        roadEventWrapper.setRoadEvent(baseRoadEventBuilder.build());
        roadEventWrapper.setRoadSubEvents(roadSubEventWrappers);
        roadEventWrapper.setObservations(observations);
        roadEventWrapper.setRouteAndMeasureRange(routeRange);
        roadEventWrapper.setLastUpdated(Instant.now());
        roadEventWrapper.setNumLanes(metadata.getNumLanes());
        roadEventWrapper.setUpdateHistory(List.of(updateStatus));

        List<RoadSubEventWrapper> baseSubEvents = roadEventWrapper.getRoadSubEvents().stream()
                .filter((subEventWrapper) -> subEventWrapper.getRoadSubEvent().hasBaseLayer())
                .toList();
        if (baseSubEvents.isEmpty()) {
            auditBus.record(roadEventId, "No valid base sub-events could be created", AuditLogSeverity.WARN);
            return null;
        }

        return roadEventWrapper;
    }

    /**
     * Casts a list of observations to a specific value type.
     * This is a type-safe helper to avoid unchecked cast warnings.
     * 
     * @param <T>          The value type for the observations
     * @param observations The list of wildcard observations
     * @param valueClass   The class of the value type (used for type safety only)
     * @return A typed list of observations
     */
    @SuppressWarnings("unchecked")
    public static <T> List<Observation<T>> filterByType(List<Observation<?>> observations, Class<T> valueClass) {
        return (List<Observation<T>>) (List<?>) observations;
    }

    public static RoadEventWrapper terminateRoadEvent(RoadEventWrapper existingRoadEvent, Instant eventEndTime,
            RoadEventUpdateStatus updateStatus) {
        RoadEvent.Builder roadEventBuilder = existingRoadEvent.getRoadEvent().toBuilder();
        roadEventBuilder.setStatus(RoadEventActiveStatus.ROAD_EVENT_ACTIVE_STATUS_INACTIVE);
        if (roadEventBuilder.hasDefaultSchedule()) {
            roadEventBuilder
                    .setDefaultSchedule(terminateEventRecurrence(roadEventBuilder.getDefaultSchedule(), eventEndTime));
        }
        if (!roadEventBuilder.hasEndDate()
                || ProtobufUtils.instantFromTimestamp(roadEventBuilder.getEndDate()).isAfter(eventEndTime)) {
            roadEventBuilder.setEndDate(ProtobufUtils.timestampFromInstant(eventEndTime));
        }

        List<RoadSubEventWrapper> subEventWrappers = existingRoadEvent.getRoadSubEvents().stream()
                .map((subEventWrapper) -> {
                    RoadSubEvent.Builder subEventBuilder = subEventWrapper.getRoadSubEvent().toBuilder();
                    if (subEventBuilder.hasSchedule()) {
                        subEventBuilder.setSchedule(
                                terminateEventRecurrence(subEventBuilder.getSchedule(), eventEndTime));
                    }
                    return new RoadSubEventWrapper(
                            subEventBuilder.build(),
                            subEventWrapper.getObservations(),
                            subEventWrapper.getRouteAndMeasureRange());
                }).toList();

        List<RoadEventUpdateStatus> history = existingRoadEvent.getUpdateHistory() == null
                ? List.of()
                : existingRoadEvent.getUpdateHistory();

        return new RoadEventWrapper(
                roadEventBuilder.build(),
                subEventWrappers,
                existingRoadEvent.getObservations(),
                existingRoadEvent.getRouteAndMeasureRange(),
                Instant.now(),
                null,
                Stream.concat(history.stream(), Stream.of(updateStatus)).toList());
    }

    public static EventRecurrence terminateEventRecurrence(EventRecurrence recurrence, Instant eventEndTime) {
        Instant recurrenceEndDate = ProtobufUtils.instantFromRecurrenceEnd(recurrence);
        if (recurrenceEndDate.isAfter(eventEndTime)) {
            // Update recurrence end date
            return recurrence.toBuilder()
                    .setEndDate(ProtobufUtils.instantToDate(eventEndTime))
                    .setEndTime(ProtobufUtils.instantToTimeOfDay(eventEndTime))
                    .build();
        } else {
            return recurrence;
        }
    }

    private static Double findClosestMeasure(List<LatLngAndMilepost> geometry, Double targetMilepost) {
        if (geometry.isEmpty()) {
            return null;
        }
        LatLngAndMilepost closest = geometry.stream()
                .min(Comparator.comparing((LatLngAndMilepost p) -> Math.abs(p.getMeasure() - targetMilepost)))
                .orElse(null);
        return closest.getMeasure();
    }

    private static Boolean filterValidObservation(Observation<?> obs) {
        if (obs == null)
            return false;
        Instant now = Instant.now();

        boolean isValidNow = obs.getValidFrom().isBefore(now.plus(Duration.ofMinutes(1)))
                && (obs.getValidTo() == null || obs.getValidTo().isAfter(now));
        boolean hasValidRouteRange = obs.getRouteAndMeasureRange() != null;

        return isValidNow && hasValidRouteRange;
    }

    private Observation<?> updateConfidenceScore(Observation<?> obs) {
        double baseConfidence = obs.getConfidence();
        // TODO: Consider propagating confidence scores from repeats, time since last
        // update, ...

        double updatedConfidence = Math.min(1.0, Math.max(0.0, baseConfidence));
        obs.setConfidence(updatedConfidence);
        return obs;
    }

    private static List<Observation<?>> deduplicateObservationsBySource(List<Observation<?>> observations) {
        // TODO: Don't overwrite multiple observations within a recording
        // return observations;
        // // TODO: don't overwrite if replacesClaims is set to false
        Map<String, List<Observation<?>>> groupedByClaim = observations.stream()
                .collect(Collectors.groupingBy(Observation::getClaimKey));
        return groupedByClaim.values().stream()
                .map(ObservationUpdateProcessor::deduplicateObservationsByUpdateId)
                .flatMap(List::stream)
                .filter((obs) -> obs != null)
                .toList();
    }

    private static List<Observation<?>> deduplicateObservationsByUpdateId(List<Observation<?>> observations) {
        if (observations.size() == 0) {
            return Collections.emptyList();
        }
        if (observations.getFirst().getSource() == ObservationSource.WZAM_REPORT) {
            // do not deduplicate report observations since they can patch with small
            // iterative updates
            return observations;
        }
        // Group by updateId, then return any observation from the group with the
        // largest updateId
        return observations.stream()
                .collect(Collectors.groupingBy(Observation::getUpdateId)).entrySet().stream()
                .max(Comparator.comparing((Entry<Long, List<Observation<?>>> entry) -> entry.getKey()))
                .map(Map.Entry::getValue)
                .orElse(Collections.emptyList());
    }

    private static Observation<?> mergeDuplicateObservationsByTimestamp(List<Observation<?>> observations) {
        // Return latest observation
        return observations.stream()
                .reduce((first, second) -> second.getTimestamp().isAfter(first.getTimestamp()) ? second : first)
                .orElse(null);
    }

    private static Observation<?> mergeDuplicateObservationsByConfidence(List<Observation<?>> observations) {
        // Return latest observation
        return observations.stream()
                .reduce((first, second) -> second.getConfidence() > first.getConfidence() ? second : first)
                .orElse(null);
    }

    private Pair<List<Observation<?>>, List<Observation<?>>> filterObservationsByRouteId(
            List<Observation<?>> observations,
            RouteAndMeasureRange routeRange) {
        if (routeRange == null) {
            return new Pair<>(List.of(), observations);
        }
        List<Observation<?>> within = new ArrayList<>();
        List<Observation<?>> outside = new ArrayList<>();
        for (Observation<?> obs : observations) {
            Observation<?> updatedObs = obs.regenRouteId(routeRange.getRouteId(), gisService);
            if (updatedObs != null && routeRange.checkOtherPartiallyWithin(updatedObs.getRouteAndMeasureRange())) {
                within.add(updatedObs);
            } else if (obs.getType() == ObservationType.METADATA) {
                // Always include metadata observations regardless of route ID or range
                within.add(obs);
            } else {
                outside.add(obs);
            }
        }
        return new Pair<>(within, outside);
    }

    private RouteAndMeasure getStartMeasure(List<Observation<?>> observations) {
        // TODO: intelligently merge by timestamp and confidence
        return mergeDuplicateObservationsByTimestamp(observations).getRouteAndMeasureRange().getStartRouteAndMeasure();
    }

    private RouteAndMeasure getEndMeasure(List<Observation<?>> observations) {
        // TODO: intelligently merge by timestamp and confidence
        return mergeDuplicateObservationsByTimestamp(observations).getRouteAndMeasureRange().getEndRouteAndMeasure();
    }

    private ObservationMetadata aggregateLatestMetadata(
            List<Observation<ObservationMetadata>> metadataObservations) {
        ObservationMetadata metadata = new ObservationMetadata();
        if (metadataObservations.isEmpty()) {
            return null;
        }
        List<Observation<ObservationMetadata>> timeSortedObservations = metadataObservations.stream()
                .sorted(Comparator.comparing(Observation::getTimestamp))
                .collect(Collectors.toList()); // sort by time ascending, earliest first
        for (Observation<ObservationMetadata> obs : timeSortedObservations) {
            if (obs.getValue() != null) {
                metadata = metadata.copyWith(((ObservationMetadata) obs.getValue()));
            }
        }
        return metadata;
    }

    private VehicleImpact getNetVehicleImpact(List<VehicleImpact> impacts) {
        if (impacts.size() == 0)
            return VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN;
        impacts.sort(Comparator.comparingInt(UpdateProcessorUtils::getVehicleImpactPriority));
        return impacts.get(impacts.size() - 1);
    }

    private List<RoadSubEvent> generateRoadSubEventsBase(
            RoadSubEvent.Builder baseRoadSubEvent,
            RouteAndMeasureRange routeRange,
            List<Observation<LaneStatusValue>> observations,
            ObservationMetadata metadata) {

        // 1. Collect all unique markers
        Set<Double> markerSet = new HashSet<>();
        Map<Double, RouteAndMeasure> measureMap = new HashMap<>();
        for (Observation<LaneStatusValue> obs : observations) {
            markerSet.add(obs.getRouteAndMeasureRange().getStartMeasure());
            measureMap.put(obs.getRouteAndMeasureRange().getStartMeasure(),
                    obs.getRouteAndMeasureRange().getStartRouteAndMeasure());
            markerSet.add(obs.getRouteAndMeasureRange().getEndMeasure());
            measureMap.put(obs.getRouteAndMeasureRange().getEndMeasure(),
                    obs.getRouteAndMeasureRange().getEndRouteAndMeasure());
        }
        markerSet.add(routeRange.getStartMeasure());
        measureMap.put(routeRange.getStartMeasure(),
                routeRange.getStartRouteAndMeasure());
        markerSet.add(routeRange.getEndMeasure());
        measureMap.put(routeRange.getEndMeasure(),
                routeRange.getEndRouteAndMeasure());

        // 2. Sort the markers
        List<Double> sortedMeasures = markerSet.stream().sorted().toList();
        if (routeRange.isRouteDec()) {
            // Reverse sort order for decreasing route mile markers
            sortedMeasures = sortedMeasures.reversed();
        }

        // TODO: Add support for report vehicleImpact

        List<VehicleImpact> concurrentVehicleImpacts = new ArrayList<>(
                List.of(VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN));
        List<List<Lane>> currentLaneStatuses = new ArrayList<>(
                List.of(UpdateProcessorUtils.generateLanesFromVehicleImpact(metadata.getNumLanes(),
                        VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN)));

        List<Lane> newLaneStatuses = UpdateProcessorUtils.combineConcurrentLanes(currentLaneStatuses);
        VehicleImpact newVehicleImpact = getNetVehicleImpact(concurrentVehicleImpacts);

        RoadSubEvent.Builder prevBuilder = baseRoadSubEvent.setRouteId(routeRange.getRouteId())
                .setBeginningMilepost(routeRange.getStartMeasure())
                .setStartLocationType(MarkedLocationType.MARKED_LOCATION_TYPE_SPEED_REDUCTION_START)
                .setEndLocationType(MarkedLocationType.MARKED_LOCATION_TYPE_SPEED_REDUCTION_END)
                .setBaseLayer(baseRoadSubEvent.getBaseLayerBuilder()
                        .setVehicleImpact(newVehicleImpact).clearLanes().addAllLanes(newLaneStatuses));

        List<Lane> prevLaneStatuses = new ArrayList<>(currentLaneStatuses.getFirst());

        // TODO: Combine zones if close enough to another start/end position - as long
        // as no observation is moved too far from it's original position
        Double originalEndMeasure = null;

        // Middle is index of layer type (base=0, srz=1, workers=2)
        Long roadSubEventId = UpdateProcessorUtils.concatIds(baseRoadSubEvent.getId(), 0, 0);
        List<RoadSubEvent> roadSubEvents = new ArrayList<>();
        for (int i = 0; i < sortedMeasures.size(); i++) {

            VehicleImpact prevVehicleImpact = getNetVehicleImpact(concurrentVehicleImpacts);

            // Next, iterate over all new/starting observations
            for (Observation<LaneStatusValue> obs : observations) {
                if (obs.getRouteAndMeasureRange().getStartMeasure().equals(sortedMeasures.get(i))) {
                    LaneStatusValue value = obs.getValue();
                    concurrentVehicleImpacts.add(value.getVehicleImpact());
                    List<Lane> lanes = value.getLanes();
                    if (lanes == null) {
                        lanes = UpdateProcessorUtils.generateLanesFromVehicleImpact(metadata.getNumLanes(),
                                value.getVehicleImpact());
                    }
                    currentLaneStatuses.add(lanes);
                }
                if (obs.getRouteAndMeasureRange().getEndMeasure().equals(sortedMeasures.get(i))) {
                    LaneStatusValue value = obs.getValue();
                    concurrentVehicleImpacts.remove(value.getVehicleImpact());
                    currentLaneStatuses.remove(value.getLanes());
                }
            }

            newLaneStatuses = UpdateProcessorUtils.combineConcurrentLanes(currentLaneStatuses);
            newVehicleImpact = UpdateProcessorUtils
                    .combineVehicleImpactWithLanes(getNetVehicleImpact(concurrentVehicleImpacts), newLaneStatuses);

            if (!newVehicleImpact.equals(prevVehicleImpact) || !newLaneStatuses.equals(prevLaneStatuses)) {
                // Lane status changed - end old and create new

                // End old only if previous has non-zero length
                if (!sortedMeasures.get(i).equals(prevBuilder.getBeginningMilepost())) {
                    prevBuilder.setEndingMilepost(sortedMeasures.get(i));
                    prevBuilder.setId(roadSubEventId);
                    roadSubEventId += 1;
                    roadSubEvents.add(prevBuilder.build());
                }

                // Start new
                BaseLayer.Builder baseLayerBuilder = baseRoadSubEvent.getBaseLayerBuilder()
                        .setVehicleImpact(newVehicleImpact).clearLanes().addAllLanes(newLaneStatuses);
                prevBuilder = prevBuilder.clone().setBeginningMilepost(sortedMeasures.get(i))
                        .setBaseLayer(baseLayerBuilder);
            }
        }
        if (roadSubEvents.isEmpty()
                || !routeRange.getEndMeasure().equals(roadSubEvents.getLast().getEndingMilepost())) {
            prevBuilder.setEndingMilepost(routeRange.getEndMeasure());
            prevBuilder.setEndLocationType(MarkedLocationType.MARKED_LOCATION_TYPE_ROAD_EVENT_END);
            prevBuilder.setId(roadSubEventId);
            roadSubEvents.add(prevBuilder.build());
        }
        return roadSubEvents;
    }

    private List<RoadSubEvent> generateRoadSubEventsSpeedReduction(
            RoadSubEvent.Builder baseRoadSubEvent,
            RouteAndMeasureRange routeRange,
            List<Observation<Integer>> observations) {

        // 1. Collect all unique markers
        Set<Double> markerSet = new HashSet<>();
        Map<Double, RouteAndMeasure> measureMap = new HashMap<>();
        for (Observation<Integer> obs : observations) {
            markerSet.add(obs.getRouteAndMeasureRange().getStartMeasure());
            measureMap.put(obs.getRouteAndMeasureRange().getStartMeasure(),
                    obs.getRouteAndMeasureRange().getStartRouteAndMeasure());
            markerSet.add(obs.getRouteAndMeasureRange().getEndMeasure());
            measureMap.put(obs.getRouteAndMeasureRange().getEndMeasure(),
                    obs.getRouteAndMeasureRange().getEndRouteAndMeasure());
        }

        // 2. Sort the markers
        List<Double> sortedMeasures = markerSet.stream().sorted().toList();
        if (routeRange.isRouteDec()) {
            // Reverse sort order for decreasing route mile markers
            sortedMeasures = sortedMeasures.reversed();
        }
        baseRoadSubEvent = baseRoadSubEvent.setRouteId(routeRange.getRouteId())
                .setBeginningMilepost(routeRange.getStartMeasure())
                .setStartLocationType(MarkedLocationType.MARKED_LOCATION_TYPE_SPEED_REDUCTION_START)
                .setEndLocationType(MarkedLocationType.MARKED_LOCATION_TYPE_SPEED_REDUCTION_END);

        RoadSubEvent.Builder prevBuilder = null;
        List<Integer> concurrentSpeedReductions = new ArrayList<>();

        // TODO: Combine zones if close enough to another start/end position - as long
        // as no observation is moved too far from it's original position
        Double originalEndMeasure = null;

        // Middle is index of layer type (base=0, srz=1, workers=2)
        Long roadSubEventId = UpdateProcessorUtils.concatIds(baseRoadSubEvent.getId(), 1, 0);

        List<RoadSubEvent> roadSubEvents = new ArrayList<>();
        for (int i = 0; i < sortedMeasures.size(); i++) {

            Integer prevSpeedReduction = concurrentSpeedReductions.size() != 0
                    ? concurrentSpeedReductions.stream().sorted().toList().getFirst()
                    : null;

            // Next, iterate over all new/starting observations
            for (Observation<Integer> obs : observations) {
                if (obs.getRouteAndMeasureRange().getStartMeasure().equals(sortedMeasures.get(i))) {
                    concurrentSpeedReductions.add(obs.getValue());
                }
                if (obs.getRouteAndMeasureRange().getEndMeasure().equals(sortedMeasures.get(i))) {
                    concurrentSpeedReductions.remove(obs.getValue());
                }
            }

            Integer newSpeedReduction = concurrentSpeedReductions.size() != 0
                    ? concurrentSpeedReductions.stream().sorted().toList().getFirst()
                    : null;

            if (prevSpeedReduction == null) {
                if (newSpeedReduction == null) {
                    // Both are null, do nothing
                    continue;
                }
                // New speed reduction zone!
                SpeedReductionLayer.Builder speedReductionLayerBuilder = SpeedReductionLayer.newBuilder()
                        .setReducedSpeedLimitKph((float) Units.convertMilesToMeters(newSpeedReduction) / 1000f);
                prevBuilder = baseRoadSubEvent.setBeginningMilepost(sortedMeasures.get(i))
                        .setSpeedReductionLayer(speedReductionLayerBuilder);

            } else if (newSpeedReduction == null) {
                // Ended speed reduction zone! (Can assume prevSpeedReduction is not null)
                if (prevBuilder == null) {
                    log.error("Error generating speed reduction zones - no zone to end at %s for road event %s",
                            sortedMeasures.get(i), baseRoadSubEvent.getId());
                    continue;
                }
                // speed reduction zone ended
                // Only record zone if longer than threshold
                if (Math.abs(
                        prevBuilder.getBeginningMilepost() - sortedMeasures.get(i)) > updateProcessorProperties
                                .getSpeedReductionMinDistanceMiles()) {
                    prevBuilder.setEndingMilepost(sortedMeasures.get(i));
                    prevBuilder.setId(roadSubEventId);
                    roadSubEventId += 1;
                    roadSubEvents.add(prevBuilder.build());
                    prevBuilder = null;
                    // Reset for next speed reduction zone
                } else {
                    // Speed reduction zone too short to compute, ignore completely
                    prevBuilder = null;
                }
            } else if (!newSpeedReduction.equals(prevSpeedReduction)) {
                // Speed reduction changed - end old and create new
                if (prevBuilder == null) {
                    log.error("Error generating speed reduction zones - no zone to end at %s for road event %s",
                            sortedMeasures.get(i), baseRoadSubEvent.getId());

                    // Create new speed reduction zone from current position
                    SpeedReductionLayer.Builder speedReductionLayerBuilder = baseRoadSubEvent
                            .getSpeedReductionLayerBuilder()
                            .setReducedSpeedLimitKph((float) Units.convertMilesToMeters(newSpeedReduction) / 1000f);
                    prevBuilder = baseRoadSubEvent.setBeginningMilepost(sortedMeasures.get(i))
                            .setSpeedReductionLayer(speedReductionLayerBuilder);
                } else {
                    // End old if longer than threshold
                    if (Math.abs(prevBuilder.getBeginningMilepost() - sortedMeasures.get(i)) > updateProcessorProperties
                            .getSpeedReductionMinDistanceMiles()) {
                        prevBuilder.setEndingMilepost(sortedMeasures.get(i));
                        prevBuilder.setId(roadSubEventId);
                        roadSubEventId += 1;
                        roadSubEvents.add(prevBuilder.build());

                        // Create new speed reduction zone from current position
                        SpeedReductionLayer.Builder speedReductionLayerBuilder = baseRoadSubEvent
                                .getSpeedReductionLayerBuilder()
                                .setReducedSpeedLimitKph((float) Units.convertMilesToMeters(newSpeedReduction) / 1000f);
                        prevBuilder = baseRoadSubEvent.setBeginningMilepost(sortedMeasures.get(i))
                                .setSpeedReductionLayer(speedReductionLayerBuilder);
                    } else {

                        // Update previous to current speed limit with old beginning milepost
                        SpeedReductionLayer.Builder speedReductionLayerBuilder = baseRoadSubEvent
                                .getSpeedReductionLayerBuilder()
                                .setReducedSpeedLimitKph((float) Units.convertMilesToMeters(newSpeedReduction) / 1000f);
                        prevBuilder = baseRoadSubEvent.setBeginningMilepost(prevBuilder.getBeginningMilepost())
                                .setSpeedReductionLayer(speedReductionLayerBuilder);
                    }
                }
            }
        }
        if (prevBuilder != null) {
            prevBuilder.setEndingMilepost(routeRange.getEndMeasure());
            prevBuilder.setId(roadSubEventId);
            roadSubEvents.add(prevBuilder.build());
        }
        return roadSubEvents;
    }

    private List<RoadSubEvent> generateRoadSubEventsWorkerPresence(
            RoadSubEvent.Builder baseRoadSubEvent,
            RouteAndMeasureRange routeRange,
            List<Observation<EventRecurrence>> observations) {

        // 1. Collect all unique markers
        Set<Double> markerSet = new HashSet<>();
        Map<Double, RouteAndMeasure> measureMap = new HashMap<>();
        for (Observation<EventRecurrence> obs : observations) {
            markerSet.add(obs.getRouteAndMeasureRange().getStartMeasure());
            measureMap.put(obs.getRouteAndMeasureRange().getStartMeasure(),
                    obs.getRouteAndMeasureRange().getStartRouteAndMeasure());
            markerSet.add(obs.getRouteAndMeasureRange().getEndMeasure());
            measureMap.put(obs.getRouteAndMeasureRange().getEndMeasure(),
                    obs.getRouteAndMeasureRange().getEndRouteAndMeasure());
        }

        // 2. Sort the markers
        List<Double> sortedMeasures = markerSet.stream().sorted().toList();
        if (routeRange.isRouteDec()) {
            // Reverse sort order for decreasing route mile markers
            sortedMeasures = sortedMeasures.reversed();
        }

        baseRoadSubEvent = baseRoadSubEvent.setRouteId(routeRange.getRouteId())
                .setBeginningMilepost(routeRange.getStartMeasure())
                .setStartLocationType(MarkedLocationType.MARKED_LOCATION_TYPE_WORKER_PRESENCE_START)
                .setEndLocationType(MarkedLocationType.MARKED_LOCATION_TYPE_WORKER_PRESENCE_END);
        RoadSubEvent.Builder prevBuilder = null;

        // TODO: Combine zones if close enough to another start/end position - as long
        // as no observation is moved too far from it's original position
        Double originalEndMeasure = null;

        // Middle is index of layer type (base=0, srz=1, workers=2)
        Long roadSubEventId = UpdateProcessorUtils.concatIds(baseRoadSubEvent.getId(), 2, 0);

        Integer numConcurrentWorkerPresenceZones = 0;
        List<RoadSubEvent> roadSubEvents = new ArrayList<>();
        for (int i = 0; i < sortedMeasures.size(); i++) {
            RoadSubEvent.Builder newBuilder = null;

            Integer prevNumConcurrentWorkerPresenceZones = numConcurrentWorkerPresenceZones;
            // Next, iterate over all new/starting observations
            for (Observation<EventRecurrence> obs : observations) {
                if (obs.getRouteAndMeasureRange().getStartMeasure().equals(sortedMeasures.get(i))) {
                    numConcurrentWorkerPresenceZones += 1;
                    if (newBuilder == null) {
                        newBuilder = prevBuilder != null ? prevBuilder : baseRoadSubEvent;
                    }
                    WorkerPresenceLayer.Builder workerPresenceLayerBuilder = baseRoadSubEvent
                            .getWorkerPresenceLayerBuilder().setWorkerPresence(UpdateProcessorUtils.getWorkerPresence(
                                    true,
                                    obs.getSource(),
                                    obs.getTimestamp(),
                                    obs.getConfidence()));
                    newBuilder.setWorkerPresenceLayer(workerPresenceLayerBuilder);
                    if (obs.getValue() != null) {
                        // TODO: De-conflict live data with scheduled data. If live worker, make sure live worker zone is not scheduled if intersecting a scheduled zone
                        newBuilder.setSchedule((EventRecurrence) obs.getTypedValue());
                    }
                }
                if (obs.getRouteAndMeasureRange().getEndMeasure().equals(sortedMeasures.get(i))) {
                    numConcurrentWorkerPresenceZones -= 1;
                }
            }

            // Apply detected changes
            if (prevNumConcurrentWorkerPresenceZones <= 0 && numConcurrentWorkerPresenceZones > 0) {
                // worker presence zone started
                // newBuilder must be non-null, because numConcurrentWorkerPresenceZones
                // increased
                prevBuilder = newBuilder.setBeginningMilepost(sortedMeasures.get(i));
            } else if (prevNumConcurrentWorkerPresenceZones > 0 && numConcurrentWorkerPresenceZones <= 0) {
                if (prevBuilder == null) {
                    log.error("Error generating worker presence zones - no zone to end at %s for road event %s",
                            sortedMeasures.get(i), baseRoadSubEvent.getId());
                    continue;
                }
                // worker presence zone ended
                prevBuilder.setEndingMilepost(sortedMeasures.get(i));
                prevBuilder.setId(roadSubEventId);
                roadSubEventId += 1;
                roadSubEvents.add(prevBuilder.build());
                prevBuilder = null;
            }
        }
        if (prevBuilder != null) {
            prevBuilder.setEndingMilepost(routeRange.getEndMeasure());
            prevBuilder.setId(roadSubEventId);
            roadSubEvents.add(prevBuilder.build());
        }
        return roadSubEvents;
    }
}
