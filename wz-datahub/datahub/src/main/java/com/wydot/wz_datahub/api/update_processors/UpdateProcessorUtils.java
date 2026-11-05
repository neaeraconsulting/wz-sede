
package com.wydot.wz_datahub.api.update_processors;

import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.apache.commons.lang3.builder.Diff;
import org.apache.commons.lang3.builder.DiffResult;
import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.ReflectionDiffBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import com.google.type.LatLng;
import com.google.type.TimeOfDay;
import com.wydot.wz_datahub.api.ProtobufUtils;
import com.wydot.wz_datahub.api.models.mobile_vehicle.MobileVehicleOperationType;
import com.wydot.wz_datahub.api.models.recordings.RecordingPoint;
import com.wydot.wz_datahub.api.models.update_processing.ObservationSource;
import com.wydot.wz_datahub.api.models.workers.WorkerLocationType;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventAudit;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventUpdateStatus;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventWithContext;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventWrapper;
import com.wydot.wz_datahub.api.utilities.Units;
import com.wydot.wz_datahub.api.utilities.gis_service.GisUtils;

import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.BoundingBox;
import wyo.dot.protobuf.DataHubRoadEventUpdate;
import wyo.dot.protobuf.EventRecurrence;
import wyo.dot.protobuf.FieldDevice.FieldWorker.OperationType;
import wyo.dot.protobuf.FieldDevice.MobileVehicle.VehicleOperationType;
import wyo.dot.protobuf.RoadwayDirection;
import wyo.dot.protobuf.Lane;
import wyo.dot.protobuf.LaneStatus;
import wyo.dot.protobuf.LaneType;
import wyo.dot.protobuf.LineStringGeometry;
import wyo.dot.protobuf.MarkedLocationType;
import wyo.dot.protobuf.PointArray;
import wyo.dot.protobuf.Restriction;
import wyo.dot.protobuf.RestrictionType;
import wyo.dot.protobuf.RoadEvent;
import wyo.dot.protobuf.RoadEvent.RoadEventActiveStatus;
import wyo.dot.protobuf.RoadSubEvent.RoadSubEventLink;
import wyo.dot.protobuf.RoadSubEvent.RoadSubEventLink.RoadSubEventLinkType;
import wyo.dot.protobuf.RoadSubEvent;
import wyo.dot.protobuf.RoadSurfaceType;
import wyo.dot.protobuf.WorkZoneType;
import wyo.dot.protobuf.WorkerPresence;
import wyo.dot.protobuf.WorkerPresenceConfidence;
import wyo.dot.protobuf.WorkerPresenceDefinition;
import wyo.dot.protobuf.TypeOfWork;
import wyo.dot.protobuf.UnitOfMeasurement;
import wyo.dot.protobuf.VehicleImpact;
import wyo.dot.protobuf.WorkTypeName;
import wyo.dot.protobuf.WorkerPresenceMethod;

@Slf4j
public class UpdateProcessorUtils {
    public static long concatIds(long prefix, long suffix) {
        return Long.parseLong(String.valueOf(prefix) + String.valueOf(suffix));
    }

    public static long concatIds(long prefix, long middle, long suffix) {
        return Long.parseLong(String.valueOf(prefix) + String.valueOf(middle) + String.valueOf(suffix));
    }

    public static String generateDeterministicUuid(String workerId, String key) {
        String combined = workerId + ":" + key;
        return UUID.nameUUIDFromBytes(combined.getBytes(StandardCharsets.UTF_8)).toString();
    }

    public static WorkerPresence getWorkerPresence(
            boolean areWorkersPresent,
            ObservationSource source,
            Instant timestamp,
            double confidence) {
        return WorkerPresence.newBuilder()
                .setAreWorkersPresent(areWorkersPresent)
                .setDefinition(WorkerPresenceDefinition.WORKER_PRESENCE_DEFINITION_WORKERS_IN_WORK_ZONE_WORKING)
                .setMethod(getWorkerPresenceMethodFromObsSource(source))
                .setWorkerPresenceLastConfirmedDate(ProtobufUtils.timestampFromInstant(timestamp))
                .setConfidence(getWorkerPresenceConfidenceFromConfidence(confidence))
                .build();
    }

    private static WorkerPresenceConfidence getWorkerPresenceConfidenceFromConfidence(double confidence) {
        if (confidence >= 0.75) {
            return WorkerPresenceConfidence.WORKER_PRESENCE_CONFIDENCE_HIGH;
        } else if (confidence >= 0.5) {
            return WorkerPresenceConfidence.WORKER_PRESENCE_CONFIDENCE_MEDIUM;
        } else {
            return WorkerPresenceConfidence.WORKER_PRESENCE_CONFIDENCE_LOW;
        }
    }

    public static RoadEventAudit auditFromWrapper(RoadEventWrapper newRoadEvent,
            RoadEventWrapper previousRoadEvent,
            DataHubRoadEventUpdate dataHubRoadEventUpdate) {
        RoadEventAudit audit = new RoadEventAudit();
        audit.setRoadEventId(newRoadEvent.getRoadEvent().getId());
        audit.setUpdatedRoadEventContext(contextFromWrapper(newRoadEvent));
        audit.setPreviousRoadEventContext(contextFromWrapper(previousRoadEvent));
        audit.setRoadEventUpdateMessage(dataHubRoadEventUpdate);
        audit.setConAdminUpdateMessage(null);
        audit.setChanges(null);
        audit.setRequestId(dataHubRoadEventUpdate.getRequestId());
        audit.setTimestamp(Instant.now().toEpochMilli());
        return audit;
    }

    public static RoadEventWithContext contextFromWrapper(RoadEventWrapper wrapper) {
        RoadEventWithContext context = new RoadEventWithContext();
        context.setRoadEvent(wrapper);
        context.setProject(null);
        context.setFieldDevices(null);
        context.setReport(null);
        context.setRecording(null);
        return context;
    }

    private static WorkerPresenceMethod getWorkerPresenceMethodFromObsSource(ObservationSource source) {
        return switch (source) {
            case WZAM_REPORT -> WorkerPresenceMethod.WORKER_PRESENCE_METHOD_SCHEDULED;
            case WZAM_RECORDING -> WorkerPresenceMethod.WORKER_PRESENCE_METHOD_CHECK_IN_VERBAL;
            case WORKER_LOCATION -> WorkerPresenceMethod.WORKER_PRESENCE_METHOD_CHECK_IN_APP;
            default -> WorkerPresenceMethod.WORKER_PRESENCE_METHOD_UNKNOWN;
        };
    }

