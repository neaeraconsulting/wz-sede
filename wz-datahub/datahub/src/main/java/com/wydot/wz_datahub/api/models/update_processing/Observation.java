package com.wydot.wz_datahub.api.models.update_processing;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.google.type.LatLng;
import com.wydot.wz_datahub.api.ProtobufUtils;
import com.wydot.wz_datahub.api.models.field_devices.FieldDeviceReading;
import com.wydot.wz_datahub.api.models.gis_service.RouteAndMeasure;
import com.wydot.wz_datahub.api.models.gis_service.RouteAndMeasureRange;
import com.wydot.wz_datahub.api.models.recordings.RecordingMarking;
import com.wydot.wz_datahub.api.models.recordings.RecordingPoint;
import com.wydot.wz_datahub.api.models.recordings.RecordingWithId;
import com.wydot.wz_datahub.api.models.reports.ReportPatch;
import com.wydot.wz_datahub.api.models.reports.ReportWithId;
import com.wydot.wz_datahub.api.models.reports.WorkerPresenceReport;
import com.wydot.wz_datahub.api.models.serialization.instant.InstantFromMillisDeserializer;
import com.wydot.wz_datahub.api.models.serialization.instant.InstantToMillisSerializer;
import com.wydot.wz_datahub.api.models.update_processing.values.LaneStatusValue;
import com.wydot.wz_datahub.api.models.workers.LiveWorkerLocation;
import com.wydot.wz_datahub.api.models.mobile_vehicle.MobileVehicleLocation;
import com.wydot.wz_datahub.api.models.wrappers.RoadSubEventWrapper;
import com.wydot.wz_datahub.api.update_processors.UpdateProcessorUtils;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventWrapper;
import com.wydot.wz_datahub.api.utilities.gis_service.GisService;

import com.wydot.wz_datahub.api.utilities.Units;

import kotlin.Pair;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.EventRecurrence;
import wyo.dot.protobuf.FieldDevice;
import wyo.dot.protobuf.FieldDevice.FieldDeviceStatus;
import wyo.dot.protobuf.Lane;
import wyo.dot.protobuf.RoadEvent;
import wyo.dot.protobuf.RoadSubEvent;
import wyo.dot.protobuf.RoadSubEvent.BaseLayer;
import wyo.dot.protobuf.RoadSubEvent.SpeedReductionLayer;
import wyo.dot.protobuf.RoadSubEvent.WorkerPresenceLayer;
import wyo.dot.protobuf.VehicleImpact;

@Slf4j
@NoArgsConstructor
@AllArgsConstructor
@Data
public class Observation<T> {
    private String sourceId; // ID of the source of the observation, like a report or a field device
    private Long roadEventId;
    private Long updateId; // Unique ID of the update that generated this observation
    private Boolean replacesClaims = true;
    private ObservationSource source;
    private ObservationType type;
    @JsonSerialize(using = InstantToMillisSerializer.class)
    @JsonDeserialize(using = InstantFromMillisDeserializer.class)
    private Instant timestamp;
    @JsonSerialize(using = InstantToMillisSerializer.class)
    @JsonDeserialize(using = InstantFromMillisDeserializer.class)
    private Instant lastUpdated;
    @JsonSerialize(using = InstantToMillisSerializer.class)
    @JsonDeserialize(using = InstantFromMillisDeserializer.class)
    private Instant validFrom;
    @JsonSerialize(using = InstantToMillisSerializer.class)
    @JsonDeserialize(using = InstantFromMillisDeserializer.class)
    private Instant validTo;
    private double confidence;
    private RouteAndMeasureRange routeAndMeasureRange;
    private Pair<LatLng, LatLng> rawGeometry;
    private T value;

