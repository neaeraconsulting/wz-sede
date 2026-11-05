package com.wydot.wz_datahub.api.update_processors.field_device;

import java.time.Duration;
import java.time.Instant;

import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.models.field_devices.FieldDeviceReading;
import com.wydot.wz_datahub.api.models.gis_service.RouteAndMeasure;

import kotlin.Pair;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.FieldDevice;
import wyo.dot.protobuf.FieldDevice.FieldDeviceStatus;
import wyo.dot.protobuf.FieldDevice.MobileVehicle.VehicleOperationType;
import wyo.dot.protobuf.PointGeometry;

@Slf4j
@Component
@RequiredArgsConstructor
public class MobileVehicleUpdateProcessor {    
    
    public static FieldDeviceReading applyUpdatedReadings(FieldDeviceReading combinedReading, FieldDeviceReading avlReading, FieldDeviceReading wzamReading) {
        if (wzamReading == null) {
            return avlReading;
        } else if (avlReading == null) {
            return wzamReading;
        }

        FieldDevice combinedDevice = combinedReading.getDevice();
        FieldDevice avlDevice = avlReading.updateStatus().getDevice();
        FieldDevice wzamDevice = wzamReading.updateStatus().getDevice();
        FieldDeviceStatus avlStatus = avlDevice.getCoreDetails().getDeviceStatus();
        FieldDeviceStatus wzamStatus = wzamDevice.getCoreDetails().getDeviceStatus();

        if (avlStatus == FieldDeviceStatus.FIELD_DEVICE_STATUS_OK && wzamStatus == FieldDeviceStatus.FIELD_DEVICE_STATUS_OK) {
            // Both readings are OK, combine them
            Pair<PointGeometry, RouteAndMeasure> combinedLocation = getCombinedLocation(avlReading, wzamReading);
            FieldDevice updatedDevice = combinedDevice.toBuilder()
                            .setGeometry(combinedLocation.getFirst())
                            .setCoreDetails(combinedDevice.getCoreDetails().toBuilder()
                                    .setDeviceStatus(getCombinedStatus(avlDevice, wzamDevice))
                                    .build())
                            .setMobileVehicle(combinedDevice.getMobileVehicle().toBuilder()
                                    .setOperationType(getCombinedOperationType(avlDevice, wzamDevice))
                                    .build())
                            .build();
            Instant updatedTimestamp = Instant.ofEpochMilli(Math.max(avlReading.getLastUpdated().toEpochMilli(), wzamReading.getLastUpdated().toEpochMilli()));
            return new FieldDeviceReading(
                    updatedTimestamp,
                    combinedLocation.getSecond(),
                    updatedDevice
            );
        } else if (avlStatus == FieldDeviceStatus.FIELD_DEVICE_STATUS_OK) {
            // Only AVL is OK, use AVL data
            return avlReading;
        } else {
            return wzamReading;
        }
    }

    public static FieldDeviceReading combineFieldDeviceReadings(FieldDeviceReading avlReading, FieldDeviceReading wzamReading) {
        if (wzamReading == null) {
            return avlReading;
        } else if (avlReading == null) {
            return wzamReading;
        }

        FieldDevice avlDevice = avlReading.updateStatus().getDevice();
        FieldDevice wzamDevice = wzamReading.updateStatus().getDevice();
        FieldDeviceStatus avlStatus = avlDevice.getCoreDetails().getDeviceStatus();
        FieldDeviceStatus wzamStatus = wzamDevice.getCoreDetails().getDeviceStatus();
        VehicleOperationType wzamOperationType = wzamDevice.getMobileVehicle().getOperationType();

        boolean isWzamActive = isMobileVehicleActive(wzamDevice);
        boolean isWzamInactive = isMobileVehicleInactive(wzamDevice);

        if (avlStatus == FieldDeviceStatus.FIELD_DEVICE_STATUS_OK) {
            if (isWzamActive) {
                // Event is active, and AVL data is available
                return avlReading.withUpdatedDevice(avlDevice.toBuilder()
                        .setMobileVehicle(avlDevice.getMobileVehicle().toBuilder().setOperationType(wzamOperationType))
                        .build());
            }
            else if (isWzamInactive) {
                // Event is inactive, and AVL data is available
                return avlReading.withUpdatedDevice(avlDevice.toBuilder()
                        .setMobileVehicle(avlDevice.getMobileVehicle().toBuilder().setOperationType(wzamOperationType))
                        .build());
            } else {
                // WZAM status is unknown or not OK, use AVL data
                return avlReading;
            }
        }
        else if (wzamStatus == FieldDeviceStatus.FIELD_DEVICE_STATUS_OK) {
            // AVL status is not OK, but WZAM is. Rely on WZAM data
            return wzamReading;
        }
        else {
            // AVL status is not ok, and WZAM status is not ok. Return existing offline AVL message
            return avlReading;
        }
    }

