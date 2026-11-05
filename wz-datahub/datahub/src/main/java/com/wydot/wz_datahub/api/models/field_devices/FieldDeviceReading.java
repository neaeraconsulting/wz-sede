package com.wydot.wz_datahub.api.models.field_devices;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import reactor.core.publisher.Mono;
import wyo.dot.protobuf.FieldDevice;

import java.time.Instant;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.wydot.wz_datahub.api.models.gis_service.RouteAndMeasure;
import com.wydot.wz_datahub.api.models.serialization.instant.InstantFromMillisDeserializer;
import com.wydot.wz_datahub.api.models.serialization.instant.InstantToMillisSerializer;
import com.wydot.wz_datahub.api.utilities.gis_service.GisService;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class FieldDeviceReading {
    @JsonProperty("last_updated")
    @JsonSerialize(using = InstantToMillisSerializer.class)
    @JsonDeserialize(using = InstantFromMillisDeserializer.class)
    private Instant lastUpdated;
    @JsonProperty("route_and_measure")
    private RouteAndMeasure routeAndMeasure;
    @JsonProperty("device")
    private FieldDevice device;

    public static Mono<FieldDeviceReading> fromDevice(FieldDevice device, Instant lastUpdated, GisService gisService) {
        return gisService.getClosestRouteAndMeasureForDevice(device).flatMap((RouteAndMeasure routeAndMeasure) -> {
            return gisService.getRoadName(routeAndMeasure).map((roadName) -> {
                FieldDevice updatedDevice = device.toBuilder()
                        .setCoreDetails(device.getCoreDetails().toBuilder()
                                .setMilepost(routeAndMeasure.getMeasure())
                                .addRoadNames(roadName))
                        .build();
                return new FieldDeviceReading(lastUpdated, routeAndMeasure, updatedDevice).updateStatus();
            });
        }).defaultIfEmpty(new FieldDeviceReading(lastUpdated, null, device).updateStatus());
    }

    public FieldDeviceReading withUpdatedDevice(FieldDevice newDevice) {
        return new FieldDeviceReading(lastUpdated, routeAndMeasure, newDevice).updateStatus();
    }

    private FieldDeviceReading withUpdatedDeviceNoStatusUpdate(FieldDevice newDevice) {
        return new FieldDeviceReading(lastUpdated, routeAndMeasure, newDevice);
    }

    public FieldDeviceReading updateStatus() {
        if (this.device == null) {
            return null;
        } else if (this.lastUpdated.isBefore(Instant.now().minus(java.time.Duration.ofMinutes(15)))) {
            return this.withUpdatedDeviceNoStatusUpdate(this.device.toBuilder().setCoreDetails(
                    this.device.getCoreDetails().toBuilder()
                            .setDeviceStatus(FieldDevice.FieldDeviceStatus.FIELD_DEVICE_STATUS_OFFLINE))
                    .build());
        } else if (this.routeAndMeasure == null) {
            return this.withUpdatedDeviceNoStatusUpdate(this.device.toBuilder().setCoreDetails(
                    this.device.getCoreDetails().toBuilder()
                            .setDeviceStatus(FieldDevice.FieldDeviceStatus.FIELD_DEVICE_STATUS_INACTIVE))
                    .build());
        }
        return this;
    }
}
