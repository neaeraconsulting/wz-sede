package com.wydot.wz_datahub.api.controllers.kafka;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.google.type.LatLng;
import com.wydot.wz_datahub.api.accessors.field_devices.FieldDeviceReadingRepository;
import com.wydot.wz_datahub.api.accessors.field_devices.FieldDeviceLinkRepository;
import com.wydot.wz_datahub.api.models.field_devices.FieldDeviceLink;
import com.wydot.wz_datahub.api.models.field_devices.FieldDeviceManufacturer;
import com.wydot.wz_datahub.api.models.field_devices.FieldDeviceReading;
import com.wydot.wz_datahub.api.models.raw_vehicle_location.RawVehicleLocation;
import com.wydot.wz_datahub.api.utilities.gis_service.GisService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.FieldDevice;
import wyo.dot.protobuf.MarkedLocationType;
import wyo.dot.protobuf.PointGeometry;
import wyo.dot.protobuf.FieldDevice.FieldDeviceCoreDetails;
import wyo.dot.protobuf.FieldDevice.FieldDeviceStatus;
import wyo.dot.protobuf.FieldDevice.MobileVehicle;
import wyo.dot.protobuf.FieldDevice.MobileVehicle.VehicleOperationType;

@RestController
@Slf4j
@RequestMapping("/kafka")
@RequiredArgsConstructor
public class RawVehicleLocationUpdateController {
    private final GisService gisService;
    private final FieldDeviceLinkRepository fieldDeviceRepository;
    private final FieldDeviceReadingRepository fieldDeviceReadingRepository;

    public void handleRawVehicleLocationUpdate(RawVehicleLocation update) {
        FieldDevice fieldDevice = FieldDevice.newBuilder()
                .setId(FieldDeviceLinkRepository.getDeterministicDeviceId(
                        String.valueOf(update.getUnitId()),
                        FieldDeviceManufacturer.WYDOT_AVL))
                .setLocationType(MarkedLocationType.MARKED_LOCATION_TYPE_GENERIC)
                .setGeometry(PointGeometry.newBuilder()
                        .setCoordinates(LatLng.newBuilder()
                                .setLatitude(update.getLatitude())
                                .setLongitude(update.getLongitude())))
                .setCoreDetails(FieldDeviceCoreDetails.newBuilder()
                        .setDeviceStatus(FieldDeviceStatus.FIELD_DEVICE_STATUS_OK)
                        .setHasAutomaticLocation(true)
                        .setName("unknown")
                        .setIsMoving(update.getSpeed() != 0)
                        .setMake("WYDOT AVL")
                        .setModel(update.getVehicleGroup())
                        .setSerialNumber(update.getUnitId())
                        .setVelocityKph(update.getSpeed()))
                .setMobileVehicle(MobileVehicle.newBuilder()
                        .setOperationType(VehicleOperationType.VEHICLE_OPERATION_UNKNOWN)
                        .setLicensePlate(update.getTitle())
                        .setHeading(update.getHeading().intValue()))
                .build();
        // TODO: Generate route ID and measure for vehicle
        FieldDeviceReading fieldDeviceReading = FieldDeviceReading.fromDevice(fieldDevice, update.getLocalTime(),
                gisService).block();
        fieldDeviceReadingRepository.insert(fieldDeviceReading);

        // TODO: Check if insert or update, if update don't overwrite ConAdmin fields
        fieldDeviceRepository.update(fieldDevice.getId(),
                new FieldDeviceLink(update.getLocalTime().toEpochMilli(), fieldDevice));
    }

    public VehicleOperationType getOperationType(RawVehicleLocation update) {
        if (update.getPlowUp() != null) {
            if (update.getPlowUp()) {
                return VehicleOperationType.VEHICLE_OPERATION_GENERAL_INACTIVE;
            } else {
                return VehicleOperationType.VEHICLE_OPERATION_PLOWING;
            }
        } else {
            return VehicleOperationType.VEHICLE_OPERATION_UNKNOWN;
        }
    }
}