    public static RoadSurfaceType getRoadSurfaceType(
            com.wydot.wz_datahub.api.models.wz.con_admin.RoadSurfaceType surfaceType) {
        switch (surfaceType) {
            case com.wydot.wz_datahub.api.models.wz.con_admin.RoadSurfaceType.PAVED:
                return RoadSurfaceType.ROAD_SURFACE_TYPE_PAVED;
            case com.wydot.wz_datahub.api.models.wz.con_admin.RoadSurfaceType.GRAVEL:
                return RoadSurfaceType.ROAD_SURFACE_TYPE_GRAVEL;
            case com.wydot.wz_datahub.api.models.wz.con_admin.RoadSurfaceType.DIRT:
                return RoadSurfaceType.ROAD_SURFACE_TYPE_DIRT;
            case com.wydot.wz_datahub.api.models.wz.con_admin.RoadSurfaceType.GROOVED:
                return RoadSurfaceType.ROAD_SURFACE_TYPE_GROOVED;
            default:
                return null;
        }
    }

    public static RoadEventActiveStatus getActiveStatus(Instant startDate, Instant endDate) {
        Instant currTimestamp = Instant.now();
        if (startDate != null) {
            if (startDate.isAfter(currTimestamp)) {
                return RoadEventActiveStatus.ROAD_EVENT_ACTIVE_STATUS_INACTIVE;
            }
            if (endDate != null) {
                if (endDate.isBefore(currTimestamp)) {
                    return RoadEventActiveStatus.ROAD_EVENT_ACTIVE_STATUS_INACTIVE;
                } else {
                    return RoadEventActiveStatus.ROAD_EVENT_ACTIVE_STATUS_ACTIVE;
                }
            }
        }
        return RoadEventActiveStatus.ROAD_EVENT_ACTIVE_STATUS_INACTIVE;
    }

    public static WorkZoneType getAreaType(com.wydot.wz_datahub.api.models.wz.wzdx.WorkZoneType workZoneType) {
        switch (workZoneType) {
            case com.wydot.wz_datahub.api.models.wz.wzdx.WorkZoneType.STATIC:
                return WorkZoneType.WORK_ZONE_TYPE_STATIC;
            case com.wydot.wz_datahub.api.models.wz.wzdx.WorkZoneType.MOVING:
                return WorkZoneType.WORK_ZONE_TYPE_MOVING;
            case com.wydot.wz_datahub.api.models.wz.wzdx.WorkZoneType.PLANNED_MOVING_AREA:
                return WorkZoneType.WORK_ZONE_TYPE_PLANNED_MOVING_AREA;
            default:
                return WorkZoneType.WORK_ZONE_TYPE_UNKNOWN;
        }
    }

    public static List<TypeOfWork> getTypesOfWork(
            List<com.wydot.wz_datahub.api.models.wz.wzdx.TypeOfWork> typesOfWork) {
        return typesOfWork.stream().map((v) -> getTypeOfWork(v)).toList();
    }

    private static TypeOfWork getTypeOfWork(com.wydot.wz_datahub.api.models.wz.wzdx.TypeOfWork typeOfWork) {
        return TypeOfWork.newBuilder()
                .setTypeName(getWorkTypeName(typeOfWork.getTypeName()))
                .setIsArchitecturalChange(typeOfWork.isArchitecturalChange())
                .build();
    }

    private static WorkTypeName getWorkTypeName(com.wydot.wz_datahub.api.models.wz.wzdx.WorkTypeName workTypeName) {
        switch (workTypeName) {
            case com.wydot.wz_datahub.api.models.wz.wzdx.WorkTypeName.MAINTENANCE:
                return WorkTypeName.WORK_TYPE_NAME_MAINTENANCE;
            case com.wydot.wz_datahub.api.models.wz.wzdx.WorkTypeName.MINOR_ROAD_DEFECT_REPAIR:
                return WorkTypeName.WORK_TYPE_NAME_MINOR_ROAD_DEFECT_REPAIR;
            case com.wydot.wz_datahub.api.models.wz.wzdx.WorkTypeName.ROADSIDE_WORK:
                return WorkTypeName.WORK_TYPE_NAME_ROADSIDE_WORK;
            case com.wydot.wz_datahub.api.models.wz.wzdx.WorkTypeName.OVERHEAD_WORK:
                return WorkTypeName.WORK_TYPE_NAME_OVERHEAD_WORK;
            case com.wydot.wz_datahub.api.models.wz.wzdx.WorkTypeName.BELOW_ROAD_WORK:
                return WorkTypeName.WORK_TYPE_NAME_BELOW_ROAD_WORK;
            case com.wydot.wz_datahub.api.models.wz.wzdx.WorkTypeName.BARRIER_WORK:
                return WorkTypeName.WORK_TYPE_NAME_BARRIER_WORK;
            case com.wydot.wz_datahub.api.models.wz.wzdx.WorkTypeName.SURFACE_WORK:
                return WorkTypeName.WORK_TYPE_NAME_SURFACE_WORK;
            case com.wydot.wz_datahub.api.models.wz.wzdx.WorkTypeName.PAINTING:
                return WorkTypeName.WORK_TYPE_NAME_PAINTING;
            case com.wydot.wz_datahub.api.models.wz.wzdx.WorkTypeName.ROADWAY_RELOCATION:
                return WorkTypeName.WORK_TYPE_NAME_ROADWAY_RELOCATION;
            case com.wydot.wz_datahub.api.models.wz.wzdx.WorkTypeName.ROADWAY_CREATION:
                return WorkTypeName.WORK_TYPE_NAME_ROADWAY_CREATION;
            default:
                return WorkTypeName.UNRECOGNIZED;
        }
    }

    public static List<RoadSubEvent> addRseLinks(List<RoadSubEvent> roadSubEvents) {
        List<RoadSubEvent> updatedRoadSubEvents = new ArrayList<>();
        for (int i = 0; i < roadSubEvents.size(); i++) {
            RoadSubEvent rse = roadSubEvents.get(i);
            List<RoadSubEventLink> links = new ArrayList<>(rse.getLinkedEventsList());

            if (i == 1) {
                links.add(RoadSubEventLink.newBuilder()
                        .setLinkedRoadSubEventId(roadSubEvents.getFirst().getId())
                        .setRoadSubEventLinkType(RoadSubEventLinkType.ROAD_SUB_EVENT_LINK_TYPE_FIRST_IN_SEQUENCE)
                        .build());
            }
            if (i != roadSubEvents.size() - 1) {
                links.add(RoadSubEventLink.newBuilder()
                        .setLinkedRoadSubEventId(roadSubEvents.get(i + 1).getId())
                        .setRoadSubEventLinkType(RoadSubEventLinkType.ROAD_SUB_EVENT_LINK_TYPE_NEXT_IN_SEQUENCE)
                        .build());
            }
            // Not the first RSE, so set previous link
            updatedRoadSubEvents.add(rse.toBuilder().addAllLinkedEvents(links).build());
        }
        return updatedRoadSubEvents;
    }

    public static BoundingBox getBoundingBoxFromRecordingPoints(List<RecordingPoint> points) {
        List<LatLng> coordinates = points.stream()
                .map((p) -> LatLng.newBuilder()
                        .setLongitude(p.getLongitude())
                        .setLatitude(p.getLatitude())
                        .build())
                .toList();
        return getBoundingBoxFromGeometry(coordinates);
    }