    public static List<Observation<?>> fromFieldDevice(
            GisService gisService,
            FieldDeviceReading fieldDeviceReading,
            RouteAndMeasureRange parentRouteAndMeasureRange) {

        String parentRouteId = parentRouteAndMeasureRange != null ? parentRouteAndMeasureRange.getRouteId() : null;
        Boolean isParentDec = parentRouteAndMeasureRange != null ? parentRouteAndMeasureRange.isRouteDec() : false;

        List<Observation<?>> observations = new ArrayList<>();
        if (fieldDeviceReading == null) {
            return Collections.emptyList();
        }
        FieldDevice fieldDevice = fieldDeviceReading.getDevice();

        Observation<Object> observation = new Observation<>();
        Instant lastUpdated = fieldDeviceReading.getLastUpdated();
        observation.setSourceId(fieldDevice.getId());
        observation.setTimestamp(Instant.now());
        observation.setUpdateId(observation.getTimestamp().toEpochMilli());
        observation.setLastUpdated(lastUpdated);
        observation.setValidFrom(lastUpdated.minus(24, ChronoUnit.HOURS));
        observation.setValidTo(lastUpdated.plus(24, ChronoUnit.HOURS));

        RouteAndMeasure routeAndMeasure = fieldDeviceReading.getRouteAndMeasure();
        if (routeAndMeasure == null) {
            log.debug("No route found for field device: {}", fieldDevice.getId());
            return Collections.emptyList(); // No route found, cannot process observation without GIS data
        }
        if (parentRouteId != null) {
            RouteAndMeasure matchingMeasure = gisService
                    .getExpectedRouteAndMeasure(fieldDevice.getGeometry().getCoordinates(), 100, parentRouteId)
                    .block();
            if (matchingMeasure != null) {
                routeAndMeasure = matchingMeasure;
            } else {
                log.warn("No matching route found for field device: {}", fieldDevice.getId());
            }
        }
        observation.setRouteAndMeasureRange(routeAndMeasure.addRange(200, isParentDec));
        observation.setRawGeometry(
                new Pair<>(fieldDevice.getGeometry().getCoordinates(), fieldDevice.getGeometry().getCoordinates()));

        // Filter out non-active devices
        if (fieldDevice.getCoreDetails().getDeviceStatus() != FieldDeviceStatus.FIELD_DEVICE_STATUS_OK) {
            log.debug("Ignoring non-active field device: {}", fieldDevice.getId());
            observations.add(observation.copyWithTypeAndConfidence(ObservationType.NOTHING, 1.0));
            return observations;
        }

        // Default to NOTHING type
        observation.setType(ObservationType.NOTHING);
        switch (fieldDevice.getDeviceCase()) {
            case ARROW_BOARD:
                observation.setSource(ObservationSource.ARROW_BOARD);
                switch (fieldDevice.getArrowBoard().getPattern()) {
                    case ARROW_BOARD_PATTERN_RIGHT_ARROW_FLASHING:
                    case ARROW_BOARD_PATTERN_RIGHT_ARROW_SEQUENTIAL:
                    case ARROW_BOARD_PATTERN_RIGHT_CHEVRON_FLASHING:
                    case ARROW_BOARD_PATTERN_RIGHT_CHEVRON_SEQUENTIAL:
                        observation.setType(ObservationType.LANE_STATUS_ZONE);
                        observation.setConfidence(0.60);
                        observation.setValue(
                                new LaneStatusValue(VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_RIGHT, null));
                        break;
                    case ARROW_BOARD_PATTERN_LEFT_ARROW_FLASHING:
                    case ARROW_BOARD_PATTERN_LEFT_ARROW_SEQUENTIAL:
                    case ARROW_BOARD_PATTERN_LEFT_CHEVRON_FLASHING:
                    case ARROW_BOARD_PATTERN_LEFT_CHEVRON_SEQUENTIAL:
                        observation.setType(ObservationType.LANE_STATUS_ZONE);
                        observation.setConfidence(0.60);
                        observation.setValue(
                                new LaneStatusValue(VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_LEFT, null));
                        break;
                    case ARROW_BOARD_PATTERN_BIDIRECTIONAL_ARROW_FLASHING:
                        observation.setType(ObservationType.LANE_STATUS_ZONE);
                        observation.setConfidence(0.60);
                        observation.setValue(
                                new LaneStatusValue(VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_SPLIT, null));
                        break;
                    case ARROW_BOARD_PATTERN_DIAMONDS_ALTERNATING:
                    case ARROW_BOARD_PATTERN_FOUR_CORNERS_FLASHING:
                        observation.setType(ObservationType.WORKER_PRESENCE);
                        observation.setConfidence(0.5); // Lower confidence for worker presence
                        observation.setValue(null);
                        break;
                    default:
                        log.warn("Unsupported arrow board pattern for field device: {}, {}", fieldDevice.getId(),
                                fieldDevice.getArrowBoard().getPattern().name());
                        break; // Unsupported arrow board pattern for observation
                }
                observation.setConfidence(1);
                break;
            case LOCATION_MARKER:
                observation.setSource(ObservationSource.LOCATION_MARKER);
                switch (fieldDevice.getLocationType()) {
                    case MARKED_LOCATION_TYPE_ROAD_EVENT_START:
                        observation.setType(ObservationType.EVENT_START);
                        observation.setConfidence(1);
                        break;
                    case MARKED_LOCATION_TYPE_ROAD_EVENT_END:
                        observation.setType(ObservationType.EVENT_END);
                        observation.setConfidence(1);
                        break;
                    default:
                        log.warn("Unsupported location marker type for field device: {}, {}", fieldDevice.getId(),
                                fieldDevice.getLocationType().name());
                        break;
                }
                break;
            case MOBILE_VEHICLE:
                observation.setType(ObservationType.MOBILE_VEHICLE_LOCATION);
                observation.setSource(ObservationSource.VEHICLE_LOCATION);
                observation.setConfidence(1);
                break;
            case FIELD_WORKER:
                observation.setType(ObservationType.WORKER_PRESENCE);
                observation.setSource(ObservationSource.WORKER_LOCATION);
                observation.setConfidence(1);
                break;
            default:
                log.warn("Unsupported field device type for observation: {}, {}", fieldDevice.getId(),
                        fieldDevice.getDeviceCase().name());
                break; // Unsupported device type for observation
        }
        observations.add(observation);
        return observations;
    }

    @Deprecated
    public static List<Observation<?>> fromLiveWorkerLocation(
            GisService gisService,
            LiveWorkerLocation liveWorkerLocation,
            String expectedRouteId) {

        List<Observation<?>> observations = new ArrayList<>();

        Observation<?> observation = new Observation<>();
        observation.setSourceId(liveWorkerLocation.getWorkerId());
        observation.setTimestamp(Instant.now());
        observation.setUpdateId(observation.getTimestamp().toEpochMilli());
        observation.setLastUpdated(liveWorkerLocation.getTimestamp());
        observation.setValidFrom(liveWorkerLocation.getTimestamp());
        observation.setValidTo(liveWorkerLocation.getTimestamp().plus(30, ChronoUnit.MINUTES));

        observation.setSource(ObservationSource.WZAM_LIVE_WORKER_LOCATION);
        if (!liveWorkerLocation.getIsActive()) {
            observation.setType(ObservationType.NOTHING);
            // Emit type NOTHING, to overwrite other values
        } else {
            observation.setType(ObservationType.WORKER_PRESENCE);
            observation.setValue(null);
        }

        RouteAndMeasure routeAndMeasure = gisService.getExpectedRouteAndMeasure(
                liveWorkerLocation.getLocation(), 100, expectedRouteId).block();
        if (routeAndMeasure == null) {
            log.debug("No route found for field device: {}", liveWorkerLocation.getWorkerId());
            return Collections.emptyList(); // No route found, cannot process observation without GIS data
        }
        if (routeAndMeasure.compareAndUpdateRouteId(expectedRouteId)) {
            routeAndMeasure = gisService
                    .getExpectedRouteAndMeasure(liveWorkerLocation.getLocation(), 100, expectedRouteId)
                    .block();
            if (routeAndMeasure == null) {
                log.debug("field device not on expected route: {}, {}", liveWorkerLocation.getWorkerId(),
                        expectedRouteId);
                return Collections.emptyList(); // No route found, cannot process observation without GIS data
            }
        }

        observation.setConfidence(1.0);
        observation.setRawGeometry(
                new Pair<>(liveWorkerLocation.getLocation(), liveWorkerLocation.getLocation()));
        observations.add(observation);

        return observations;
    }

