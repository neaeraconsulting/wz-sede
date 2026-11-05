package com.wydot.wz_datahub.api.models.update_processing;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Collections;
import java.util.List;
import java.util.Objects;

import com.wydot.wz_datahub.api.ProtobufUtils;
import com.wydot.wz_datahub.api.models.recordings.RecordingWithId;
import com.wydot.wz_datahub.api.models.reports.ReportPatch;
import com.wydot.wz_datahub.api.models.reports.ReportWithId;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventWrapper;
import com.wydot.wz_datahub.api.update_processors.UpdateProcessorUtils;
import com.wydot.wz_datahub.api.models.mobile_vehicle.MobileVehicleLocation;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import wyo.dot.protobuf.RoadEvent.RoadEventActiveStatus;
import wyo.dot.protobuf.RoadSubEvent.BaseLayer;
import wyo.dot.protobuf.RoadSubEvent.SpeedReductionLayer;
import wyo.dot.protobuf.RoadSubEvent.WorkerPresenceLayer;
import wyo.dot.protobuf.RoadSubEvent;
import wyo.dot.protobuf.RoadSurfaceType;
import wyo.dot.protobuf.RoadwayDirection;
import wyo.dot.protobuf.EventRecurrence;
import wyo.dot.protobuf.RoadEvent;
import wyo.dot.protobuf.TypeOfWork;
import wyo.dot.protobuf.VehicleImpact;
import wyo.dot.protobuf.WorkZoneType;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class ObservationMetadata {

    // Copy constructor
    public ObservationMetadata(ObservationMetadata other) {
        this.projectId = other.projectId;
        this.name = other.name;
        this.description = other.description;
        this.activeStatus = other.activeStatus;
        this.startDate = other.startDate;
        this.endDate = other.endDate;
        this.roadSurfaceType = other.roadSurfaceType;
        this.areaType = other.areaType;
        this.roadwayDirection = other.roadwayDirection;
        this.roadNames = other.roadNames;
        this.typesOfWork = other.typesOfWork != null ? List.copyOf(other.typesOfWork) : null;
        this.schedule = other.schedule;
        this.source = other.source;
        this.sourceTimestamp = other.sourceTimestamp;
        this.vehicleImpact = other.vehicleImpact;
        this.roadEventId = other.roadEventId;
        this.numLanes = other.numLanes;
    }

    Long projectId;
    String name;
    String description;
    RoadEventActiveStatus activeStatus;
    Instant startDate;
    Instant endDate;
    RoadSurfaceType roadSurfaceType;
    WorkZoneType areaType;
    RoadwayDirection roadwayDirection;
    List<String> roadNames;
    List<TypeOfWork> typesOfWork;
    EventRecurrence schedule;
    ObservationSource source;
    Instant sourceTimestamp;
    VehicleImpact vehicleImpact;
    Long roadEventId;
    Integer numLanes;

    public ObservationMetadata copyWith(ObservationMetadata newObj) {
        return new ObservationMetadata(
                newObj.getProjectId() != null ? newObj.getProjectId() : projectId,
                newObj.getName() != null ? newObj.getName() : name,
                newObj.getDescription() != null ? newObj.getDescription() : description,
                newObj.getActiveStatus() != null ? newObj.getActiveStatus() : activeStatus,
                newObj.getStartDate() != null ? newObj.getStartDate() : startDate,
                newObj.getEndDate() != null ? newObj.getEndDate() : endDate,
                newObj.getRoadSurfaceType() != null ? newObj.getRoadSurfaceType() : roadSurfaceType,
                newObj.getAreaType() != null ? newObj.getAreaType() : areaType,
                newObj.getRoadwayDirection() != null ? newObj.getRoadwayDirection() : roadwayDirection,
                newObj.getRoadNames() != null ? newObj.getRoadNames() : roadNames,
                newObj.getTypesOfWork() != null ? newObj.getTypesOfWork() : typesOfWork,
                newObj.getSchedule() != null ? newObj.getSchedule() : schedule,
                newObj.getSource() != null ? newObj.getSource() : source,
                newObj.getSourceTimestamp() != null ? newObj.getSourceTimestamp() : sourceTimestamp,
                newObj.getVehicleImpact() != null ? newObj.getVehicleImpact() : vehicleImpact,
                newObj.getRoadEventId() != null ? newObj.getRoadEventId() : roadEventId,
                newObj.getNumLanes() != null ? newObj.getNumLanes() : numLanes);
    }

    public static ObservationMetadata fromReport(ReportWithId report, Long roadEventId) {
        RoadEventActiveStatus activeStatus = UpdateProcessorUtils.getActiveStatus(report.getStartDate(),
                report.getEndDate());
        ObservationMetadata metadata = new ObservationMetadata();
        metadata.setName(report.getName());
        metadata.setDescription(Objects.requireNonNullElse(report.getDescription(), ""));
        metadata.setActiveStatus(activeStatus);
        metadata.setStartDate(report.getStartDate());
        metadata.setEndDate(report.getEndDate());
        metadata.setRoadSurfaceType(UpdateProcessorUtils.getRoadSurfaceType(report.getSurfaceType()));
        metadata.setAreaType(UpdateProcessorUtils.getAreaType(report.getAreaType()));
        metadata.setRoadwayDirection(UpdateProcessorUtils.getRoadwayDirection(report.getDirection()));
        metadata.setTypesOfWork(UpdateProcessorUtils.getTypesOfWork(report.getTypesOfWork()));
        metadata.setRoadNames(report.getRoadName() != null ? List.of(report.getRoadName()) : List.of());
        metadata.setSource(ObservationSource.WZAM_REPORT);
        metadata.setSourceTimestamp(report.getTimestamp());
        metadata.setVehicleImpact(UpdateProcessorUtils.getVehicleImpact(report.getVehicleImpact()));
        metadata.setRoadEventId(roadEventId);
        metadata.setSchedule(UpdateProcessorUtils.getEventRecurrence(report.getEventSchedule()));
        return metadata;
    }

    public static ObservationMetadata fromReportPatch(ReportPatch report, Long roadEventId,
            ObservationMetadata prevMetadata) {
        Boolean isChanged = false;
        ObservationMetadata metadata = new ObservationMetadata(prevMetadata);

        if (report.getStartDate() != null || report.getEndDate() != null) {
            isChanged = true;
            if (report.getStartDate() == null) {
                metadata.setActiveStatus(
                        UpdateProcessorUtils.getActiveStatus(prevMetadata.getStartDate(), report.getEndDate()));
                metadata.setEndDate(report.getEndDate());
            } else if (report.getEndDate() == null) {
                metadata.setActiveStatus(
                        UpdateProcessorUtils.getActiveStatus(report.getStartDate(), prevMetadata.getEndDate()));
                metadata.setStartDate(report.getStartDate());
            } else {
                metadata.setActiveStatus(
                        UpdateProcessorUtils.getActiveStatus(report.getStartDate(), report.getEndDate()));
                metadata.setStartDate(report.getStartDate());
                metadata.setEndDate(report.getEndDate());
            }
        }

        if (report.getName() != null) {
            isChanged = true;
            metadata.setName(report.getName());
        }

        if (report.getDescription() != null) {
            isChanged = true;
            metadata.setDescription(report.getDescription());
        }

        if (report.getDirection() != null) {
            isChanged = true;
            metadata.setRoadwayDirection(UpdateProcessorUtils.getRoadwayDirection(report.getDirection()));
        }

        if (report.getTypesOfWork() != null) {
            isChanged = true;
            metadata.setTypesOfWork(UpdateProcessorUtils.getTypesOfWork(report.getTypesOfWork()));
        }

        if (report.getRoadName() != null) {
            isChanged = true;
            metadata.setRoadNames(List.of(report.getRoadName()));
        }

        if (report.getEventSchedule() != null) {
            isChanged = true;
            metadata.setSchedule(UpdateProcessorUtils.getEventRecurrence(report.getEventSchedule()));
        }

        // Guaranteed to exist in patch
        metadata.setSource(ObservationSource.WZAM_REPORT);
        metadata.setSourceTimestamp(report.getTimestamp());
        metadata.setRoadEventId(roadEventId);

        if (!isChanged) {
            // No changes in patch, return previous metadata to avoid unnecessary updates
            return null;
        }

        return metadata;
    }

    public static ObservationMetadata fromRecording(RecordingWithId recording, Long roadEventId, Integer numLanes) {
        RoadEventActiveStatus activeStatus = UpdateProcessorUtils.getActiveStatus(recording.getStartDate(),
                recording.getEndDate());
        ObservationMetadata metadata = new ObservationMetadata();
        metadata.setSource(ObservationSource.WZAM_RECORDING);
        metadata.setName(recording.getName());
        metadata.setDescription(Objects.requireNonNullElse(recording.getDescription(), ""));
        metadata.setActiveStatus(activeStatus);
        metadata.setStartDate(recording.getStartDate());
        metadata.setEndDate(recording.getEndDate());
        metadata.setRoadSurfaceType(UpdateProcessorUtils.getRoadSurfaceType(recording.getSurfaceType()));
        metadata.setAreaType(UpdateProcessorUtils.getAreaType(recording.getAreaType()));
        metadata.setRoadwayDirection(UpdateProcessorUtils.getRoadwayDirection(recording.getDirection()));
        metadata.setRoadNames(recording.getRoadName() != null ? List.of(recording.getRoadName()) : List.of());
        metadata.setTypesOfWork(UpdateProcessorUtils.getTypesOfWork(recording.getTypesOfWork()));
        metadata.setSourceTimestamp(recording.getTimestamp());
        metadata.setVehicleImpact(UpdateProcessorUtils.getVehicleImpact(recording.getVehicleImpact()));
        metadata.setRoadEventId(roadEventId);
        metadata.setSchedule(UpdateProcessorUtils.getEventRecurrence(recording.getEventSchedule()));
        metadata.setNumLanes(numLanes);
        return metadata;
    }

    public static ObservationMetadata fromMobileVehicle(MobileVehicleLocation mobileVehicleLocation, Long roadEventId) {
        Instant startDate = mobileVehicleLocation.getTimestamp();
        Instant endDate = mobileVehicleLocation.getTimestamp().plus(30, ChronoUnit.MINUTES);
        RoadEventActiveStatus activeStatus = UpdateProcessorUtils.getActiveStatus(startDate, endDate);
        ObservationMetadata metadata = new ObservationMetadata();
        metadata.setSource(ObservationSource.WZAM_MOBILE_VEHICLE_LOCATION);
        metadata.setName(mobileVehicleLocation.getWorkerId());
        metadata.setDescription("");
        metadata.setActiveStatus(activeStatus);
        metadata.setStartDate(startDate);
        metadata.setEndDate(endDate);
        metadata.setRoadSurfaceType(RoadSurfaceType.ROAD_SURFACE_UNKNOWN);
        metadata.setAreaType(WorkZoneType.WORK_ZONE_TYPE_MOVING);
        metadata.setRoadwayDirection(RoadwayDirection.ROADWAY_DIRECTION_UNKNOWN);
        metadata.setTypesOfWork(mobileVehicleLocation.getOperationType().getTypesOfWork());
        metadata.setSourceTimestamp(mobileVehicleLocation.getTimestamp());
        metadata.setVehicleImpact(VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN);
        metadata.setRoadEventId(roadEventId);
        metadata.setSchedule(null);
        return metadata;
    }

    public static ObservationMetadata fromRoadEvent(RoadEventWrapper roadEventWrapper) {
        RoadEvent roadEvent = roadEventWrapper.getRoadEvent();
        List<RoadSubEvent> roadSubEvents = roadEventWrapper.getUnwrappedRoadSubEvents();
        RoadSubEvent firstBaseRoadSubEvent = roadSubEvents.stream()
                .filter(rse -> rse.hasBaseLayer())
                .findFirst()
                .orElse(null);
        if (firstBaseRoadSubEvent == null) {
            throw new IllegalArgumentException(
                    "RoadEvent must have at least one base RoadSubEvent to extract metadata");
        }
        BaseLayer firstBaseLayer = firstBaseRoadSubEvent.getBaseLayer();
        RoadEventActiveStatus activeStatus = roadEvent.getStatus();
        ObservationMetadata metadata = new ObservationMetadata();
        metadata.setSource(ObservationSource.CON_ADMIN);
        metadata.setName(roadEvent.getName());
        metadata.setDescription(Objects.requireNonNullElse(roadEvent.getDescription(), ""));
        metadata.setActiveStatus(activeStatus);
        metadata.setStartDate(ProtobufUtils.instantFromTimestamp(roadEvent.getStartDate()));
        metadata.setEndDate(ProtobufUtils.instantFromTimestamp(roadEvent.getEndDate()));
        metadata.setRoadSurfaceType(firstBaseLayer.getSurfaceType());
        metadata.setAreaType(roadEvent.getAreaType());
        metadata.setRoadwayDirection(firstBaseRoadSubEvent.getDirection());
        metadata.setRoadNames(
                (firstBaseRoadSubEvent.getRoadNamesList() == null || firstBaseRoadSubEvent.getRoadNamesList().isEmpty())
                        ? Collections.emptyList()
                        : firstBaseRoadSubEvent.getRoadNamesList());
        metadata.setTypesOfWork(roadEvent.getTypesOfWorkList());
        metadata.setSourceTimestamp(roadEventWrapper.getLastUpdated());
        metadata.setRoadEventId(roadEventWrapper.getRoadEvent().getId());
        metadata.setSchedule(roadEventWrapper.getRoadEvent().getDefaultSchedule());
        if (firstBaseLayer.getLanesList() != null) {
            metadata.setNumLanes(firstBaseLayer.getLanesList().size());
        }
        return metadata;
    }

    public RoadEvent.Builder applyToRoadEvent(RoadEvent.Builder builder) {
        if (roadEventId != null) {
            builder.setId(roadEventId);
        }
        if (projectId != null) {
            builder.setProjectId(projectId);
        }
        if (name != null) {
            builder.setName(name);
        }
        if (description != null) {
            builder.setDescription(description);
        }
        if (activeStatus != null) {
            builder.setStatus(activeStatus);
        }
        if (startDate != null) {
            builder.setStartDate(ProtobufUtils.timestampFromInstant(startDate));
        }
        if (endDate != null) {
            builder.setEndDate(ProtobufUtils.timestampFromInstant(endDate));
        }
        if (roadSurfaceType != null) {
            // Surface type only supported for RSE
        }
        if (areaType != null) {
            builder.setAreaType(areaType);
        }
        if (typesOfWork != null && !typesOfWork.isEmpty()) {
            builder.clearTypesOfWork();
            builder.addAllTypesOfWork(typesOfWork);
        }
        if (schedule != null) {
            builder.setDefaultSchedule(schedule);
        }
        return builder;
    }

    public RoadSubEvent.Builder applyToRoadSubEventBase(RoadSubEvent.Builder builder) {
        BaseLayer.Builder baseLayerBuilder = BaseLayer.newBuilder();
        if (roadEventId != null) {
            builder.setId(roadEventId);
        }
        if (projectId != null) {
            builder.setProjectId(projectId);
        }
        if (roadSurfaceType != null) {
            baseLayerBuilder.setSurfaceType(roadSurfaceType);
        }
        // if (schedule != null) {
        // builder.setSchedule(schedule);
        // }
        if (roadwayDirection != null) {
            builder.setDirection(roadwayDirection);
        }
        if (roadNames != null && !roadNames.isEmpty()) {
            builder.clearRoadNames();
            builder.addAllRoadNames(roadNames);
        }
        if (vehicleImpact != null) {
            baseLayerBuilder.setVehicleImpact(vehicleImpact);
        } else {
            baseLayerBuilder.setVehicleImpact(VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN);
        }
        builder.setBaseLayer(baseLayerBuilder);
        return builder;
    }

    public RoadSubEvent.Builder applyToRoadSubEventWorkerPresence(RoadSubEvent.Builder builder) {
        WorkerPresenceLayer.Builder workerPresenceLayerBuilder = WorkerPresenceLayer.newBuilder();
        workerPresenceLayerBuilder.setWorkerPresence(UpdateProcessorUtils.getWorkerPresence(
                false, // default
                this.getSource(),
                this.getSourceTimestamp(), 0.75));
        if (roadEventId != null) {
            builder.setId(roadEventId);
        }
        if (projectId != null) {
            builder.setProjectId(projectId);
        }
        // if (schedule != null) {
        // builder.setSchedule(schedule);
        // }
        if (roadwayDirection != null) {
            builder.setDirection(roadwayDirection);
        }
        builder.setWorkerPresenceLayer(workerPresenceLayerBuilder);
        return builder;
    }

    public RoadSubEvent.Builder applyToRoadSubEventSpeedReduction(RoadSubEvent.Builder builder) {
        SpeedReductionLayer.Builder speedReductionLayerBuilder = SpeedReductionLayer.newBuilder();
        if (roadEventId != null) {
            builder.setId(roadEventId);
        }
        if (projectId != null) {
            builder.setProjectId(projectId);
        }
        // if (schedule != null) {
        // builder.setSchedule(schedule);
        // }
        if (roadwayDirection != null) {
            builder.setDirection(roadwayDirection);
        }
        builder.setSpeedReductionLayer(speedReductionLayerBuilder);
        return builder;
    }
}