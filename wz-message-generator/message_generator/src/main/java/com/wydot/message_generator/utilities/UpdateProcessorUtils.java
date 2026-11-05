package com.wydot.message_generator.utilities;

import java.time.Instant;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.geojson.LineString;
import org.springframework.lang.Nullable;

import com.google.type.LatLng;
import com.wydot.message_generator.models.wz.cwz.Lane;
import com.wydot.message_generator.models.wz.cwz.LaneStatus;
import com.wydot.message_generator.models.wz.cwz.LaneType;
import com.wydot.message_generator.models.wz.cwz.LocationMethod;
import com.wydot.message_generator.models.wz.cwz.Restriction;
import com.wydot.message_generator.models.wz.cwz.RestrictionType;
import com.wydot.message_generator.models.wz.cwz.RoadwayDirection;
import com.wydot.message_generator.models.wz.cwz.TypeOfWork;
import com.wydot.message_generator.models.wz.cwz.UnitOfMeasurement;
import com.wydot.message_generator.models.wz.cwz.VehicleImpact;
import com.wydot.message_generator.models.wz.cwz.WorkTypeName;
import com.wydot.message_generator.models.wz.cwz.WorkZoneType;
import com.wydot.message_generator.models.wz.cwz.WorkerPresence;
import com.wydot.message_generator.models.wz.cwz.WorkerPresenceConfidence;
import com.wydot.message_generator.models.wz.cwz.WorkerPresenceDefinition;
import com.wydot.message_generator.models.wz.cwz.WorkerPresenceMethod;

import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.LineStringGeometry;

@Slf4j
public class UpdateProcessorUtils {
    public static long concatIds(long prefix, long suffix) {
        return Long.parseLong(String.valueOf(prefix) + String.valueOf(suffix));
    }

    public static long concatIds(long prefix, long middle, long suffix) {
        return Long.parseLong(String.valueOf(prefix) + String.valueOf(middle) + String.valueOf(suffix));
    }

    public static WorkerPresence getWorkerPresence(wyo.dot.protobuf.WorkerPresence workerPresence) {
        if (workerPresence == null) {
            return WorkerPresence.builder()
                    .areWorkersPresent(false)
                    .definition(null)
                    .method(null)
                    .workerPresenceLastConfirmedDate(null)
                    .confidence(null)
                    .build();
        }
        return WorkerPresence.builder()
                .areWorkersPresent(workerPresence.getAreWorkersPresent())
                .definition(List.of(getWorkerDefinition(workerPresence.getDefinition())))
                .method(getWorkerPresenceMethod(workerPresence.getMethod()))
                .workerPresenceLastConfirmedDate(
                        formatProtoTimestamp(workerPresence.getWorkerPresenceLastConfirmedDate()))
                .confidence(getConfidence(workerPresence.getConfidence()))
                .build();
    }

    public static LocationMethod getAreaType(wyo.dot.protobuf.LocationMethod locationMethod) {
        switch (locationMethod) {
            case wyo.dot.protobuf.LocationMethod.LOCATION_METHOD_CHANNEL_DEVICE_METHOD:
                return LocationMethod.CHANNEL_DEVICE_METHOD;
            case wyo.dot.protobuf.LocationMethod.LOCATION_METHOD_SIGN_METHOD:
                return LocationMethod.SIGN_METHOD;
            case wyo.dot.protobuf.LocationMethod.LOCATION_METHOD_JUNCTION_METHOD:
                return LocationMethod.JUNCTION_METHOD;
            case wyo.dot.protobuf.LocationMethod.LOCATION_METHOD_OTHER:
                return LocationMethod.OTHER;
            case wyo.dot.protobuf.LocationMethod.LOCATION_METHOD_UNKNOWN:
            default:
                return LocationMethod.UNKNOWN;
        }
    }