    public static List<Observation<?>> fromMobileVehicleLocation(
            GisService gisService,
            MobileVehicleLocation mobileVehicleLocation,
            Long roadEventId) {

        List<Observation<?>> observations = new ArrayList<>();

        Observation<?> observation = new Observation<>();
        observation.setSourceId(mobileVehicleLocation.getWorkerId());
        observation.setTimestamp(Instant.now());
        observation.setUpdateId(observation.getTimestamp().toEpochMilli());
        observation.setLastUpdated(mobileVehicleLocation.getTimestamp());
        observation.setValidFrom(mobileVehicleLocation.getTimestamp());
        observation.setValidTo(mobileVehicleLocation.getTimestamp().plus(30, ChronoUnit.MINUTES));

        observation.setSource(ObservationSource.WZAM_MOBILE_VEHICLE_LOCATION);

        RouteAndMeasure routeAndMeasure = gisService.getClosestRouteAndMeasure(
                mobileVehicleLocation.getLocation(), 100).block();
        if (routeAndMeasure == null) {
            log.debug("No route found for field device: {}", mobileVehicleLocation.getWorkerId());
            return Collections.emptyList(); // No route found, cannot process observation without GIS data
        }

        RouteAndMeasureRange range = gisService
                .addMeasureBounds(routeAndMeasure, mobileVehicleLocation.getHeading(), 200).block();
        observation.setRouteAndMeasureRange(range);
        observation.setConfidence(1.0);
        observation.setRawGeometry(
                new Pair<>(mobileVehicleLocation.getLocation(), mobileVehicleLocation.getLocation()));

        if (!mobileVehicleLocation.getIsActive()) {
            observations.add(observation.copyWithTypeAndConfidence(ObservationType.NOTHING, 1.0));
            return observations;
        }

        observations.add(observation.copyWithTypeAndConfidence(ObservationType.EVENT_START, 1.0));
        observations.add(observation.copyWithTypeAndConfidence(ObservationType.EVENT_END, 1.0));

        ObservationMetadata metadata = ObservationMetadata.fromMobileVehicle(mobileVehicleLocation, roadEventId);
        observations.add(observation.copyWithTypeConfidenceAndValue(ObservationType.METADATA, 1.0, metadata));

        return observations;
    }

    public static List<Observation<?>> fromReport(
            ReportWithId report,
            Long roadEventId,
            GisService gisService) {
        RouteAndMeasureRange routeAndMeasureRange = report
                .getRouteAndMeasureRange(gisService);

        // List<LatLng> lineString = report.getGeometry();

        List<Observation<?>> observations = new ArrayList<>();
        Observation<?> baseObservation = new Observation<>();
        baseObservation.setSourceId(report.getId().toString());
        baseObservation.setRoadEventId(roadEventId);
        baseObservation.setTimestamp(Instant.now());
        baseObservation.setUpdateId(baseObservation.getTimestamp().toEpochMilli());
        baseObservation.setLastUpdated(report.getTimestamp());
        baseObservation.setSource(ObservationSource.WZAM_REPORT);
        baseObservation.setRouteAndMeasureRange(routeAndMeasureRange);
        baseObservation.setConfidence(0.95);
        baseObservation.setValidFrom(Instant.now());
        baseObservation.setValidTo(null);
        switch (report.getGeometryType()) {
            case MULTIPOINT:
            case LINESTRING:
            case POLYGON:
                // TODO: Consider handling separately
                baseObservation
                        .setRawGeometry(new Pair<>(report.getGeometry().getFirst(), report.getGeometry().getLast()));
                break;
        }

        // Add observations for start and end of event
        observations.add(baseObservation.copyWith(
                null, null, null, null, null,
                ObservationType.EVENT_START, null, null, null, null,
                1.0,
                routeAndMeasureRange,
                new Pair<>(report.getGeometry().getFirst(), report.getGeometry().getLast()), null));

        observations.add(baseObservation.copyWith(
                null, null, null, null, null,
                ObservationType.EVENT_END, null, null, null, null,
                1.0,
                routeAndMeasureRange,
                new Pair<>(report.getGeometry().getFirst(), report.getGeometry().getLast()), null));

        observations.add(baseObservation.copyWith(
                null, null, null, null, null,
                ObservationType.METADATA, null, null, null, null,
                1.0,
                routeAndMeasureRange,
                new Pair<>(report.getGeometry().getFirst(), report.getGeometry().getLast()),
                ObservationMetadata.fromReport(report, roadEventId)));

        if (report.getVehicleImpact() != null) {
            observations.add(baseObservation.copyWithTypeConfidenceAndValue(ObservationType.LANE_STATUS_ZONE, null,
                    new LaneStatusValue(UpdateProcessorUtils.getVehicleImpact(report.getVehicleImpact()), null)));
        }

        // Handle active schedule
        if (report.getWorkersPresent() != null && report.getWorkersPresent()) {
            if (report.getWorkerPresenceSchedule() != null) {
                EventRecurrence schedule = UpdateProcessorUtils.getEventRecurrence(report.getWorkerPresenceSchedule());

                observations.add(baseObservation.copyWithSchedule(
                        ObservationSource.WZAM_REPORT_SCHEDULE,
                        ObservationType.WORKER_PRESENCE,
                        ProtobufUtils.instantFromRecurrenceEnd(schedule),
                        ProtobufUtils.instantFromRecurrenceStart(schedule),
                        0.5, null, null, schedule));
            } else {
                observations.add(baseObservation.copyWithSchedule(null,
                        ObservationType.WORKER_PRESENCE, null, null, 0.5, null, null, null));
            }
        }

        return observations;
    }

