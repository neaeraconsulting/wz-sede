package com.wydot.wz_datahub.api.update_processors;

import java.time.Duration;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.utilities.Units;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Data
@Component
@ConfigurationProperties(prefix = "update-processing")
public class UpdateProcessorProperties {
    private double updatePeriodsBeforeOffline = 2;
    private double speedReductionMinDistanceMeters = 200;
    private double workerSeparationMinDistanceMeters = 100;
    private double fieldDeviceRoadSubEventThresholdMeters = 100;
    private Duration ageBeforeOffline = Duration.ofMinutes(30);
    private Duration observationReevalPeriod = Duration.ofMinutes(5);

    private Double positionFilterRadiusMeters;
    private Double maxRoadwayDistanceMeters;
    private Duration fieldDeviceMaxReUpdatePeriod;
    private Duration vehicleMaxReUpdatePeriod;
    private Double locationChangeThresholdMeters;

    private double speedReductionMinDistanceMiles = Units.convertMetersToMiles(speedReductionMinDistanceMeters);
    private boolean workerLocationUpdatesEnabled;
    private boolean vehicleLocationUpdatesEnabled;
}