    private static WorkerPresenceDefinition getWorkerDefinition(wyo.dot.protobuf.WorkerPresenceDefinition definition) {
        return switch (definition) {
            case wyo.dot.protobuf.WorkerPresenceDefinition.WORKER_PRESENCE_DEFINITION_WORKERS_IN_WORK_ZONE_WORKING ->
                WorkerPresenceDefinition.WORKERS_IN_WORK_ZONE_WORKING;
            case wyo.dot.protobuf.WorkerPresenceDefinition.WORKER_PRESENCE_DEFINITION_WORKERS_IN_WORK_ZONE_NOT_WORKING ->
                WorkerPresenceDefinition.WORKERS_IN_WORK_ZONE_NOT_WORKING;
            case wyo.dot.protobuf.WorkerPresenceDefinition.WORKER_PRESENCE_DEFINITION_MOBILE_EQUIPMENT_IN_WORK_ZONE_MOVING ->
                WorkerPresenceDefinition.MOBILE_EQUIPMENT_IN_WORK_ZONE_MOVING;
            case wyo.dot.protobuf.WorkerPresenceDefinition.WORKER_PRESENCE_DEFINITION_MOBILE_EQUIPMENT_IN_WORK_ZONE_NOT_MOVING ->
                WorkerPresenceDefinition.MOBILE_EQUIPMENT_IN_WORK_ZONE_NOT_MOVING;
            case wyo.dot.protobuf.WorkerPresenceDefinition.WORKER_PRESENCE_DEFINITION_FIXED_EQUIPMENT_IN_WORK_ZONE ->
                WorkerPresenceDefinition.FIXED_EQUIPMENT_IN_WORK_ZONE;
            case wyo.dot.protobuf.WorkerPresenceDefinition.WORKER_PRESENCE_DEFINITION_HUMANS_BEHIND_BARRIER ->
                WorkerPresenceDefinition.HUMANS_BEHIND_BARRIER;
            case wyo.dot.protobuf.WorkerPresenceDefinition.WORKER_PRESENCE_DEFINITION_HUMANS_IN_RIGHT_OF_WAY ->
                WorkerPresenceDefinition.HUMANS_IN_RIGHT_OF_WAY;
            default -> WorkerPresenceDefinition.WORKERS_IN_WORK_ZONE_WORKING;
        };
    }

    private static WorkerPresenceMethod getWorkerPresenceMethod(wyo.dot.protobuf.WorkerPresenceMethod method) {
        return switch (method) {
            case wyo.dot.protobuf.WorkerPresenceMethod.WORKER_PRESENCE_METHOD_SCHEDULED ->
                WorkerPresenceMethod.OTHER;
            case wyo.dot.protobuf.WorkerPresenceMethod.WORKER_PRESENCE_METHOD_CHECK_IN_VERBAL ->
                WorkerPresenceMethod.CHECK_IN_VERBAL;
            case wyo.dot.protobuf.WorkerPresenceMethod.WORKER_PRESENCE_METHOD_CHECK_IN_APP ->
                WorkerPresenceMethod.CHECK_IN_APP;
            case wyo.dot.protobuf.WorkerPresenceMethod.WORKER_PRESENCE_METHOD_MAINTENANCE_VEHICLE_PRESENT ->
                WorkerPresenceMethod.MAINTENANCE_VEHICLE_PRESENT;
            case wyo.dot.protobuf.WorkerPresenceMethod.WORKER_PRESENCE_METHOD_MOBILE_DEVICE_PRESENT ->
                WorkerPresenceMethod.MOBILE_DEVICE_PRESENT;
            case wyo.dot.protobuf.WorkerPresenceMethod.WORKER_PRESENCE_METHOD_WEARABLES_PRESENT ->
                WorkerPresenceMethod.WEARABLES_PRESENT;
            case wyo.dot.protobuf.WorkerPresenceMethod.WORKER_PRESENCE_METHOD_UNKNOWN -> WorkerPresenceMethod.OTHER;
            default -> WorkerPresenceMethod.OTHER;
        };
    }

    public static WorkerPresenceConfidence getConfidence(wyo.dot.protobuf.WorkerPresenceConfidence locationMethod) {
        switch (locationMethod) {
            case wyo.dot.protobuf.WorkerPresenceConfidence.WORKER_PRESENCE_CONFIDENCE_LOW:
                return WorkerPresenceConfidence.LOW;
            case wyo.dot.protobuf.WorkerPresenceConfidence.WORKER_PRESENCE_CONFIDENCE_MEDIUM:
                return WorkerPresenceConfidence.MEDIUM;
            case wyo.dot.protobuf.WorkerPresenceConfidence.WORKER_PRESENCE_CONFIDENCE_HIGH:
                return WorkerPresenceConfidence.HIGH;
            default:
                return WorkerPresenceConfidence.LOW;
        }
    }