    public static BoundingBox getBoundingBoxFromGeometry(List<LatLng> geometry) {
        if (geometry == null || geometry.isEmpty()) {
            log.warn(
                    "Attempted to create a bounding box from an empty or null geometry list. Returning default bounding box.");
            return null;
        }
        LatLng.Builder tr = LatLng.newBuilder().setLatitude(-90).setLongitude(-180);
        LatLng.Builder bl = LatLng.newBuilder().setLatitude(90).setLongitude(180);
        for (LatLng point : geometry) {
            if (point.getLongitude() > tr.getLongitude())
                tr = tr.setLongitude(point.getLongitude());
            if (point.getLatitude() > tr.getLatitude())
                tr = tr.setLatitude(point.getLatitude());

            if (point.getLongitude() < bl.getLongitude())
                bl = bl.setLongitude(point.getLongitude());
            if (point.getLatitude() < bl.getLatitude())
                bl = bl.setLatitude(point.getLatitude());
        }
        return BoundingBox.newBuilder()
                .setUpperRight(tr)
                .setLowerLeft(bl)
                .build();
    }

    public static LaneStatus getLaneStatus(com.wydot.wz_datahub.api.models.wz.wzdx.LaneStatus laneStatus) {
        switch (laneStatus) {
            case com.wydot.wz_datahub.api.models.wz.wzdx.LaneStatus.OPEN:
                return LaneStatus.LANE_STATUS_OPEN;
            case com.wydot.wz_datahub.api.models.wz.wzdx.LaneStatus.CLOSED:
                return LaneStatus.LANE_STATUS_CLOSED;
            case com.wydot.wz_datahub.api.models.wz.wzdx.LaneStatus.SHIFT_LEFT:
                return LaneStatus.LANE_STATUS_SHIFT_LEFT;
            case com.wydot.wz_datahub.api.models.wz.wzdx.LaneStatus.SHIFT_RIGHT:
                return LaneStatus.LANE_STATUS_SHIFT_RIGHT;
            case com.wydot.wz_datahub.api.models.wz.wzdx.LaneStatus.MERGE_LEFT:
                return LaneStatus.LANE_STATUS_MERGE_LEFT;
            case com.wydot.wz_datahub.api.models.wz.wzdx.LaneStatus.MERGE_RIGHT:
                return LaneStatus.LANE_STATUS_MERGE_RIGHT;
            case com.wydot.wz_datahub.api.models.wz.wzdx.LaneStatus.ALTERNATING_FLOW:
                return LaneStatus.LANE_STATUS_ALTERNATING_FLOW;
            default:
                return LaneStatus.UNRECOGNIZED;
        }
    }

    public static LaneType getLaneType(com.wydot.wz_datahub.api.models.wz.wzdx.LaneType laneType) {
        switch (laneType) {
            case com.wydot.wz_datahub.api.models.wz.wzdx.LaneType.GENERAL:
                return LaneType.LANE_TYPE_GENERAL;
            case com.wydot.wz_datahub.api.models.wz.wzdx.LaneType.EXIT_LANE:
                return LaneType.LANE_TYPE_EXIT_LANE;
            case com.wydot.wz_datahub.api.models.wz.wzdx.LaneType.EXIT_RAMP:
                return LaneType.LANE_TYPE_EXIT_RAMP;
            case com.wydot.wz_datahub.api.models.wz.wzdx.LaneType.ENTRANCE_LANE:
                return LaneType.LANE_TYPE_ENTRANCE_LANE;
            case com.wydot.wz_datahub.api.models.wz.wzdx.LaneType.ENTRANCE_RAMP:
                return LaneType.LANE_TYPE_ENTRANCE_RAMP;
            case com.wydot.wz_datahub.api.models.wz.wzdx.LaneType.SIDEWALK:
                return LaneType.LANE_TYPE_SIDEWALK;
            case com.wydot.wz_datahub.api.models.wz.wzdx.LaneType.BIKE_LANE:
                return LaneType.LANE_TYPE_BIKE_LANE;
            case com.wydot.wz_datahub.api.models.wz.wzdx.LaneType.SHOULDER:
                return LaneType.LANE_TYPE_SHOULDER;
            case com.wydot.wz_datahub.api.models.wz.wzdx.LaneType.PARKING:
                return LaneType.LANE_TYPE_PARKING;
            case com.wydot.wz_datahub.api.models.wz.wzdx.LaneType.MEDIAN:
                return LaneType.LANE_TYPE_MEDIAN;
            case com.wydot.wz_datahub.api.models.wz.wzdx.LaneType.TWO_WAY_CENTER_TURN_LANE:
                return LaneType.LANE_TYPE_TWO_WAY_CENTER_TURN_LANE;
            default:
                return LaneType.UNRECOGNIZED;
        }
    }

    public static RestrictionType getRestrictionType(
            com.wydot.wz_datahub.api.models.wz.wzdx.RestrictionType restrictionType) {
        switch (restrictionType) {
            case com.wydot.wz_datahub.api.models.wz.wzdx.RestrictionType.LOCAL_ACCESS_ONLY:
                return RestrictionType.RESTRICTION_TYPE_LOCAL_ACCESS_ONLY;
            case com.wydot.wz_datahub.api.models.wz.wzdx.RestrictionType.NO_TRUCKS:
                return RestrictionType.RESTRICTION_TYPE_NO_TRUCKS;
            case com.wydot.wz_datahub.api.models.wz.wzdx.RestrictionType.TRAVEL_PEAK_HOURS_ONLY:
                return RestrictionType.RESTRICTION_TYPE_TRAVEL_PEAK_HOURS_ONLY;
            case com.wydot.wz_datahub.api.models.wz.wzdx.RestrictionType.HOV_3:
                return RestrictionType.RESTRICTION_TYPE_HOV_3;
            case com.wydot.wz_datahub.api.models.wz.wzdx.RestrictionType.HOV_2:
                return RestrictionType.RESTRICTION_TYPE_HOV_2;
            case com.wydot.wz_datahub.api.models.wz.wzdx.RestrictionType.NO_PARKING:
                return RestrictionType.RESTRICTION_TYPE_NO_PARKING;
            case com.wydot.wz_datahub.api.models.wz.wzdx.RestrictionType.REDUCED_WIDTH:
                return RestrictionType.RESTRICTION_TYPE_REDUCED_WIDTH;
            case com.wydot.wz_datahub.api.models.wz.wzdx.RestrictionType.REDUCED_HEIGHT:
                return RestrictionType.RESTRICTION_TYPE_REDUCED_HEIGHT;
            case com.wydot.wz_datahub.api.models.wz.wzdx.RestrictionType.REDUCED_LENGTH:
                return RestrictionType.RESTRICTION_TYPE_REDUCED_LENGTH;
            case com.wydot.wz_datahub.api.models.wz.wzdx.RestrictionType.REDUCED_WEIGHT:
                return RestrictionType.RESTRICTION_TYPE_REDUCED_WEIGHT;
            case com.wydot.wz_datahub.api.models.wz.wzdx.RestrictionType.AXLE_LOAD_LIMIT:
                return RestrictionType.RESTRICTION_TYPE_AXLE_LOAD_LIMIT;
            case com.wydot.wz_datahub.api.models.wz.wzdx.RestrictionType.GROSS_WEIGHT_LIMIT:
                return RestrictionType.RESTRICTION_TYPE_GROSS_WEIGHT_LIMIT;
            case com.wydot.wz_datahub.api.models.wz.wzdx.RestrictionType.TOWING_PROHIBITED:
                return RestrictionType.RESTRICTION_TYPE_TOWING_PROHIBITED;
            case com.wydot.wz_datahub.api.models.wz.wzdx.RestrictionType.PERMITTED_OVERSIZE_LOADS_PROHIBITED:
                return RestrictionType.RESTRICTION_TYPE_PERMITTED_OVERSIZE_LOADS_PROHIBITED;
            case com.wydot.wz_datahub.api.models.wz.wzdx.RestrictionType.NO_PASSING:
                return RestrictionType.RESTRICTION_TYPE_NO_PASSING;
            default:
                return RestrictionType.UNRECOGNIZED;
        }
    }