    public static List<Observation<?>> fromReportPatch(
            ReportPatch report,
            Long roadEventId,
            GisService gisService,
            Observation<ObservationMetadata> observationMetadata) {
        RouteAndMeasureRange routeAndMeasureRange = report
                .getRouteAndMeasureRangeWithDefault(gisService, observationMetadata.getRouteAndMeasureRange());

        // List<LatLng> lineString = report.getGeometry();

        List<Observation<?>> observations = new ArrayList<>();
        Observation<?> baseObservation = new Observation<>();
        baseObservation.setSourceId(report.getId().toString());
        baseObservation.setRoadEventId(roadEventId);
        baseObservation.setTimestamp(Instant.now());
        baseObservation.setUpdateId(baseObservation.getTimestamp().toEpochMilli());
        baseObservation.setLastUpdated(report.getTimestamp());
        baseObservation.setSource(ObservationSource.WZAM_REPORT);
        baseObservation.setRouteAndMeasureRange(routeAndMeasureRange);
        baseObservation.setConfidence(0.95);
        baseObservation.setValidFrom(Instant.now());
        baseObservation.setValidTo(null);

        Pair<LatLng, LatLng> geometryPair = null;
        if (report.getGeometry() != null && !report.getGeometry().isEmpty()) {
            geometryPair = new Pair<>(report.getGeometry().getFirst(), report.getGeometry().getLast());
            baseObservation.setRawGeometry(geometryPair);

            // Add observations for start and end of event
            observations.add(baseObservation.copyWith(
                    null, null, null, null, null,
                    ObservationType.EVENT_START, null, null, null, null,
                    1.0,
                    routeAndMeasureRange,
                    geometryPair, null));

            observations.add(baseObservation.copyWith(
                    null, null, null, null, null,
                    ObservationType.EVENT_END, null, null, null, null,
                    1.0,
                    routeAndMeasureRange,
                    geometryPair, null));
        } else {
            // If no geometry in the patch, use geometry from metadata observation
            geometryPair = observationMetadata.getRawGeometry();
            baseObservation.setRawGeometry(observationMetadata.getRawGeometry());
        }

        ObservationMetadata newObservationMetadata = ObservationMetadata.fromReportPatch(report, roadEventId,
                observationMetadata.getValue());
        if (newObservationMetadata != null) {
            observations.add(baseObservation.copyWith(
                    null, null, null, null, null,
                    ObservationType.METADATA, null, null, null, null,
                    1.0,
                    routeAndMeasureRange,
                    geometryPair,
                    newObservationMetadata));
        }

        return observations;
    }

    public static List<Observation<?>> fromWorkerPresenceReport(
            WorkerPresenceReport report,
            Long roadEventId,
            GisService gisService,
            Observation<ObservationMetadata> observationMetadata) {
        RouteAndMeasureRange routeAndMeasureRange = report.getRouteAndMeasureRange();

        // List<LatLng> lineString = report.getGeometry();
        EventRecurrence schedule = UpdateProcessorUtils.getEventRecurrence(report.getSchedule());

        List<Observation<?>> observations = new ArrayList<>();
        Observation<?> baseObservation = new Observation<>();
        baseObservation.setSourceId(report.getId().toString());
        baseObservation.setRoadEventId(roadEventId);
        baseObservation.setTimestamp(Instant.now());
        baseObservation.setUpdateId(baseObservation.getTimestamp().toEpochMilli());
        baseObservation.setLastUpdated(report.getTimestamp());
        baseObservation.setSource(ObservationSource.WZAM_REPORT);
        baseObservation.setRouteAndMeasureRange(routeAndMeasureRange);
        baseObservation.setConfidence(0.95);
        baseObservation.setValidFrom(Instant.now());
        baseObservation.setValidTo(null);

        LatLng startLatLng = gisService.getGeometryForMeasure(routeAndMeasureRange.getStartRouteAndMeasure()).block();
        LatLng endLatLng = gisService.getGeometryForMeasure(routeAndMeasureRange.getEndRouteAndMeasure()).block();
        Pair<LatLng, LatLng> geometryPair = new Pair<>(startLatLng, endLatLng);
        baseObservation.setRawGeometry(geometryPair);

        if (report.getEndTimestamp() != null) {
            baseObservation.setValidTo(report.getEndTimestamp());
            baseObservation.setType(ObservationType.WORKER_PRESENCE);
            baseObservation.setValue(null);
            observations.add(baseObservation);
        } else {
            observations.add(baseObservation.copyWithSchedule(
                    ObservationSource.WZAM_REPORT_SCHEDULE,
                    ObservationType.WORKER_PRESENCE,
                    ProtobufUtils.instantFromRecurrenceEnd(schedule),
                    ProtobufUtils.instantFromRecurrenceStart(schedule),
                    0.5, null, null, schedule));
        }

        return observations;
    }