    public static LocationMethod getLocationMethod(wyo.dot.protobuf.LocationMethod locationMethod) {
        switch (locationMethod) {
            case wyo.dot.protobuf.LocationMethod.LOCATION_METHOD_CHANNEL_DEVICE_METHOD:
                return LocationMethod.CHANNEL_DEVICE_METHOD;
            case wyo.dot.protobuf.LocationMethod.LOCATION_METHOD_SIGN_METHOD:
                return LocationMethod.SIGN_METHOD;
            case wyo.dot.protobuf.LocationMethod.LOCATION_METHOD_JUNCTION_METHOD:
                return LocationMethod.JUNCTION_METHOD;
            case wyo.dot.protobuf.LocationMethod.LOCATION_METHOD_OTHER:
                return LocationMethod.OTHER;
            case wyo.dot.protobuf.LocationMethod.LOCATION_METHOD_UNKNOWN:
            default:
                return LocationMethod.UNKNOWN;
        }
    }

    public static WorkZoneType getWorkZoneType(wyo.dot.protobuf.WorkZoneType workZoneType) {
        switch (workZoneType) {
            case wyo.dot.protobuf.WorkZoneType.WORK_ZONE_TYPE_STATIC:
                return WorkZoneType.STATIC;
            case wyo.dot.protobuf.WorkZoneType.WORK_ZONE_TYPE_MOVING:
                return WorkZoneType.MOVING;
            case wyo.dot.protobuf.WorkZoneType.WORK_ZONE_TYPE_PLANNED_MOVING_AREA:
                return WorkZoneType.PLANNED_MOVING_AREA;
            case wyo.dot.protobuf.WorkZoneType.WORK_ZONE_TYPE_UNKNOWN:
            default:
                return WorkZoneType.STATIC;
        }
    }

    public static List<TypeOfWork> getTypesOfWork(
            List<wyo.dot.protobuf.TypeOfWork> typesOfWork) {
        return typesOfWork.stream().map((v) -> getTypeOfWork(v)).toList();
    }

    private static TypeOfWork getTypeOfWork(wyo.dot.protobuf.TypeOfWork typeOfWork) {
        return TypeOfWork.builder()
                .typeName(getWorkTypeName(typeOfWork.getTypeName()))
                .isArchitecturalChange(typeOfWork.getIsArchitecturalChange())
                .build();
    }

    private static WorkTypeName getWorkTypeName(wyo.dot.protobuf.WorkTypeName workTypeName) {
        switch (workTypeName) {
            case wyo.dot.protobuf.WorkTypeName.WORK_TYPE_NAME_MAINTENANCE:
                return WorkTypeName.NON_ENCROACHMENT;
            case wyo.dot.protobuf.WorkTypeName.WORK_TYPE_NAME_MINOR_ROAD_DEFECT_REPAIR:
                return WorkTypeName.MINOR_ROAD_DEFECT_REPAIR;
            case wyo.dot.protobuf.WorkTypeName.WORK_TYPE_NAME_ROADSIDE_WORK:
                return WorkTypeName.ROADSIDE_WORK;
            case wyo.dot.protobuf.WorkTypeName.WORK_TYPE_NAME_OVERHEAD_WORK:
                return WorkTypeName.OVERHEAD_WORK;
            case wyo.dot.protobuf.WorkTypeName.WORK_TYPE_NAME_BELOW_ROAD_WORK:
                return WorkTypeName.BELOW_ROAD_WORK;
            case wyo.dot.protobuf.WorkTypeName.WORK_TYPE_NAME_BARRIER_WORK:
                return WorkTypeName.BARRIER_WORK;
            case wyo.dot.protobuf.WorkTypeName.WORK_TYPE_NAME_SURFACE_WORK:
                return WorkTypeName.SURFACE_WORK;
            case wyo.dot.protobuf.WorkTypeName.WORK_TYPE_NAME_PAINTING:
                return WorkTypeName.PAINTING;
            case wyo.dot.protobuf.WorkTypeName.WORK_TYPE_NAME_ROADWAY_RELOCATION:
                return WorkTypeName.ROADWAY_RELOCATION;
            case wyo.dot.protobuf.WorkTypeName.WORK_TYPE_NAME_ROADWAY_CREATION:
                return WorkTypeName.ROADWAY_CREATION;
            default:
                return WorkTypeName.ROADSIDE_WORK;
        }
    }

    public static List<Double> getBoundingBoxFromGeometry(List<LatLng> geometry) {
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
        return List.of(
                bl.getLongitude(),
                bl.getLatitude(),
                tr.getLongitude(),
                tr.getLatitude());
    }