    public static boolean isMobileVehicleActive(FieldDevice device) {
        FieldDeviceStatus status = device.getCoreDetails().getDeviceStatus();
        VehicleOperationType operationType = device.getMobileVehicle().getOperationType();
        if (status == FieldDeviceStatus.FIELD_DEVICE_STATUS_OK && (operationType != VehicleOperationType.VEHICLE_OPERATION_UNKNOWN && operationType != VehicleOperationType.VEHICLE_OPERATION_GENERAL_INACTIVE)) {
            return true;
        }
        return false;
    }

    public static boolean isMobileVehicleInactive(FieldDevice device) {
        FieldDeviceStatus status = device.getCoreDetails().getDeviceStatus();
        VehicleOperationType operationType = device.getMobileVehicle().getOperationType();
        if (status == FieldDeviceStatus.FIELD_DEVICE_STATUS_OK && operationType == VehicleOperationType.VEHICLE_OPERATION_GENERAL_INACTIVE) {
            return true;
        }
        return false;
    }

    public static FieldDeviceStatus getCombinedStatus(FieldDevice avlDevice, FieldDevice wzamDevice) {
        FieldDeviceStatus avlStatus = avlDevice.getCoreDetails().getDeviceStatus();
        FieldDeviceStatus wzamStatus = wzamDevice.getCoreDetails().getDeviceStatus();
        if (wzamStatus == FieldDeviceStatus.FIELD_DEVICE_STATUS_OK) {
            return wzamStatus;
        }
        return avlStatus;
    }

    public static VehicleOperationType getCombinedOperationType(FieldDevice avlDevice, FieldDevice wzamDevice) {
        boolean isWzamActive = isMobileVehicleActive(wzamDevice);
        boolean isAvlActive = isMobileVehicleActive(avlDevice);
        if (isWzamActive) {
            return wzamDevice.getMobileVehicle().getOperationType();
        } else if (isAvlActive) {
            return avlDevice.getMobileVehicle().getOperationType();
        } else {
            return VehicleOperationType.VEHICLE_OPERATION_GENERAL_INACTIVE;
        }
    }

    public static Pair<PointGeometry, RouteAndMeasure> getCombinedLocation(FieldDeviceReading avlReading, FieldDeviceReading wzamReading) {
        Duration avlAge = Duration.between(avlReading.getLastUpdated(), Instant.now());
        Duration wzamAge = Duration.between(wzamReading.getLastUpdated(), Instant.now());
        final long WZAM_PREFERENCE_AGE_SECONDS = 30;
        if (avlAge.toSeconds() - wzamAge.toSeconds() >= WZAM_PREFERENCE_AGE_SECONDS) {
            // AVL is more than 30 seconds older than WZAM, use WZAM location
            return new Pair<>(wzamReading.getDevice().getGeometry(), wzamReading.getRouteAndMeasure());
        } else {
            return new Pair<>(avlReading.getDevice().getGeometry(), avlReading.getRouteAndMeasure());
        }
    }
}
