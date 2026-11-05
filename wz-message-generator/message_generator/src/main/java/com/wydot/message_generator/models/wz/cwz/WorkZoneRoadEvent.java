package com.wydot.message_generator.models.wz.cwz;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Builder;
import lombok.Data;

import java.util.List;

/**
 * Class representing a work zone road event
 * 
 * @see <a href=
 *      "https://github.com/usdot-jpo-ode/wzdx/blob/main/spec-content/objects/WorkZoneRoadEvent.md">WorkZoneRoadEvent</a>
 */
@Data
@Builder
public class WorkZoneRoadEvent {
    @JsonProperty("core_details")
    private RoadEventCoreDetails coreDetails;
    @JsonProperty("start_date")
    private String startDate;
    @JsonProperty("end_date")
    private String endDate;
    @JsonProperty("is_start_date_verified")
    private Boolean isStartDateVerified;
    @JsonProperty("is_end_date_verified")
    private Boolean isEndDateVerified;
    @JsonProperty("is_start_position_verified")
    private Boolean isStartPositionVerified;
    @JsonProperty("is_end_position_verified")
    private Boolean isEndPositionVerified;
    @JsonProperty("work_zone_type")
    private WorkZoneType workZoneType;
    @JsonProperty("location_method")
    private LocationMethod locationMethod;
    @JsonProperty("vehicle_impact")
    private VehicleImpact vehicleImpact;
    @JsonProperty("impacted_cds_curb_zones")
    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    private List<CdsCurbZonesReference> impactedCdsCurbZones;
    @JsonProperty("lanes")
    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    private List<Lane> lanes;
    @JsonProperty("beginning_cross_street")
    private String beginningCrossStreet;
    @JsonProperty("ending_cross_street")
    private String endingCrossStreet;
    @JsonProperty("beginning_milepost")
    private Double beginningMilepost;
    @JsonProperty("ending_milepost")
    private Double endingMilepost;
    @JsonProperty("types_of_work")
    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    private List<TypeOfWork> typesOfWork;
    @JsonProperty("worker_presence")
    private WorkerPresence workerPresence;
    @JsonProperty("reduced_speed_limit_kph")
    private Double reducedSpeedLimitKph;
    @JsonProperty("restrictions")
    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    private List<Restriction> restrictions;
}