    public static List<Observation<?>> fromRecording(
            RecordingWithId recording,
            Long roadEventId,
            GisService gisService) {

        // TODO: Include recording path as an observation for the new road event
        // geometry

        List<Observation<?>> observations = new ArrayList<>();
        Observation<?> baseObservation = new Observation<>();
        baseObservation.setSourceId(recording.getId().toString());
        baseObservation.setRoadEventId(roadEventId);
        baseObservation.setTimestamp(Instant.now());
        baseObservation.setUpdateId(baseObservation.getTimestamp().toEpochMilli());
        baseObservation.setLastUpdated(recording.getTimestamp());
        baseObservation.setSource(ObservationSource.WZAM_RECORDING);
        baseObservation.setConfidence(0.95);
        baseObservation.setValidFrom(recording.getStartDate());
        baseObservation.setValidTo(recording.getEndDate());

        // Iterate over report points, pull out observations from markings
        if (recording.getPoints().isEmpty() ||
                recording.getPoints().getFirst().getMarking() == null) {
            log.warn("Recording {} has no points or is missing the first marking, skipping RoadSubEvent generation.",
                    recording.getId());
            return List.of();
        }

        // Find the index of the first point with a reference marking == true
        int refPtIndex = IntStream.range(0, recording.getPoints().size())
                .filter(i -> {
                    RecordingPoint point = recording.getPoints().get(i);
                    return point != null
                            && point.getMarking() != null
                            && Boolean.TRUE.equals(point.getMarking().getRefPt());
                })
                .findFirst()
                .orElse(-1);
        if (refPtIndex == -1) {
            log.warn("Recording has no reference marking, skipping RoadSubEvent generation.");
            return List.of();
        }

        // List<LatLng> recordingPath = recording.getPoints().subList(refPtIndex,
        // recording.getPoints().size()).stream()
        // .map(v -> v.latLng()).toList();

        log.warn("First point: " + recording.getPoints().get(refPtIndex).latLng());
        log.warn("Second point: " + recording.getPoints().getLast().latLng());
        RouteAndMeasureRange routeAndMeasureRange = gisService.getMatchingRouteAndMeasure(
                recording.getPoints().get(refPtIndex).latLng(), recording.getPoints().getLast().latLng(), 100)
                .block();
        if (routeAndMeasureRange == null) {

            // Must generate measures as distance
            // Measure distance between start and end point
            RouteAndMeasure startRouteAndMeasure = new RouteAndMeasure("UNKNOWN", "UNKNOWN", 0.0, 0.0);
            double distanceMeters = 1000; // GisUtils.calculateLineStringDistanceMeters(recordingPath);
            double distanceMiles = Units.convertMetersToMiles(distanceMeters);
            RouteAndMeasure endRouteAndMeasure = new RouteAndMeasure("UNKNOWN", "UNKNOWN", distanceMiles,
                    distanceMiles);
            routeAndMeasureRange = RouteAndMeasureRange.fromMeasures(startRouteAndMeasure, endRouteAndMeasure);
        }
        baseObservation.setRouteAndMeasureRange(routeAndMeasureRange);

        // Create the first observation for the reference point
        RouteAndMeasure refPtRouteAndMeasure = gisService.getExpectedRouteAndMeasure(
                recording.getPoints().get(refPtIndex).latLng(), 100,
                routeAndMeasureRange.getRouteId()).block();
        if (recording.getPoints().size() <= refPtIndex + 1) {
            log.warn("Recording {} has no second point after reference point, skipping RoadSubEvent generation.",
                    recording.getId());
            return List.of();
        }

        RouteAndMeasure refPtNextRouteAndMeasure = gisService.getExpectedRouteAndMeasure(
                recording.getPoints().get(refPtIndex + 1).latLng(), 100,
                routeAndMeasureRange.getRouteId()).block();

        if (refPtRouteAndMeasure == null || refPtNextRouteAndMeasure == null) {
            log.warn(
                    "Could not find matching route and measure for reference point in recording {} for routeID {}, skipping RoadSubEvent generation.",
                    recording.getId(), routeAndMeasureRange.getRouteId());
            return List.of();
        }

        // Submit event start observation
        RouteAndMeasureRange refPtRouteAndMeasureRange = RouteAndMeasureRange.fromMeasures(
                refPtRouteAndMeasure,
                refPtNextRouteAndMeasure);

        observations.add(baseObservation.copyWith(
                null, null, null, null, null,
                ObservationType.EVENT_START, null,
                null, null, null,
                1.0,
                refPtRouteAndMeasureRange,
                new Pair<>(recording.getPoints().get(refPtIndex).latLng(),
                        recording.getPoints().get(refPtIndex + 1).latLng()),
                null));

        // Initialize index tracking variables
        RecordingMarking firstMarking = recording.getPoints().getFirst().getMarking();
        RecordingMarking refPtMarking = recording.getPoints().get(refPtIndex).getMarking();
        // Initial Worker Presence
        Pair<Integer, Boolean> lastWorkerPresence = new Pair<>(refPtIndex,
                refPtMarking.getWorkersPresent() != null ? refPtMarking.getWorkersPresent() : false);
        // Initial Lane Statuses
        Pair<Integer, List<Lane>> lastLaneStatus = new Pair<>(refPtIndex,
                UpdateProcessorUtils.getLanes(firstMarking.getLanes()));
        // Initial Speed Limit
        Integer roadwaySpeedLimit = firstMarking.getSpeedLimitMph();
        Pair<Integer, Integer> lastSpeedLimit = new Pair<>(refPtIndex, roadwaySpeedLimit);

        // Nothing can change before the reference point is reached, so start from there
        for (int i = refPtIndex; i < recording.getPoints().size(); i++) {
            RecordingPoint point = recording.getPoints().get(i);
            if (point.getMarking() == null && i != recording.getPoints().size() - 1) {
                log.warn("Recording point {} has no markings, skipping.", i);
                continue;
            }
            RouteAndMeasure currentRouteAndMeasure = null;
            RecordingMarking marking = point.getMarking();
            if (marking.getLanes() != null || i == recording.getPoints().size() - 1) {
                List<Lane> lanes = UpdateProcessorUtils.getLanes(marking.getLanes());
                if (marking.getLanes() != null
                        && !UpdateProcessorUtils.haveLanesChanged(lastLaneStatus.getSecond(), lanes)) {
                    // No changes to justify observation
                } else if (!UpdateProcessorUtils.areAllLanesOpen(lastLaneStatus.getSecond())) {
                    // Previous speed zone should be created
                    RouteAndMeasure startPtRouteAndMeasure = gisService.getExpectedRouteAndMeasure(
                            recording.getPoints().get(lastLaneStatus.getFirst()).latLng(), 100,
                            routeAndMeasureRange.getRouteId()).block();
                    currentRouteAndMeasure = currentRouteAndMeasure != null ? currentRouteAndMeasure
                            : gisService.getExpectedRouteAndMeasure(
                                    point.latLng(), 100,
                                    routeAndMeasureRange.getRouteId()).block();

                    if (currentRouteAndMeasure == null) {
                        log.warn(
                                "Could not find matching route and measure for worker presence in recording {} for routeID {} and starting index {}, skipping observation",
                                recording.getId(), routeAndMeasureRange.getRouteId(), i);
                    } else {
                        RouteAndMeasureRange range = RouteAndMeasureRange.fromMeasures(
                                startPtRouteAndMeasure,
                                currentRouteAndMeasure);
                        observations.add(baseObservation.copyWith(
                                null, null, null, null, null,
                                ObservationType.LANE_STATUS_ZONE, null,
                                null, null, null,
                                1.0,
                                range,
                                new Pair<>(recording.getPoints().get(lastLaneStatus.getFirst()).latLng(),
                                        point.latLng()),
                                LaneStatusValue.fromLanes(lastLaneStatus.getSecond())));
                        lastLaneStatus = new Pair<>(i, lanes);
                    }
                } else {
                    // Update state, don't publish (lastLaneStatus has ALL_LANES_OPEN)
                    lastLaneStatus = new Pair<>(i, lanes);
                }
            }
            if ((marking.getWorkersPresent() != null && lastWorkerPresence.getSecond() != marking.getWorkersPresent())
                    || (lastWorkerPresence.getSecond() == true && i == recording.getPoints().size() - 1)) {
                // Either has changed, or is last point and still present

                // Only submit observation if turning finished active area, or last point
                if (i == recording.getPoints().size() - 1 || marking.getWorkersPresent() == false) {
                    RouteAndMeasure startPtRouteAndMeasure = gisService.getExpectedRouteAndMeasure(
                            recording.getPoints().get(lastWorkerPresence.getFirst()).latLng(), 100,
                            routeAndMeasureRange.getRouteId()).block();
                    currentRouteAndMeasure = currentRouteAndMeasure != null ? currentRouteAndMeasure
                            : gisService.getExpectedRouteAndMeasure(
                                    point.latLng(), 100,
                                    routeAndMeasureRange.getRouteId()).block();
                    if (startPtRouteAndMeasure == null || currentRouteAndMeasure == null) {
                        log.warn(
                                "Could not find matching route and measure for worker presence in recording {} for routeID {} and starting index {}, skipping observation",
                                recording.getId(), routeAndMeasureRange.getRouteId(), lastWorkerPresence.getFirst());
                    } else {
                        RouteAndMeasureRange range = RouteAndMeasureRange.fromMeasures(
                                startPtRouteAndMeasure, currentRouteAndMeasure);

                        EventRecurrence schedule = UpdateProcessorUtils
                                .getEventRecurrence(recording.getWorkerPresenceSchedule());
                        if (schedule != null) {
                            observations.add(baseObservation.copyWithSchedule(
                                    ObservationSource.WZAM_RECORDING_SCHEDULE,
                                    ObservationType.WORKER_PRESENCE,
                                    ProtobufUtils.instantFromRecurrenceEnd(schedule),
                                    ProtobufUtils.instantFromRecurrenceStart(schedule),
                                    0.5, range,
                                    new Pair<>(recording.getPoints().get(lastWorkerPresence.getFirst()).latLng(),
                                            point.latLng()),
                                    schedule));
                        }
                        else {
                            observations.add(baseObservation.copyWith(
                                    null, null, null, null,
                                    ObservationSource.WZAM_RECORDING,
                                    ObservationType.WORKER_PRESENCE, null,
                                    null,
                                    null,
                                    null,
                                    0.5,
                                    range,
                                    new Pair<>(recording.getPoints().get(lastWorkerPresence.getFirst()).latLng(),
                                            point.latLng()),
                                    null));
                        }
                    }
                }

                // Always update last seen index and value
                lastWorkerPresence = new Pair<>(i, marking.getWorkersPresent());
            }
            if (marking.getSpeedLimitMph() != null || i == recording.getPoints().size() - 1) {
                if (lastSpeedLimit.getSecond() == roadwaySpeedLimit) {
                    lastSpeedLimit = new Pair<>(i, marking.getSpeedLimitMph());
                } else if ((marking.getSpeedLimitMph() != null
                        && marking.getSpeedLimitMph() != lastSpeedLimit.getSecond())
                        || i == recording.getPoints().size() - 1) {
                    RouteAndMeasure startPtRouteAndMeasure = gisService.getExpectedRouteAndMeasure(
                            recording.getPoints().get(lastSpeedLimit.getFirst()).latLng(), 100,
                            routeAndMeasureRange.getRouteId()).block();
                    currentRouteAndMeasure = currentRouteAndMeasure != null ? currentRouteAndMeasure
                            : gisService.getExpectedRouteAndMeasure(
                                    point.latLng(), 100,
                                    routeAndMeasureRange.getRouteId()).block();
                    if (currentRouteAndMeasure == null) {
                        log.warn(
                                "Could not find matching route and measure for worker presence in recording {} for routeID {} and starting index {}, skipping observation",
                                recording.getId(), routeAndMeasureRange.getRouteId(), i);
                    } else {
                        if (Math.abs(
                                startPtRouteAndMeasure.getMeasure() - currentRouteAndMeasure.getMeasure()) < 0.15) {
                            log.warn(
                                    "Speed limit change in recording {} for routeID {} and starting index {} is too small to create an observation, skipping observation",
                                    recording.getId(), routeAndMeasureRange.getRouteId(), i);
                            lastSpeedLimit = new Pair<>(i,
                                    marking.getSpeedLimitMph() != null ? marking.getSpeedLimitMph()
                                            : roadwaySpeedLimit);
                            continue;
                        }
                        RouteAndMeasureRange range = RouteAndMeasureRange.fromMeasures(
                                startPtRouteAndMeasure,
                                currentRouteAndMeasure);
                        observations.add(baseObservation.copyWith(
                                null, null, null, null, null,
                                ObservationType.SPEED_REDUCTION_ZONE, null,
                                null, null, null,
                                1.0,
                                range,
                                new Pair<>(recording.getPoints().get(lastSpeedLimit.getFirst()).latLng(),
                                        point.latLng()),
                                lastSpeedLimit.getSecond()));

                        lastSpeedLimit = new Pair<>(i,
                                marking.getSpeedLimitMph() != null ? marking.getSpeedLimitMph() : roadwaySpeedLimit);

                    }
                }
            }
            if (i == recording.getPoints().size() - 1) {
                // Handle end of recording observation and metadata observation
                // This is not intended to handle the last observation of lane closures, worker
                // presence, or speed limits
                RouteAndMeasure firstEndPtRouteAndMeasure = gisService.getExpectedRouteAndMeasure(
                        recording.getPoints().get(i - 1).latLng(), 100,
                        routeAndMeasureRange.getRouteId()).block();
                RouteAndMeasure secondEndPtRouteAndMeasure = gisService.getExpectedRouteAndMeasure(
                        point.latLng(), 100,
                        routeAndMeasureRange.getRouteId()).block();
                if (firstEndPtRouteAndMeasure == null || secondEndPtRouteAndMeasure == null) {
                    log.warn(
                            "Could not find matching route and measure for end point in recording {} for routeID {}, skipping observation",
                            recording.getId(), routeAndMeasureRange.getRouteId(), i);
                    // TODO: Try previous points until we identify an end point
                } else {
                    RouteAndMeasureRange range = RouteAndMeasureRange.fromMeasures(
                            firstEndPtRouteAndMeasure,
                            secondEndPtRouteAndMeasure);
                    observations.add(baseObservation.copyWith(
                            null, null, null, null, null,
                            ObservationType.EVENT_END, null,
                            null, null, null,
                            1.0,
                            range,
                            new Pair<>(recording.getPoints().get(i - 1).latLng(),
                                    point.latLng()),
                            null));

                    RouteAndMeasureRange fullRouteAndMeasureRange = RouteAndMeasureRange.fromMeasures(
                            refPtRouteAndMeasure,
                            secondEndPtRouteAndMeasure);
                    observations.add(baseObservation.copyWith(
                            null, null, null, null, null,
                            ObservationType.METADATA, null, null, null, null,
                            1.0,
                            fullRouteAndMeasureRange,
                            new Pair<>(recording.getPoints().get(refPtIndex).latLng(), point.latLng()),
                            ObservationMetadata.fromRecording(recording, roadEventId, firstMarking.getLanes().size())));
                }
            }
        }

        return observations;
    }