    public static LaneStatus getLaneStatus(wyo.dot.protobuf.LaneStatus laneStatus) {
        switch (laneStatus) {
            case wyo.dot.protobuf.LaneStatus.LANE_STATUS_OPEN:
                return LaneStatus.OPEN;
            case wyo.dot.protobuf.LaneStatus.LANE_STATUS_CLOSED:
                return LaneStatus.CLOSED;
            case wyo.dot.protobuf.LaneStatus.LANE_STATUS_SHIFT_LEFT:
                return LaneStatus.SHIFT_LEFT;
            case wyo.dot.protobuf.LaneStatus.LANE_STATUS_SHIFT_RIGHT:
                return LaneStatus.SHIFT_RIGHT;
            case wyo.dot.protobuf.LaneStatus.LANE_STATUS_MERGE_LEFT:
                return LaneStatus.MERGE_LEFT;
            case wyo.dot.protobuf.LaneStatus.LANE_STATUS_MERGE_RIGHT:
                return LaneStatus.MERGE_RIGHT;
            case wyo.dot.protobuf.LaneStatus.LANE_STATUS_ALTERNATING_FLOW:
                return LaneStatus.ALTERNATING_FLOW;
            default:
                return LaneStatus.OPEN;
        }
    }

    public static LaneType getLaneType(wyo.dot.protobuf.LaneType laneType) {
        switch (laneType) {
            case wyo.dot.protobuf.LaneType.LANE_TYPE_GENERAL:
                return LaneType.GENERAL;
            case wyo.dot.protobuf.LaneType.LANE_TYPE_EXIT_LANE:
                return LaneType.EXIT_LANE;
            case wyo.dot.protobuf.LaneType.LANE_TYPE_EXIT_RAMP:
                return LaneType.EXIT_RAMP;
            case wyo.dot.protobuf.LaneType.LANE_TYPE_ENTRANCE_LANE:
                return LaneType.ENTRANCE_LANE;
            case wyo.dot.protobuf.LaneType.LANE_TYPE_ENTRANCE_RAMP:
                return LaneType.ENTRANCE_RAMP;
            case wyo.dot.protobuf.LaneType.LANE_TYPE_SIDEWALK:
                return LaneType.SIDEWALK;
            case wyo.dot.protobuf.LaneType.LANE_TYPE_BIKE_LANE:
                return LaneType.BIKE_LANE;
            case wyo.dot.protobuf.LaneType.LANE_TYPE_SHOULDER:
                return LaneType.SHOULDER;
            case wyo.dot.protobuf.LaneType.LANE_TYPE_PARKING:
                return LaneType.PARKING;
            case wyo.dot.protobuf.LaneType.LANE_TYPE_MEDIAN:
                return LaneType.MEDIAN;
            case wyo.dot.protobuf.LaneType.LANE_TYPE_TWO_WAY_CENTER_TURN_LANE:
                return LaneType.TWO_WAY_CENTER_TURN_LANE;
            default:
                return LaneType.GENERAL;
        }
    }