    public static UnitOfMeasurement getUnitOfMeasurement(
            com.wydot.wz_datahub.api.models.wz.wzdx.UnitOfMeasurement unit) {
        switch (unit) {
            case com.wydot.wz_datahub.api.models.wz.wzdx.UnitOfMeasurement.FEET:
                return UnitOfMeasurement.UNIT_OF_MEASUREMENT_FEET;
            case com.wydot.wz_datahub.api.models.wz.wzdx.UnitOfMeasurement.INCHES:
                return UnitOfMeasurement.UNIT_OF_MEASUREMENT_INCHES;
            case com.wydot.wz_datahub.api.models.wz.wzdx.UnitOfMeasurement.CENTIMETERS:
                return UnitOfMeasurement.UNIT_OF_MEASUREMENT_CENTIMETERS;
            case com.wydot.wz_datahub.api.models.wz.wzdx.UnitOfMeasurement.POUNDS:
                return UnitOfMeasurement.UNIT_OF_MEASUREMENT_POUNDS;
            case com.wydot.wz_datahub.api.models.wz.wzdx.UnitOfMeasurement.TONS:
                return UnitOfMeasurement.UNIT_OF_MEASUREMENT_TONS;
            case com.wydot.wz_datahub.api.models.wz.wzdx.UnitOfMeasurement.KILOGRAMS:
                return UnitOfMeasurement.UNIT_OF_MEASUREMENT_KILOGRAMS;
            default:
                return UnitOfMeasurement.UNRECOGNIZED;
        }
    }

    private static Restriction getRestriction(com.wydot.wz_datahub.api.models.wz.wzdx.Restriction restriction) {
        return Restriction.newBuilder()
                .setType(getRestrictionType(restriction.getType()))
                .setValue(restriction.getValue())
                .setUnit(getUnitOfMeasurement(restriction.getUnit()))
                .build();
    }

    public static List<Lane> getLanes(List<com.wydot.wz_datahub.api.models.wz.wzdx.Lane> lanes) {
        if (lanes == null)
            return null;
        return lanes.stream().map((lane) -> Lane.newBuilder()
                .setLaneOrder(lane.getOrder())
                .addAllRestrictions(lane.getRestrictions().stream().map((v) -> getRestriction(v)).toList())
                .setStatus(UpdateProcessorUtils.getLaneStatus(lane.getStatus()))
                .setType(getLaneType(lane.getType()))
                .build()).toList();
    }

    public static boolean haveLanesChanged(List<Lane> lanes1, List<Lane> lanes2) {
        if (lanes1.size() != lanes2.size()) {
            return true;
        }
        for (int i = 0; i < lanes1.size(); i++) {
            Lane lane1 = lanes1.get(i);
            Lane lane2 = lanes2.get(i);
            if (lane1.getLaneOrder() != lane2.getLaneOrder()
                    || lane1.getStatus() != lane2.getStatus()
                    || lane1.getType() != lane2.getType()) {
                return true;
            }
        }
        return false;
    }

    public static boolean areAllLanesOpen(List<Lane> lanes) {
        if (lanes == null)
            return false;
        for (Lane lane : lanes) {
            if (lane.getStatus() != LaneStatus.LANE_STATUS_OPEN) {
                return false;
            }
        }
        return true;
    }

    public static LineStringGeometry getLineStringFromRecording(List<RecordingPoint> points) {
        return getLineStringFromLatLngs(points.stream()
                .map((point) -> LatLng
                        .newBuilder()
                        .setLongitude(point
                                .getLongitude())
                        .setLatitude(point
                                .getLatitude())
                        .build())
                .toList());
    }

    public static LineStringGeometry getLineStringFromLatLngs(List<LatLng> points) {
        return LineStringGeometry.newBuilder()
                .setCoordinates(PointArray.newBuilder()
                        .addAllCoordinates(points))
                .build();
    }

    public static RoadwayDirection getRoadwayDirection(
            com.wydot.wz_datahub.api.models.wz.wzdx.RoadwayDirection direction) {
        if (direction == null) {
            return RoadwayDirection.ROADWAY_DIRECTION_UNKNOWN;
        }
        switch (direction) {
            case com.wydot.wz_datahub.api.models.wz.wzdx.RoadwayDirection.NORTHBOUND:
                return RoadwayDirection.ROADWAY_DIRECTION_NORTHBOUND;
            case com.wydot.wz_datahub.api.models.wz.wzdx.RoadwayDirection.EASTBOUND:
                return RoadwayDirection.ROADWAY_DIRECTION_EASTBOUND;
            case com.wydot.wz_datahub.api.models.wz.wzdx.RoadwayDirection.SOUTHBOUND:
                return RoadwayDirection.ROADWAY_DIRECTION_SOUTHBOUND;
            case com.wydot.wz_datahub.api.models.wz.wzdx.RoadwayDirection.WESTBOUND:
                return RoadwayDirection.ROADWAY_DIRECTION_WESTBOUND;
            case com.wydot.wz_datahub.api.models.wz.wzdx.RoadwayDirection.INNER_LOOP:
                return RoadwayDirection.ROADWAY_DIRECTION_INNER_LOOP;
            case com.wydot.wz_datahub.api.models.wz.wzdx.RoadwayDirection.OUTER_LOOP:
                return RoadwayDirection.ROADWAY_DIRECTION_OUTER_LOOP;
            case com.wydot.wz_datahub.api.models.wz.wzdx.RoadwayDirection.UNDEFINED:
                return RoadwayDirection.ROADWAY_DIRECTION_UNDEFINED;
            case com.wydot.wz_datahub.api.models.wz.wzdx.RoadwayDirection.UNKNOWN:
                return RoadwayDirection.ROADWAY_DIRECTION_UNKNOWN;
            default:
                return RoadwayDirection.ROADWAY_DIRECTION_UNKNOWN;
        }
    }