    public static List<Observation<?>> fromConAdmin(RoadEventWrapper roadEventWrapper,
            List<RoadSubEventWrapper> roadSubEvents) {
        List<Observation<?>> observations = new ArrayList<>();
        if (roadEventWrapper == null || roadSubEvents == null || roadSubEvents.isEmpty()) {
            return observations;
        }

        RoadEvent roadEvent = roadEventWrapper.getRoadEvent();

        Observation<?> baseObservation = new Observation<>();
        baseObservation.setSourceId(String.valueOf(roadEventWrapper.getRoadEvent().getId()));
        baseObservation.setRoadEventId(roadEventWrapper.getRoadEvent().getId());
        baseObservation.setTimestamp(Instant.now());
        baseObservation.setUpdateId(baseObservation.getTimestamp().toEpochMilli());
        baseObservation.setLastUpdated(roadEventWrapper.getLastUpdated());
        baseObservation.setSource(ObservationSource.CON_ADMIN);
        baseObservation
                .setRouteAndMeasureRange(roadEventWrapper.getRouteAndMeasureRange());
        baseObservation.setConfidence(0.75);
        baseObservation.setValidFrom(ProtobufUtils.instantFromTimestamp(roadEvent.getStartDate()));
        baseObservation.setValidTo(ProtobufUtils.instantFromTimestamp(roadEvent.getEndDate()));

        // ########################## Start and End Positions ##########################
        observations.add(baseObservation.copyWith(
                null, null, null, null, null,
                ObservationType.EVENT_START, null,
                null, null, null,
                1.0,
                roadEventWrapper.getRouteAndMeasureRange(),
                roadEventWrapper.getStartAndEndPositions(),
                null));
        observations.add(baseObservation.copyWith(
                null, null, null, null, null,
                ObservationType.EVENT_END, null,
                null, null, null,
                1.0,
                roadEventWrapper.getRouteAndMeasureRange(),
                roadEventWrapper.getStartAndEndPositions(),
                null));

        // TODO: Populate observations from ConAdmin RoadEvent and RoadSubEvents
        observations.add(baseObservation.copyWith(
                null, null, null, null, null,
                ObservationType.METADATA, null, null, null, null,
                1.0,
                roadEventWrapper.getRouteAndMeasureRange(),
                roadEventWrapper.getStartAndEndPositions(),
                ObservationMetadata.fromRoadEvent(roadEventWrapper)));

        for (RoadSubEventWrapper roadSubEventWrapper : roadSubEvents) {
            List<Observation<?>> subEventObservations = fromRoadSubEvent(baseObservation, roadSubEventWrapper);
            observations.addAll(subEventObservations);
        }

        return observations;
    }

