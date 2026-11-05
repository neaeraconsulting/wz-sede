package com.wydot.wz_datahub.api.update_processors.field_device;

import java.time.Instant;

import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.models.field_devices.FieldDeviceUpdateCategory;
import com.wydot.wz_datahub.api.models.update_processing.Observation;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventWrapper;
import com.wydot.wz_datahub.api.update_processors.UpdateProcessorProperties;
import com.wydot.wz_datahub.api.utilities.Units;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class FieldDeviceUpdateFilter {
    private final UpdateProcessorProperties properties;

    public FieldDeviceUpdateFilter(UpdateProcessorProperties properties) {
        this.properties = properties;
    }

    public FieldDeviceUpdateCategory hasFieldDeviceObservationChanged(Observation<?> newDeviceObs,
            Observation<?> prevDeviceObs,
            RoadEventWrapper roadEvent) {
        return FieldDeviceUpdateCategory.NEW_DEVICE;

        // if (newDeviceObs == null) {
        // log.debug("New device observation is null or has no device, skipping
        // update.");
        // return null;
        // }

        // if (newDeviceObs.getRouteAndMeasureRange() == null
        // || newDeviceObs.getRouteAndMeasureRange().getRouteId() == null
        // || newDeviceObs.getRouteAndMeasureRange().getRouteId().equals("UNKNOWN")) {
        // log.debug("New device {} has no route and measure, skipping update.",
        // newDeviceObs.getSourceId());
        // return null;
        // }

        // if (prevDeviceObs == null) {
        // log.debug("Previous device observation is null, accepting update.");
        // return FieldDeviceUpdateCategory.NEW_DEVICE;
        // }

        // FieldDeviceUpdateCategory updateCategory = null;
        // // Cases
        // // 1. Important properties have changed
        // if (compareDeviceProperties(newDeviceObs, prevDeviceObs)) {
        // log.debug("Device properties have changed for device {}, accepting update.
        // Previous: {}, New: {}",
        // newDeviceObs.getSourceId(), prevDeviceObs, newDeviceObs);
        // updateCategory = FieldDeviceUpdateCategory.PROPERTY_CHANGE;
        // }

        // // 2. Position has changed sufficiently
        // // immediately filter out identical coordinates
        // if (isPositionChanged(newDeviceObs, prevDeviceObs)) {
        // log.debug("Device position has changed for device {}, accepting update.
        // Previous: {}, New: {}",
        // newDeviceObs.getSourceId(), prevDeviceObs.getRawGeometry(),
        // newDeviceObs.getRawGeometry());
        // updateCategory =
        // FieldDeviceUpdateCategory.LOCATION_CHANGE.addTo(updateCategory);
        // }

        // log.debug("Emitting field device {} with update category {}",
        // newDeviceObs.getSourceId(), updateCategory != null ? updateCategory.name() :
        // "NULL");
        // return updateCategory; // or false based on the filtering criteria
    }

    /**
     * Checks if the position of the new device has changed more than the
     * position-filter-radius-meters for that device type
     * 
     * @param newDevice  The new field device with updated coordinates.
     * @param prevDevice The previous field device with old coordinates.
     * @return True if the position has changed than the
     *         position-filter-radius-meters for that device type, false otherwise.
     */
    public boolean isPositionChanged(Observation<?> newObs, Observation<?> prevObs) {
        if (prevObs.getRouteAndMeasureRange() == null || prevObs.getRouteAndMeasureRange().getRouteId() == null
                || prevObs.getRouteAndMeasureRange().getRouteId().equals("UNKNOWN")) {
            log.debug("Previous device {} has no route and measure, accepting update.", prevObs.getSourceId());
            return true;
        } else if (newObs.getRouteAndMeasureRange().getRouteId()
                .equals(prevObs.getRouteAndMeasureRange().getRouteId()) == false) {
            log.debug("Route ID has changed for device {}, accepting update.", newObs.getSourceId());
            return true;
        }
        Double distanceMiles = newObs.getRouteAndMeasureRange().getStartMeasure()
                - prevObs.getRouteAndMeasureRange().getStartMeasure();
        Double distanceMeters = Units.convertMilesToMeters(distanceMiles);

        // Check if the distance exceeds the filter radius
        return distanceMeters >= properties.getPositionFilterRadiusMeters();
    }

    public boolean compareDeviceProperties(Observation<?> newDeviceObs, Observation<?> prevDeviceObs) {
        // Compare the core details of the devices
        if (newDeviceObs.getValidTo().isBefore(Instant.now()) && newDeviceObs.getValidTo().isAfter(Instant.now())) {
            log.debug("New device observation is more recent than previous device observation.");
            return true;
        }

        if (newDeviceObs.getValue() != null && prevDeviceObs.getValue() == null) {
            log.debug("New device observation has a value {} while previous observation is null.");
            return true;
        } else if (newDeviceObs.getValue() != null && prevDeviceObs.getValue() != null) {
            if (!newDeviceObs.getValue().equals(prevDeviceObs.getValue())) {
                log.debug("Device observation value has changed from {} to {}.",
                        prevDeviceObs.getValue(), newDeviceObs.getValue());
                return true;
            }
        }

        return false; // No changes detected
    }
}