    public static OperationType getWorkerOperationType(WorkerLocationType locationType) {
        if (locationType == null) {
            return OperationType.OPERATION_TYPE_WORKER;
        }
        switch (locationType) {
            case WorkerLocationType.WORKER:
                return OperationType.OPERATION_TYPE_WORKER;
            case WorkerLocationType.FLAGGER:
                return OperationType.OPERATION_TYPE_FLAGGER;
            case WorkerLocationType.MOBILE_OPERATOR:
                return OperationType.OPERATION_TYPE_MOBILE_IN_VEHICLE;
            default:
                return OperationType.OPERATION_TYPE_WORKER;
        }
    }

    public static VehicleOperationType getVehicleOperationType(WorkerLocationType locationType, boolean isActive) {
        if (!isActive) {
            return VehicleOperationType.VEHICLE_OPERATION_GENERAL_INACTIVE;
        } else if (locationType == null) {
            return VehicleOperationType.VEHICLE_OPERATION_GENERAL_ACTIVE;
        }
        switch (locationType) {
            case WorkerLocationType.WORKER:
                return VehicleOperationType.VEHICLE_OPERATION_GENERAL_ACTIVE;
            case WorkerLocationType.FLAGGER:
                return VehicleOperationType.VEHICLE_OPERATION_GENERAL_ACTIVE;
            case WorkerLocationType.MOBILE_OPERATOR:
                return VehicleOperationType.VEHICLE_OPERATION_GENERAL_ACTIVE;
            default:
                return VehicleOperationType.VEHICLE_OPERATION_GENERAL_ACTIVE;
        }
    }

    public static VehicleOperationType getVehicleOperationType(MobileVehicleOperationType operationType) {
        switch (operationType) {
            case MobileVehicleOperationType.STRIPING:
                return VehicleOperationType.VEHICLE_OPERATION_STRIPING;
            case MobileVehicleOperationType.PLOWING:
                return VehicleOperationType.VEHICLE_OPERATION_PLOWING;
            case MobileVehicleOperationType.MOWING:
                return VehicleOperationType.VEHICLE_OPERATION_MOWING;
            case MobileVehicleOperationType.GENERAL_ACTIVE:
                return VehicleOperationType.VEHICLE_OPERATION_GENERAL_ACTIVE;
            case MobileVehicleOperationType.GENERAL_INACTIVE:
                return VehicleOperationType.VEHICLE_OPERATION_GENERAL_INACTIVE;
            default:
                return VehicleOperationType.VEHICLE_OPERATION_UNKNOWN;
        }
    }

    public static MarkedLocationType getWorkerMarkedLocationType(WorkerLocationType locationType) {
        if (locationType == null) {
            return MarkedLocationType.MARKED_LOCATION_TYPE_WORKER_POSITION;
        }
        switch (locationType) {
            case WorkerLocationType.WORKER:
                return MarkedLocationType.MARKED_LOCATION_TYPE_WORKER_POSITION;
            case WorkerLocationType.FLAGGER:
                return MarkedLocationType.MARKED_LOCATION_TYPE_FLAGGER;
            case WorkerLocationType.MOBILE_OPERATOR:
                return MarkedLocationType.MARKED_LOCATION_TYPE_WORKER_POSITION;
            default:
                return MarkedLocationType.MARKED_LOCATION_TYPE_WORKER_POSITION;
        }
    }

    public static VehicleImpact getVehicleImpact(com.wydot.wz_datahub.api.models.wz.wzdx.VehicleImpact vehicleImpact) {
        if (vehicleImpact == null) {
            return VehicleImpact.VEHICLE_IMPACT_UNKNOWN;
        }
        switch (vehicleImpact) {
            case com.wydot.wz_datahub.api.models.wz.wzdx.VehicleImpact.ALL_LANES_CLOSED:
                return VehicleImpact.VEHICLE_IMPACT_ALL_LANES_CLOSED;
            case com.wydot.wz_datahub.api.models.wz.wzdx.VehicleImpact.SOME_LANES_CLOSED:
                return VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED;
            case com.wydot.wz_datahub.api.models.wz.wzdx.VehicleImpact.ALL_LANES_OPEN:
                return VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN;
            case com.wydot.wz_datahub.api.models.wz.wzdx.VehicleImpact.ALTERNATING_ONE_WAY:
                return VehicleImpact.VEHICLE_IMPACT_ALTERNATING_ONE_WAY;
            case com.wydot.wz_datahub.api.models.wz.wzdx.VehicleImpact.SOME_LANES_CLOSED_MERGE_LEFT:
                return VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_LEFT;
            case com.wydot.wz_datahub.api.models.wz.wzdx.VehicleImpact.SOME_LANES_CLOSED_MERGE_RIGHT:
                return VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_RIGHT;
            case com.wydot.wz_datahub.api.models.wz.wzdx.VehicleImpact.ALL_LANES_OPEN_SHIFT_LEFT:
                return VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN_SHIFT_LEFT;
            case com.wydot.wz_datahub.api.models.wz.wzdx.VehicleImpact.ALL_LANES_OPEN_SHIFT_RIGHT:
                return VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN_SHIFT_RIGHT;
            case com.wydot.wz_datahub.api.models.wz.wzdx.VehicleImpact.SOME_LANES_CLOSED_SPLIT:
                return VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_SPLIT;
            case com.wydot.wz_datahub.api.models.wz.wzdx.VehicleImpact.FLAGGING:
                return VehicleImpact.VEHICLE_IMPACT_FLAGGING;
            case com.wydot.wz_datahub.api.models.wz.wzdx.VehicleImpact.TEMPORARY_TRAFFIC_SIGNAL:
                return VehicleImpact.VEHICLE_IMPACT_TEMPORARY_TRAFFIC_SIGNAL;
            case com.wydot.wz_datahub.api.models.wz.wzdx.VehicleImpact.UNKNOWN:
            default:
                return VehicleImpact.VEHICLE_IMPACT_UNKNOWN;
        }
    }

    public static VehicleImpact getVehicleImpactFromLanes(List<Lane> lanes) {
        if (lanes == null || lanes.isEmpty()) {
            return VehicleImpact.VEHICLE_IMPACT_UNKNOWN;
        }

        int numLanes = lanes.size();

        List<Integer> closedLanes = new java.util.ArrayList<>();
        for (int i = 0; i < lanes.size(); i++) {
            if (lanes.get(i).getStatus() == LaneStatus.LANE_STATUS_CLOSED) {
                closedLanes.add(i);
            }
        }
        int numClosedLanes = closedLanes.size();
        closedLanes.sort(java.util.Comparator.naturalOrder()); // ascending

        if (numClosedLanes == 0) {
            return VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN;
        } else if (numClosedLanes == numLanes) {
            return VehicleImpact.VEHICLE_IMPACT_ALL_LANES_CLOSED;
        } else if (closedLanes.getFirst() == 0 && closedLanes.getLast() == numClosedLanes - 1) {
            return VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_RIGHT;
        } else if (closedLanes.getFirst() == numLanes - numClosedLanes
                && closedLanes.getLast() == numLanes - 1) {
            return VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_LEFT;
        } else if (closedLanes.getLast() - closedLanes.getFirst() == numClosedLanes - 1) {
            return VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_SPLIT;
        } else {
            return VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED;
        }
    }