    public static List<Observation<?>> fromRoadSubEvent(Observation<?> baseObservation,
            RoadSubEventWrapper roadSubEventWrapper) {
        List<Observation<?>> observations = new ArrayList<>();
        if (roadSubEventWrapper == null) {
            return observations;
        }
        RoadSubEvent roadSubEvent = roadSubEventWrapper.getRoadSubEvent();
        RouteAndMeasureRange routeAndMeasureRange = roadSubEventWrapper.getRouteAndMeasureRange();
        switch (roadSubEvent.getLayerCase()) {
            case BASE_LAYER:
                BaseLayer baseLayer = roadSubEvent.getBaseLayer();
                observations.add(baseObservation.copyWith(
                        null, null, null, null,
                        ObservationSource.CON_ADMIN,
                        ObservationType.LANE_STATUS_ZONE, null,
                        null, null, null,
                        0.9,
                        routeAndMeasureRange,
                        roadSubEventWrapper.getStartAndEndPositions(),
                        new LaneStatusValue(baseLayer.getVehicleImpact(), null)));
                break;
            case SPEED_REDUCTION_LAYER:
                SpeedReductionLayer speedReductionLayer = roadSubEvent.getSpeedReductionLayer();
                Integer speedLimitMph = (int) Units
                        .convertMetersToMiles(speedReductionLayer.getReducedSpeedLimitKph() * 1000.0);
                observations.add(baseObservation.copyWith(
                        null, null, null, null, null,
                        ObservationType.SPEED_REDUCTION_ZONE, null,
                        null, null, null,
                        1.0,
                        routeAndMeasureRange,
                        roadSubEventWrapper.getStartAndEndPositions(),
                        speedLimitMph));
                break;
            case WORKER_PRESENCE_LAYER:
                WorkerPresenceLayer workerPresenceLayer = roadSubEvent.getWorkerPresenceLayer();
                if (workerPresenceLayer.getWorkerPresence().getAreWorkersPresent()) {
                    observations.add(baseObservation.copyWith(
                            null, null, null, null,
                            ObservationSource.CON_ADMIN,
                            ObservationType.WORKER_PRESENCE, null,
                            null, // TODO: Integrate schedule
                            null, // TODO: Integrate schedule
                            null,
                            0.5, // Low degree of confidence
                            routeAndMeasureRange,
                            roadSubEventWrapper.getStartAndEndPositions(),
                            roadSubEvent.hasSchedule() ? roadSubEvent.getSchedule() : null));
                }
                break;
            default:
                log.error("Unsupported RoadSubEvent layer type for observation: {}, {}",
                        roadSubEvent.getId(), roadSubEvent.getLayerCase().name());
                break;
        }

        return observations;
    }