    public static @Nullable RestrictionType getRestrictionType(
            wyo.dot.protobuf.RestrictionType restrictionType) {
        switch (restrictionType) {
            case wyo.dot.protobuf.RestrictionType.RESTRICTION_TYPE_LOCAL_ACCESS_ONLY:
                return RestrictionType.LOCAL_ACCESS_ONLY;
            case wyo.dot.protobuf.RestrictionType.RESTRICTION_TYPE_NO_TRUCKS:
                return RestrictionType.NO_TRUCKS;
            case wyo.dot.protobuf.RestrictionType.RESTRICTION_TYPE_TRAVEL_PEAK_HOURS_ONLY:
                return RestrictionType.TRAVEL_PEAK_HOURS_ONLY;
            case wyo.dot.protobuf.RestrictionType.RESTRICTION_TYPE_HOV_3:
                return RestrictionType.HOV_3;
            case wyo.dot.protobuf.RestrictionType.RESTRICTION_TYPE_HOV_2:
                return RestrictionType.HOV_2;
            case wyo.dot.protobuf.RestrictionType.RESTRICTION_TYPE_NO_PARKING:
                return RestrictionType.NO_PARKING;
            case wyo.dot.protobuf.RestrictionType.RESTRICTION_TYPE_REDUCED_WIDTH:
                return RestrictionType.REDUCED_WIDTH;
            case wyo.dot.protobuf.RestrictionType.RESTRICTION_TYPE_REDUCED_HEIGHT:
                return RestrictionType.REDUCED_HEIGHT;
            case wyo.dot.protobuf.RestrictionType.RESTRICTION_TYPE_REDUCED_LENGTH:
                return RestrictionType.REDUCED_LENGTH;
            case wyo.dot.protobuf.RestrictionType.RESTRICTION_TYPE_REDUCED_WEIGHT:
                return RestrictionType.REDUCED_WEIGHT;
            case wyo.dot.protobuf.RestrictionType.RESTRICTION_TYPE_AXLE_LOAD_LIMIT:
                return RestrictionType.AXLE_LOAD_LIMIT;
            case wyo.dot.protobuf.RestrictionType.RESTRICTION_TYPE_GROSS_WEIGHT_LIMIT:
                return RestrictionType.GROSS_WEIGHT_LIMIT;
            case wyo.dot.protobuf.RestrictionType.RESTRICTION_TYPE_TOWING_PROHIBITED:
                return RestrictionType.TOWING_PROHIBITED;
            case wyo.dot.protobuf.RestrictionType.RESTRICTION_TYPE_PERMITTED_OVERSIZE_LOADS_PROHIBITED:
                return RestrictionType.PERMITTED_OVERSIZE_LOADS_PROHIBITED;
            case wyo.dot.protobuf.RestrictionType.RESTRICTION_TYPE_NO_PASSING:
                return RestrictionType.NO_PASSING;
            default:
                return null;
        }
    }

    public static @Nullable UnitOfMeasurement getUnitOfMeasurement(
            wyo.dot.protobuf.UnitOfMeasurement unit) {
        switch (unit) {
            case wyo.dot.protobuf.UnitOfMeasurement.UNIT_OF_MEASUREMENT_FEET:
                return UnitOfMeasurement.FEET;
            case wyo.dot.protobuf.UnitOfMeasurement.UNIT_OF_MEASUREMENT_INCHES:
                return UnitOfMeasurement.INCHES;
            case wyo.dot.protobuf.UnitOfMeasurement.UNIT_OF_MEASUREMENT_CENTIMETERS:
                return UnitOfMeasurement.CENTIMETERS;
            case wyo.dot.protobuf.UnitOfMeasurement.UNIT_OF_MEASUREMENT_POUNDS:
                return UnitOfMeasurement.POUNDS;
            case wyo.dot.protobuf.UnitOfMeasurement.UNIT_OF_MEASUREMENT_TONS:
                return UnitOfMeasurement.TONS;
            case wyo.dot.protobuf.UnitOfMeasurement.UNIT_OF_MEASUREMENT_KILOGRAMS:
                return UnitOfMeasurement.KILOGRAMS;
            default:
                return null;
        }
    }

    private static Restriction getRestriction(wyo.dot.protobuf.Restriction restriction) {
        return Restriction.builder()
                .type(getRestrictionType(restriction.getType()))
                .value(restriction.getValue())
                .unit(getUnitOfMeasurement(restriction.getUnit()))
                .build();
    }

    public static List<Restriction> getRestrictions(List<wyo.dot.protobuf.Restriction> restrictions) {
        if (restrictions == null)
            return null;

        return restrictions.stream()
                .map((restriction) -> getRestriction(restriction))
                .toList();
    }

    public static List<Lane> getLanes(List<wyo.dot.protobuf.Lane> lanes) {
        if (lanes == null)
            return null;

        return lanes.stream().map((lane) -> Lane.builder()
                .order(lane.getLaneOrder() + 1) // convert from 0-indexed to 1-indexed
                .restrictions(lane.getRestrictionsList().stream().map((v) -> getRestriction(v)).toList())
                .status(UpdateProcessorUtils.getLaneStatus(lane.getStatus()))
                .type(getLaneType(lane.getType()))
                .build()).toList();
    }

    public static LineString getLineStringFromLatLngs(List<LatLng> points) {
        LineString lineString = new LineString();
        for (LatLng point : points) {
            // GeoJSON uses longitude, latitude order (opposite of LatLng)
            lineString.add(new org.geojson.LngLatAlt(point.getLongitude(), point.getLatitude()));
        }
        return lineString;
    }