    public static VehicleImpact getVehicleImpactSimple(VehicleImpact vehicleImpact) {
        if (vehicleImpact == null) {
            return VehicleImpact.VEHICLE_IMPACT_UNKNOWN;
        }
        switch (vehicleImpact) {
            case VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN:
            case VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN_SHIFT_LEFT:
            case VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN_SHIFT_RIGHT:
                return VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN;
            case VehicleImpact.VEHICLE_IMPACT_ALL_LANES_CLOSED:
                return VehicleImpact.VEHICLE_IMPACT_ALL_LANES_CLOSED;
            case VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED:
            case VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_LEFT:
            case VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_RIGHT:
            case VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_SPLIT:
                return VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED;
            case VehicleImpact.VEHICLE_IMPACT_FLAGGING:
                return VehicleImpact.VEHICLE_IMPACT_FLAGGING;
            case VehicleImpact.VEHICLE_IMPACT_TEMPORARY_TRAFFIC_SIGNAL:
                return VehicleImpact.VEHICLE_IMPACT_TEMPORARY_TRAFFIC_SIGNAL;
            case VehicleImpact.VEHICLE_IMPACT_ALTERNATING_ONE_WAY:
                return VehicleImpact.VEHICLE_IMPACT_ALTERNATING_ONE_WAY;
            case VehicleImpact.VEHICLE_IMPACT_UNKNOWN:
            default:
                return VehicleImpact.VEHICLE_IMPACT_UNKNOWN;
        }
    }

    public static Integer getVehicleImpactPriority(VehicleImpact vehicleImpact) {
        if (vehicleImpact == null) {
            return 0;
        }
        switch (vehicleImpact) {
            case VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN:
                return 1;
            case VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN_SHIFT_LEFT:
            case VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN_SHIFT_RIGHT:
            case VehicleImpact.VEHICLE_IMPACT_TEMPORARY_TRAFFIC_SIGNAL:
                return 2;
            case VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_LEFT:
            case VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_RIGHT:
            case VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_SPLIT:
                return 3;
            case VehicleImpact.VEHICLE_IMPACT_FLAGGING:
                return 4;
            case VehicleImpact.VEHICLE_IMPACT_ALTERNATING_ONE_WAY:
                return 5;
            case VehicleImpact.VEHICLE_IMPACT_ALL_LANES_CLOSED:
                return 6;
            case VehicleImpact.VEHICLE_IMPACT_UNKNOWN:
            default:
                return 0;
        }
    }

    public static VehicleImpact combineVehicleImpactWithLanes(VehicleImpact impact, List<Lane> lanes) {
        VehicleImpact laneImpact = getVehicleImpactFromLanes(lanes);

        VehicleImpact impactSimple = getVehicleImpactSimple(impact);
        VehicleImpact laneImpactSimple = getVehicleImpactSimple(laneImpact);

        if (impact == null || impact == VehicleImpact.VEHICLE_IMPACT_UNKNOWN) {
            return laneImpact;
        } else if (laneImpact == VehicleImpact.VEHICLE_IMPACT_UNKNOWN) {
            return impact;
        } else if (impactSimple == laneImpactSimple) {
            // Return the more complex response
            if (impactSimple == impact) {
                // If impact is already simple, return lane impact
                return laneImpact;
            } else {
                // else assume impact is the same or more complex
                return impact;
            }
        } else if (impact == VehicleImpact.VEHICLE_IMPACT_FLAGGING
                || laneImpact == VehicleImpact.VEHICLE_IMPACT_TEMPORARY_TRAFFIC_SIGNAL
                || laneImpact == VehicleImpact.VEHICLE_IMPACT_ALTERNATING_ONE_WAY) {
            // If impact is a value not determinable from lanes, prioritize it
            return impact;
        } else {
            // Else, trust determination from lanes
            return impact;
        }
    }

    public static LaneStatus getLaneStatusFromVehicleImpact(VehicleImpact vehicleImpact) {
        switch (vehicleImpact) {
            case VehicleImpact.VEHICLE_IMPACT_ALL_LANES_CLOSED:
                return LaneStatus.LANE_STATUS_CLOSED;
            case VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED:
            case VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_LEFT:
            case VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_RIGHT:
            case VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_SPLIT:
                return LaneStatus.LANE_STATUS_UNKNOWN;
            case VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN:
                return LaneStatus.LANE_STATUS_OPEN;
            case VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN_SHIFT_LEFT:
                return LaneStatus.LANE_STATUS_SHIFT_LEFT;
            case VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN_SHIFT_RIGHT:
                return LaneStatus.LANE_STATUS_SHIFT_RIGHT;
            case VehicleImpact.VEHICLE_IMPACT_ALTERNATING_ONE_WAY:
                return LaneStatus.LANE_STATUS_ALTERNATING_FLOW;
            case VehicleImpact.VEHICLE_IMPACT_FLAGGING:
            case VehicleImpact.VEHICLE_IMPACT_TEMPORARY_TRAFFIC_SIGNAL:
                return LaneStatus.LANE_STATUS_OPEN;
            case VehicleImpact.VEHICLE_IMPACT_UNKNOWN:
            default:
                return LaneStatus.LANE_STATUS_UNKNOWN;
        }
    }