    /**
     * Generates a unique key for the observation based on its properties.
     * This key is used to identify the observation in a group.
     * A consecutive update from the same exact source should produce the same key
     * 
     * @return A string key that uniquely identifies the observation.
     */
    public String getClaimKey() {
        List<String> keys = List.of(String.valueOf(roadEventId), sourceId);
        return keys.stream().filter((v) -> v != null).collect(Collectors.joining("-"));
    }

    public Observation<?> regenRouteId(String requiredRouteId, GisService gisService) {
        if (routeAndMeasureRange != null && routeAndMeasureRange.getRouteId().equals(requiredRouteId)) {
            return this; // No change needed
        }
        RouteAndMeasure startRouteAndMeasure = gisService.getExpectedRouteAndMeasure(
                rawGeometry.getFirst(), 100,
                requiredRouteId).block();
        RouteAndMeasure endRouteAndMeasure = gisService.getExpectedRouteAndMeasure(
                rawGeometry.getSecond(), 100,
                requiredRouteId).block();
        if (startRouteAndMeasure == null || endRouteAndMeasure == null) {
            log.warn("Could not regen route and measure for observation {}, {}", getClaimKey(), requiredRouteId);
            return null;
        }

        return this.copyWith(
                null, null, null, null, null,
                null, null, null, null,
                null, null,
                RouteAndMeasureRange.fromMeasures(
                        startRouteAndMeasure,
                        endRouteAndMeasure),
                null,
                null);
    }

    public Observation<?> copyWithTypeAndConfidence(
            ObservationType type,
            Double confidence) {
        return new Observation<>(
                this.sourceId,
                this.roadEventId,
                this.updateId,
                this.replacesClaims,
                this.source,
                type,
                this.timestamp,
                this.lastUpdated,
                this.validFrom,
                this.validTo,
                confidence == null ? this.confidence : confidence,
                this.routeAndMeasureRange,
                rawGeometry,
                this.value);
    }

    /**
     * Creates a copy with a new type and value, allowing the value type to change.
     * Use this when you need to create an observation of a different type from a
     * base observation.
     * 
     * @param <U>        The new value type
     * @param type       The new observation type
     * @param confidence The confidence score (null to keep current)
     * @param value      The new value (different type than current)
     * @return A new Observation with the specified type and value
     */
    public <U> Observation<U> copyWithTypeConfidenceAndValue(
            ObservationType type,
            Double confidence,
            U value) {
        return new Observation<U>(
                this.sourceId,
                this.roadEventId,
                this.updateId,
                this.replacesClaims,
                this.source,
                type,
                this.timestamp,
                this.lastUpdated,
                this.validFrom,
                this.validTo,
                confidence == null ? this.confidence : confidence,
                this.routeAndMeasureRange,
                this.rawGeometry,
                value);
    }

    public Observation<EventRecurrence> copyWithSchedule(
            ObservationSource source,
            ObservationType type,
            Instant validFrom,
            Instant validTo,
            Double confidence,
            RouteAndMeasureRange routeAndMeasureRange,
            Pair<LatLng, LatLng> rawGeometry,
            EventRecurrence schedule) {
        return new Observation<EventRecurrence>(
                this.sourceId,
                this.roadEventId,
                this.updateId,
                this.replacesClaims,
                source == null ? this.source : source,
                type,
                this.timestamp,
                this.lastUpdated,
                validFrom == null ? this.validFrom : validFrom,
                validTo == null ? this.validTo : validTo,
                confidence == null ? this.confidence : confidence,
                routeAndMeasureRange == null ? this.routeAndMeasureRange : routeAndMeasureRange,
                rawGeometry == null ? this.rawGeometry : rawGeometry,
                schedule);
    }

    public Observation<?> copyWith(
            String sourceId,
            Long roadEventId,
            Long updateId,
            Boolean replacesClaim,
            ObservationSource source,
            ObservationType type,
            Instant timestamp,
            Instant lastUpdated,
            Instant validFrom,
            Instant validTo,
            Double confidence,
            RouteAndMeasureRange routeAndMeasureRange,
            Pair<LatLng, LatLng> rawGeometry,
            Object value) {
        return new Observation<>(
                sourceId != null ? sourceId : this.sourceId,
                roadEventId != null ? roadEventId : this.roadEventId,
                updateId != null ? updateId : this.updateId,
                replacesClaims != null ? replacesClaims : this.replacesClaims,
                source != null ? source : this.source,
                type != null ? type : this.type,
                timestamp != null ? timestamp : this.timestamp,
                lastUpdated != null ? lastUpdated : this.lastUpdated,
                validFrom != null ? validFrom : this.validFrom,
                validTo != null ? validTo : this.validTo,
                confidence != null ? confidence : this.confidence,
                routeAndMeasureRange != null ? routeAndMeasureRange : this.routeAndMeasureRange,
                rawGeometry != null ? rawGeometry : this.rawGeometry,
                value != null ? value : this.value);
    }

    @SuppressWarnings("unchecked")
    public <U> U getTypedValue() {
        if (value instanceof LinkedHashMap) {
            switch (type) {
                case WORKER_PRESENCE:
                    return (U) ProtobufUtils.mapHashMapToEventRecurrence((LinkedHashMap<String, Object>) value);
                default:
                    // nothing to do
            }
        }
        return (U) value;
    }
}