    public static LineString getLineStringFromLineString(LineStringGeometry geometry) {
        return getLineStringFromLatLngs(geometry.getCoordinates().getCoordinatesList());
    }

    public static RoadwayDirection getRoadwayDirection(
            wyo.dot.protobuf.RoadwayDirection direction) {
        if (direction == null) {
            return RoadwayDirection.UNKNOWN;
        }
        switch (direction) {
            case wyo.dot.protobuf.RoadwayDirection.ROADWAY_DIRECTION_NORTHBOUND:
                return RoadwayDirection.NORTHBOUND;
            case wyo.dot.protobuf.RoadwayDirection.ROADWAY_DIRECTION_EASTBOUND:
                return RoadwayDirection.EASTBOUND;
            case wyo.dot.protobuf.RoadwayDirection.ROADWAY_DIRECTION_SOUTHBOUND:
                return RoadwayDirection.SOUTHBOUND;
            case wyo.dot.protobuf.RoadwayDirection.ROADWAY_DIRECTION_WESTBOUND:
                return RoadwayDirection.WESTBOUND;
            case wyo.dot.protobuf.RoadwayDirection.ROADWAY_DIRECTION_INNER_LOOP:
                return RoadwayDirection.INNER_LOOP;
            case wyo.dot.protobuf.RoadwayDirection.ROADWAY_DIRECTION_OUTER_LOOP:
                return RoadwayDirection.OUTER_LOOP;
            case wyo.dot.protobuf.RoadwayDirection.ROADWAY_DIRECTION_UNDEFINED:
                return RoadwayDirection.UNDEFINED;
            case wyo.dot.protobuf.RoadwayDirection.ROADWAY_DIRECTION_UNKNOWN:
                return RoadwayDirection.UNKNOWN;
            default:
                return RoadwayDirection.UNKNOWN;
        }
    }

    public static VehicleImpact getVehicleImpact(wyo.dot.protobuf.VehicleImpact vehicleImpact) {
        if (vehicleImpact == null) {
            return VehicleImpact.UNKNOWN;
        }
        switch (vehicleImpact) {
            case wyo.dot.protobuf.VehicleImpact.VEHICLE_IMPACT_ALL_LANES_CLOSED:
                return VehicleImpact.ALL_LANES_CLOSED;
            case wyo.dot.protobuf.VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED:
                return VehicleImpact.SOME_LANES_CLOSED;
            case wyo.dot.protobuf.VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN:
                return VehicleImpact.ALL_LANES_OPEN;
            case wyo.dot.protobuf.VehicleImpact.VEHICLE_IMPACT_ALTERNATING_ONE_WAY:
                return VehicleImpact.ALTERNATING_ONE_WAY;
            case wyo.dot.protobuf.VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_LEFT:
                return VehicleImpact.SOME_LANES_CLOSED_MERGE_LEFT;
            case wyo.dot.protobuf.VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_RIGHT:
                return VehicleImpact.SOME_LANES_CLOSED_MERGE_RIGHT;
            case wyo.dot.protobuf.VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN_SHIFT_LEFT:
                return VehicleImpact.ALL_LANES_OPEN_SHIFT_LEFT;
            case wyo.dot.protobuf.VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN_SHIFT_RIGHT:
                return VehicleImpact.ALL_LANES_OPEN_SHIFT_RIGHT;
            case wyo.dot.protobuf.VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_SPLIT:
                return VehicleImpact.SOME_LANES_CLOSED_SPLIT;
            case wyo.dot.protobuf.VehicleImpact.VEHICLE_IMPACT_FLAGGING:
                return VehicleImpact.FLAGGING;
            case wyo.dot.protobuf.VehicleImpact.VEHICLE_IMPACT_TEMPORARY_TRAFFIC_SIGNAL:
                return VehicleImpact.TEMPORARY_TRAFFIC_SIGNAL;
            case wyo.dot.protobuf.VehicleImpact.VEHICLE_IMPACT_UNKNOWN:
            default:
                return VehicleImpact.UNKNOWN;
        }
    }

    public static String formatDateTime(Instant instant) {
        // format like 2020-06-18T15:00:00Z
        return DateTimeFormatter.ISO_INSTANT.format(instant);
    }

    public static String formatProtoTimestamp(com.google.protobuf.Timestamp timestamp) {
        if (timestamp == null) {
            return null;
        }
        return formatDateTime(ProtobufUtils.instantFromTimestamp(timestamp));
    }
}