    public static List<Lane> generateLanesFromVehicleImpact(Integer numLanes, VehicleImpact vehicleImpact) {
        LaneStatus laneStatus = getLaneStatusFromVehicleImpact(vehicleImpact);
        if (numLanes == null || numLanes <= 1) {
            // Submit 1 unknown type lane
            return List.of(Lane.newBuilder()
                    .setLaneOrder(1)
                    .setStatus(laneStatus)
                    .setType(LaneType.LANE_TYPE_UNKNOWN)
                    .build());
        } else if (numLanes == 1) {
            // Submit 1 unknown type lane
            return List.of(Lane.newBuilder()
                    .setLaneOrder(1)
                    .setStatus(laneStatus)
                    .setType(LaneType.LANE_TYPE_GENERAL)
                    .build());
        } else {
            List<Lane> lanes = new ArrayList<>();
            switch (vehicleImpact) {
                case VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_LEFT:
                    //
                    for (int i = 0; i < numLanes - 1; i++) {
                        lanes.add(Lane.newBuilder()
                                .setLaneOrder(i + 1)
                                .setStatus(LaneStatus.LANE_STATUS_OPEN)
                                .setType(LaneType.LANE_TYPE_GENERAL)
                                .build());
                    }
                    lanes.add(Lane.newBuilder()
                            .setLaneOrder(numLanes)
                            .setStatus(LaneStatus.LANE_STATUS_MERGE_LEFT)
                            .setType(LaneType.LANE_TYPE_GENERAL)
                            .build());
                    return lanes;
                case VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_RIGHT:
                    lanes.add(Lane.newBuilder()
                            .setLaneOrder(1)
                            .setStatus(LaneStatus.LANE_STATUS_MERGE_RIGHT)
                            .setType(LaneType.LANE_TYPE_GENERAL)
                            .build());
                    for (int i = 1; i < numLanes; i++) {
                        lanes.add(Lane.newBuilder()
                                .setLaneOrder(i + 1)
                                .setStatus(LaneStatus.LANE_STATUS_OPEN)
                                .setType(LaneType.LANE_TYPE_GENERAL)
                                .build());
                    }
                    return lanes;
                case VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_SPLIT:
                    if (numLanes % 2 != 0) {
                        for (int i = 0; i < numLanes / 2; i++) {
                            lanes.add(Lane.newBuilder()
                                    .setLaneOrder(i + 1)
                                    .setStatus(LaneStatus.LANE_STATUS_OPEN)
                                    .setType(LaneType.LANE_TYPE_GENERAL)
                                    .build());
                        }
                        lanes.add(Lane.newBuilder()
                                .setLaneOrder(numLanes / 2 + 1)
                                .setStatus(LaneStatus.LANE_STATUS_CLOSED)
                                .setType(LaneType.LANE_TYPE_GENERAL)
                                .build());
                        for (int i = numLanes / 2 + 1; i < numLanes; i++) {
                            lanes.add(Lane.newBuilder()
                                    .setLaneOrder(i + 1)
                                    .setStatus(LaneStatus.LANE_STATUS_OPEN)
                                    .setType(LaneType.LANE_TYPE_GENERAL)
                                    .build());
                        }
                        return lanes;
                    }
                case VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN:
                case VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN_SHIFT_LEFT:
                case VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN_SHIFT_RIGHT:
                case VehicleImpact.VEHICLE_IMPACT_ALTERNATING_ONE_WAY:
                case VehicleImpact.VEHICLE_IMPACT_FLAGGING:
                case VehicleImpact.VEHICLE_IMPACT_TEMPORARY_TRAFFIC_SIGNAL:
                case VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED:
                case VehicleImpact.VEHICLE_IMPACT_ALL_LANES_CLOSED:
                case VehicleImpact.VEHICLE_IMPACT_UNKNOWN:
                default:
                    // pass;
            }
            for (int i = 0; i < numLanes; i++) {
                lanes.add(Lane.newBuilder()
                        .setLaneOrder(i + 1)
                        .setStatus(laneStatus)
                        .setType(LaneType.LANE_TYPE_GENERAL)
                        .build());
            }
            return lanes;
        }
    }

    public static int getLaneStatusSeverity(LaneStatus status) {
        return switch (status) {
            case LANE_STATUS_CLOSED -> 4;
            case LANE_STATUS_ALTERNATING_FLOW -> 3;
            case LANE_STATUS_MERGE_LEFT, LANE_STATUS_MERGE_RIGHT -> 2;
            case LANE_STATUS_SHIFT_LEFT, LANE_STATUS_SHIFT_RIGHT -> 1;
            case LANE_STATUS_OPEN -> 0;
            default -> -1;
        };
    }

    public static List<Lane> combineConcurrentLanes(List<List<Lane>> concurrentLanes) {
        if (concurrentLanes == null || concurrentLanes.isEmpty()) {
            return new ArrayList<>();
        }
        // Create a deep copy of the first lane set to avoid modifying the original
        List<Lane> lanes = new ArrayList<>();
        for (Lane lane : concurrentLanes.getFirst()) {
            lanes.add(lane.toBuilder().build());
        }

        for (List<Lane> laneSet : concurrentLanes) {
            if (laneSet == null) {
                continue;
            }
            for (int i = 0; i < laneSet.size(); i++) {
                Lane lane = laneSet.get(i);
                Lane existingLane = lanes.get(i);
                if (getLaneStatusSeverity(lane.getStatus()) > getLaneStatusSeverity(existingLane.getStatus())) {
                    // Update lane status to more severe status
                    lanes.set(i, existingLane.toBuilder().setStatus(lane.getStatus()).build());
                }
            }
        }
        return lanes;
    }

    public static TimeOfDay getTimeOfDay(LocalTime time) {
        return TimeOfDay.newBuilder()
                .setHours(time.getHour())
                .setMinutes(time.getMinute())
                .setSeconds(time.getSecond())
                .setNanos(time.getNano())
                .build();
    }

    public static com.google.type.Date getDate(LocalDate date) {
        return com.google.type.Date.newBuilder()
                .setYear(date.getYear())
                .setMonth(date.getMonthValue())
                .setDay(date.getDayOfMonth())
                .build();
    }

    public static EventRecurrence getEventRecurrence(
            com.wydot.wz_datahub.api.models.reports.EventRecurrence recurrence) {
        if (recurrence == null) {
            return null;
        }
        return EventRecurrence.newBuilder()
                .setStartTime(getTimeOfDay(recurrence.getStartTime()))
                .setEndTime(getTimeOfDay(recurrence.getEndTime()))
                .setStartDate(getDate(recurrence.getStartDate()))
                .setEndDate(getDate(recurrence.getEndDate()))
                .setSunday(recurrence.getDaysOfWeek().contains(0))
                .setMonday(recurrence.getDaysOfWeek().contains(1))
                .setTuesday(recurrence.getDaysOfWeek().contains(2))
                .setWednesday(recurrence.getDaysOfWeek().contains(3))
                .setThursday(recurrence.getDaysOfWeek().contains(4))
                .setFriday(recurrence.getDaysOfWeek().contains(5))
                .setSaturday(recurrence.getDaysOfWeek().contains(6))
                .setExclusion(recurrence.getExclusion() != null ? recurrence.getExclusion() : false)
                .build();
    }

    /*
     * Compares two RoadEventWrapper objects for equality. False if different, true
     * if same
     */
    public static boolean compareRoadEventWrappers(RoadEventWrapper wrapper1, RoadEventWrapper wrapper2,
            UpdateProcessorProperties updateProcessorProperties) {
        if (wrapper1 == null && wrapper2 == null) {
            return true;
        }
        if (wrapper1 == null || wrapper2 == null) {
            return false;
        }
        List<RoadSubEvent> rse1 = wrapper1.getRoadSubEvents().stream()
                .map(rse -> rse.getRoadSubEvent())
                .toList();
        List<RoadSubEvent> rse2 = wrapper2.getRoadSubEvents().stream()
                .map(rse -> rse.getRoadSubEvent())
                .toList();
        return compareRoadSubEvents(rse1, rse2, updateProcessorProperties)
                && compareRoadEvents(wrapper1.getRoadEvent(), wrapper2.getRoadEvent(), updateProcessorProperties);
    }

