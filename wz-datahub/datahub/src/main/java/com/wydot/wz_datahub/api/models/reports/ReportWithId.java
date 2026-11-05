package com.wydot.wz_datahub.api.models.reports;

import org.springframework.data.mongodb.core.mapping.Document;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.wydot.wz_datahub.api.models.gis_service.RouteAndMeasure;
import com.wydot.wz_datahub.api.models.gis_service.RouteAndMeasureRange;
import com.wydot.wz_datahub.api.utilities.gis_service.GisService;
import com.wydot.wz_datahub.api.utilities.Units;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@Document(collection = "datahub.reports")
public class ReportWithId extends Report {
    @JsonProperty("id")
    private Long id;

    // Default constructor required by Spring Data
    public ReportWithId() {
        super();
    }

    public ReportWithId(Long id, Report report) {
        super(report.getProjectId(),
                report.getRoadEventId(),
                report.getName(),
                report.getDescription(),
                report.getTypesOfWork(),
                report.getRoadName(),
                report.getDirection(),
                report.getWorkersPresent(),
                report.getStartDate(),
                report.getEndDate(),
                report.getTimestamp(),
                report.getAreaType(),
                report.getVehicleImpact(),
                report.getSpeedLimitMph(),
                report.getGeometryType(),
                report.getGeometry(),
                report.getGeometryLineWidth(),
                report.getLicensePlate(),
                report.getSurfaceType(),
                report.getUserId(),
                report.getEventSchedule(),
                report.getWorkerPresenceSchedule(),
                report.getLinkedFieldDeviceIds());
        this.id = id;
    }

    public RouteAndMeasureRange getRouteAndMeasureRange(GisService gisService) {
        RouteAndMeasureRange range = gisService
                .getMatchingRouteAndMeasure(this.getGeometry().getFirst(), this.getGeometry().getLast(), 100).block();

        if (range == null) {
            RouteAndMeasure startRouteAndMeasure = gisService
                .getClosestRouteAndMeasure(this.getGeometry().getFirst(), 100).block();
            RouteAndMeasure endRouteAndMeasure = gisService
                    .getClosestRouteAndMeasure(this.getGeometry().getLast(), 100).block();
            if (startRouteAndMeasure == null || endRouteAndMeasure == null) {
                // Must generate measures as distance
                // Measure distance between start and end point
                startRouteAndMeasure = new RouteAndMeasure("UNKNOWN", "UNKNOWN", 0.0, 0.0);
                double distanceMeters = 1000; // GisUtils.calculateLineStringDistanceMeters(this.getGeometry());
                double distanceMiles = Units.convertMetersToMiles(distanceMeters);
                endRouteAndMeasure = new RouteAndMeasure("UNKNOWN", "UNKNOWN", distanceMiles, distanceMiles);
            }
            return RouteAndMeasureRange.fromMeasures(startRouteAndMeasure, endRouteAndMeasure);
        } else {
            return range;
        }
    }
}
