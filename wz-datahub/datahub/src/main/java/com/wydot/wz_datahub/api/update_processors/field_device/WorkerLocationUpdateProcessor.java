package com.wydot.wz_datahub.api.update_processors.field_device;

import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.models.field_devices.FieldDeviceReading;
import com.wydot.wz_datahub.api.models.raw_data.RawDataType;
import com.wydot.wz_datahub.api.models.workers.LiveWorkerLocation;
import com.wydot.wz_datahub.api.update_processors.UpdateProcessorProperties;
import com.wydot.wz_datahub.api.update_processors.UpdateProcessorUtils;
import com.wydot.wz_datahub.api.utilities.gis_service.GisService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.FieldDevice;
import wyo.dot.protobuf.FieldDevice.FieldDeviceCoreDetails;
import wyo.dot.protobuf.FieldDevice.FieldDeviceStatus;
import wyo.dot.protobuf.FieldDevice.FieldWorker;
import wyo.dot.protobuf.FieldDevice.FieldWorker.OperationType;
import wyo.dot.protobuf.MarkedLocationType;
import wyo.dot.protobuf.PointGeometry;

@Slf4j
@Component
@RequiredArgsConstructor
public class WorkerLocationUpdateProcessor {

    private final GisService gisService;
    private final FieldDeviceUpdateProcessor fieldDeviceUpdateProcessor;
    private final UpdateProcessorProperties updateProcessorProperties;

    public FieldDeviceReading processWorkerLocationUpdate(LiveWorkerLocation workerLocation) {
        log.debug("Processing worker location update: {}", workerLocation);

        String id = workerLocation.getWorkerId();
        OperationType operation = UpdateProcessorUtils.getWorkerOperationType(workerLocation.getLocationType());
        MarkedLocationType markedLocationType = UpdateProcessorUtils
                .getWorkerMarkedLocationType(workerLocation.getLocationType());
        FieldDeviceStatus deviceStatus = workerLocation.getIsActive() ? FieldDeviceStatus.FIELD_DEVICE_STATUS_OK
                : FieldDeviceStatus.FIELD_DEVICE_STATUS_INACTIVE;
        FieldDevice.Builder builder = FieldDevice.newBuilder()
                .setFieldWorker(FieldWorker.newBuilder().setOperationType(operation))
                .setId(id)
                .setRoadEventId(workerLocation.getRoadEventId())
                .setLocationType(markedLocationType)
                .setGeometry(PointGeometry.newBuilder()
                        .setCoordinates(workerLocation.getLocation()))
                // .setBbox() // TODO
                .setCoreDetails(FieldDeviceCoreDetails.newBuilder()
                        .setDeviceStatus(deviceStatus)
                        .setHasAutomaticLocation(true)
                        .setName("Live Worker: " + workerLocation.getWorkerId())
                        // .setDescription() // TODO
                        // .setStatusMessages() // TODO
                        .setIsMoving(false) // TODO
                        .setMake(RawDataType.WZAM_WORKER.getDeviceMake(null)) // TODO
                        .setModel(operation.name()) // TODO
                        .setSerialNumber(workerLocation.getWorkerId()) // TODO: device identifier instead of user ID?
                        // .setFirmwareVersion() // TODO
                        .setVelocityKph(workerLocation.getVelocityKph()));

        FieldDevice device = builder.build();
        FieldDeviceReading fieldDeviceReading = FieldDeviceReading.fromDevice(device,
                workerLocation.getTimestamp(), gisService).block();

        fieldDeviceUpdateProcessor.handleNewFieldDeviceReading(fieldDeviceReading,
                updateProcessorProperties.isWorkerLocationUpdatesEnabled());
        return fieldDeviceReading;
    }
}