    /*
     * Compares two RoadSubEvent objects for equality. False if different, true if
     * same
     */
    public static boolean compareRoadSubEvents(List<RoadSubEvent> rse1, List<RoadSubEvent> rse2,
            UpdateProcessorProperties updateProcessorProperties) {
        if (rse1 == null && rse2 == null) {
            return true;
        }
        if (rse1 == null || rse2 == null) {
            return false;
        }
        if (rse1.size() != rse2.size()) {
            return false;
        }
        for (int i = 0; i < rse1.size(); i++) {
            RoadSubEvent subEvent1 = rse1.get(i);
            RoadSubEvent subEvent2 = rse2.get(i);
            // Ignoring bbox from comparison
            if (!EqualsBuilder.reflectionEquals(subEvent1, subEvent2, "beginningMilepost_", "endingMilepost_",
                    "coordinates_",
                    "geometry_", "bbox_")) {
                DiffResult<?> diff = new ReflectionDiffBuilder<>(subEvent1, subEvent2, ToStringStyle.SHORT_PREFIX_STYLE)
                        .setExcludeFieldNames("beginningMilepost_", "endingMilepost_",
                                "coordinates_",
                                "geometry_", "bbox_")
                        .build();
                log.debug("RoadSubEvent difference found for RSE ID {}", subEvent1.getId());
                for (Diff<?> difference : diff.getDiffs()) {
                    log.debug(" - Field '{}' differs: '{}' vs '{}'", difference.getFieldName(),
                            difference.getLeft(), difference.getRight());
                }
                return false;
            }
            // Compare excluded fields separately
            if (!compareNumbers(subEvent1.getBeginningMilepost(), subEvent2.getBeginningMilepost(),
                    Units.convertMetersToMiles(updateProcessorProperties.getLocationChangeThresholdMeters()))) {
                return false;
            }
            if (!compareNumbers(subEvent1.getEndingMilepost(), subEvent2.getEndingMilepost(),
                    Units.convertMetersToMiles(updateProcessorProperties.getLocationChangeThresholdMeters()))) {
                return false;
            }
            if (subEvent1.getGeometryCase() != subEvent2.getGeometryCase()) {
                return false;
            }
            switch (subEvent1.getGeometryCase()) {
                case POINT:
                    if (GisUtils.calculateDistanceMeters(subEvent1.getPoint().getCoordinates(),
                            subEvent2.getPoint().getCoordinates()) > updateProcessorProperties
                                    .getLocationChangeThresholdMeters()) {
                        return false;
                    }
                    break;
                case LINE_STRING:
                    LatLng start1 = subEvent1.getLineString().getCoordinates().getCoordinatesList().getFirst();
                    LatLng start2 = subEvent2.getLineString().getCoordinates().getCoordinatesList().getFirst();
                    LatLng end1 = subEvent1.getLineString().getCoordinates().getCoordinatesList().getLast();
                    LatLng end2 = subEvent2.getLineString().getCoordinates().getCoordinatesList().getLast();
                    if (GisUtils.calculateDistanceMeters(start1, start2) > updateProcessorProperties
                            .getLocationChangeThresholdMeters()) {
                        return false;
                    }
                    if (GisUtils.calculateDistanceMeters(end1, end2) > updateProcessorProperties
                            .getLocationChangeThresholdMeters()) {
                        return false;
                    }

                    // Compare line string lengths within 2x threshold
                    double lineStringDistance1 = GisUtils.calculateLineStringDistanceMeters(
                            subEvent1.getLineString().getCoordinates().getCoordinatesList());
                    double lineStringDistance2 = GisUtils.calculateLineStringDistanceMeters(
                            subEvent2.getLineString().getCoordinates().getCoordinatesList());
                    if (Math.abs(lineStringDistance1 - lineStringDistance2) > 2
                            * updateProcessorProperties.getLocationChangeThresholdMeters()) {
                        return false;
                    }
                    break;
                case POLYGON:
                    // TODO: Improve polygon comparison
                    if (subEvent1.getPolygon().getCoordinates().getCoordinatesList().size() != subEvent2.getPolygon()
                            .getCoordinates().getCoordinatesList().size()) {
                        return false;
                    }
                    break;
                case GEOMETRY_NOT_SET:
                    // No geometry to compare
                    break;
            }

        }
        return true;
    }

    /* Compares two RoadEvents for equality. False if different, true if same */
    public static boolean compareRoadEvents(RoadEvent roadEvent1, RoadEvent roadEvent2,
            UpdateProcessorProperties updateProcessorProperties) {
        if (roadEvent1 == null && roadEvent2 == null) {
            return true;
        }
        if (roadEvent1 == null || roadEvent2 == null) {
            return false;
        }

        if (!EqualsBuilder.reflectionEquals(roadEvent1, roadEvent2, "geometry_", "bbox_")) {
            return false;
        }
        if (roadEvent1.getGeometryCase() != roadEvent2.getGeometryCase()) {
            return false;
        }
        switch (roadEvent1.getGeometryCase()) {
            case POINT:
                if (GisUtils.calculateDistanceMeters(roadEvent1.getPoint().getCoordinates(),
                        roadEvent2.getPoint().getCoordinates()) > updateProcessorProperties
                                .getLocationChangeThresholdMeters()) {
                    return false;
                }
                break;
            case LINE_STRING:
                LatLng start1 = roadEvent1.getLineString().getCoordinates().getCoordinatesList().getFirst();
                LatLng start2 = roadEvent2.getLineString().getCoordinates().getCoordinatesList().getFirst();
                LatLng end1 = roadEvent1.getLineString().getCoordinates().getCoordinatesList().getLast();
                LatLng end2 = roadEvent2.getLineString().getCoordinates().getCoordinatesList().getLast();
                if (GisUtils.calculateDistanceMeters(start1, start2) > updateProcessorProperties
                        .getLocationChangeThresholdMeters()) {
                    return false;
                }
                if (GisUtils.calculateDistanceMeters(end1, end2) > updateProcessorProperties
                        .getLocationChangeThresholdMeters()) {
                    return false;
                }

                // Compare line string lengths within 2x threshold
                double lineStringDistance1 = GisUtils.calculateLineStringDistanceMeters(
                        roadEvent1.getLineString().getCoordinates().getCoordinatesList());
                double lineStringDistance2 = GisUtils.calculateLineStringDistanceMeters(
                        roadEvent2.getLineString().getCoordinates().getCoordinatesList());
                if (Math.abs(lineStringDistance1 - lineStringDistance2) > 2
                        * updateProcessorProperties.getLocationChangeThresholdMeters()) {
                    return false;
                }
                break;
            case POLYGON:
                // TODO: Improve polygon comparison
                if (roadEvent1.getPolygon().getCoordinates().getCoordinatesList().size() != roadEvent2.getPolygon()
                        .getCoordinates().getCoordinatesList().size()) {
                    return false;
                }
                break;
            case GEOMETRY_NOT_SET:
                // No geometry to compare
                break;
        }
        return true;
    }

    public static boolean compareNumbers(double num1, double num2, double threshold) {
        return Math.abs(num1 - num2) <= threshold;
    }

    public static RoadEventUpdateStatus.EventStatus determineEventStatus(RoadEvent roadEvent) {
        final long now = Instant.now().toEpochMilli();
        if (roadEvent.getStartDate().getSeconds() > now) {
            return RoadEventUpdateStatus.EventStatus.UPCOMING;
        } else if (roadEvent.getEndDate().getSeconds() < now) {
            return RoadEventUpdateStatus.EventStatus.COMPLETED;
        } else {
            return RoadEventUpdateStatus.EventStatus.ONGOING;
        }
    }
}