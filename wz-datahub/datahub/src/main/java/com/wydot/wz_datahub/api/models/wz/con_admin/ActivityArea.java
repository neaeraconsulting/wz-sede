package com.wydot.wz_datahub.api.models.wz.con_admin;

import com.wydot.wz_datahub.api.models.wz.wzdx.*;
import lombok.Data;

import java.util.List;

@Data
public class ActivityArea {
    private Integer id;
    private int segmentId;
    private String areaName;
    private String description;
    private long creationDate;
    private long updateDate;
    private long startDate;
    private long endDate;
    private Boolean startDateVerified;
    private Boolean endDateVerified;
    private WorkZoneType areaType;
    private LocationMethod locationMethod;
    private VehicleImpact vehicleImpact;
    private List<String> impactedCdsCurbZones;
    private List<Lane> lanes;
    private String beginningCrossStreet;
    private String endingCrossStreet;
    private String beginningMilepost;
    private String endingMilepost;
    private List<TypeOfWork> typesOfWork;
    private WorkerPresence workerPresence;
    private Float reducedSpeedLimitKph;
    private List<Restriction> restrictions;
    private List<List<Float>> geometry;
    private List<List<Float>> bbox;
}