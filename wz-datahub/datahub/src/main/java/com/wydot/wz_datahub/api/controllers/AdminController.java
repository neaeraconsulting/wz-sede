package com.wydot.wz_datahub.api.controllers;

import com.google.protobuf.InvalidProtocolBufferException;
import com.google.protobuf.util.JsonFormat;
import com.google.type.LatLng;
import com.wydot.wz_datahub.api.accessors.field_devices.FieldDeviceReadingRepository;
import com.wydot.wz_datahub.api.accessors.field_devices.FieldDeviceLinkRepository;
import com.wydot.wz_datahub.api.accessors.recordings.RecordingRepository;
import com.wydot.wz_datahub.api.accessors.reports.ReportRepository;
import com.wydot.wz_datahub.api.controllers.kafka.RoadEventApprovalController;
import com.wydot.wz_datahub.api.models.field_devices.FieldDeviceLink;
import com.wydot.wz_datahub.api.models.field_devices.FieldDeviceReading;
import com.wydot.wz_datahub.api.models.gis_service.responses.geometry_to_measure.GeometryToMeasureResponse;
import com.wydot.wz_datahub.api.models.gis_service.responses.measure_to_geometry.MeasureToGeometryResponse;
import com.wydot.wz_datahub.api.models.gis_service.responses.query_attribute_set.QueryAttributeSetResponse;
import com.wydot.wz_datahub.api.models.gis_service.responses.translate.TranslateResponse;
import com.wydot.wz_datahub.api.models.wz.device_feed.DeviceFeed;
import com.wydot.wz_datahub.api.retrievers.icone.IconeFetcher;
import com.wydot.wz_datahub.api.retrievers.ver_mac.VerMacDeviceFeedFetcher;
import com.wydot.wz_datahub.api.retrievers.wanco.WancoDeviceFeedFetcher;
import com.wydot.wz_datahub.api.utilities.gis_service.GisApiWyoming;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import reactor.core.publisher.Mono;
import wyo.dot.protobuf.conadmin.ConAdminRoadEventApproval;

@Slf4j
@RestController
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {
    private final ReportRepository reportRepository;
    private final RecordingRepository recordingRepository;
    private final FieldDeviceLinkRepository fieldDeviceLinkRepository;
    private final FieldDeviceReadingRepository fieldDeviceReadingRepository;
    private final VerMacDeviceFeedFetcher verMacDeviceFeedFetcher;
    private final WancoDeviceFeedFetcher wancoDeviceFeedFetcher;
    private final IconeFetcher iconeDeviceFeedFetcher;
    private final RoadEventApprovalController roadEventApprovalController;
    private final GisApiWyoming gisApi;

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @DeleteMapping("/reports")
    public Mono<Long> deleteReport(
            @RequestParam(required = true) Long id) {
        return Mono.fromCallable(() -> reportRepository.delete(id))
                .flatMap(count -> {
                    if (count > 0) {
                        return Mono.empty(); // Successfully deleted
                    } else {
                        return Mono.error(new ResponseStatusException(HttpStatus.NOT_FOUND, "Recording not found"));
                    }
                });
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @DeleteMapping("/recordings")
    public Mono<Void> deleteRecording(
            @RequestParam(required = true) Long id) {
        return Mono.fromCallable(() -> recordingRepository.delete(id))
                .flatMap(count -> {
                    if (count > 0) {
                        return Mono.empty(); // Successfully deleted
                    } else {
                        return Mono.error(new ResponseStatusException(HttpStatus.NOT_FOUND, "Recording not found"));
                    }
                });
    }

    @PreAuthorize("hasRole('ROLE_ADMIN') || hasRole('ROLE_USER')")
    @DeleteMapping("/projects")
    public Mono<Void> deleteProject(
            @RequestParam() Integer id) {
        // TODO: implement
        throw new ResponseStatusException(HttpStatus.NOT_IMPLEMENTED, "Delete project not implemented");
    }

    @PreAuthorize("hasRole('ROLE_ADMIN') || hasRole('ROLE_USER')")
    @DeleteMapping("/road_events")
    public Mono<Void> deleteRoadEvents(
            @RequestParam() Integer id) {
        // TODO: implement
        throw new ResponseStatusException(HttpStatus.NOT_IMPLEMENTED, "Delete road event not implemented");
    }

    @PreAuthorize("hasRole('ROLE_ADMIN') || hasRole('ROLE_USER')")
    @GetMapping("/field_device_links")
    public Mono<Page<FieldDeviceLink>> getFieldDeviceLinks(
            @RequestParam(name = "device_id", required = false) String deviceId,
            @RequestParam(name = "project_id", required = false) Long projectId,
            @RequestParam(name = "road_event_id", required = false) Long roadEventId,
            @RequestParam(name = "updated_start_time_millis", required = false) Long updatedStartTime,
            @RequestParam(name = "updated_end_time_millis", required = false) Long updatedEndTime,
            @RequestParam(name = "include_avl", required = false) Boolean includeAvl,
            @RequestParam(required = false, defaultValue = "0") int page,
            @RequestParam(required = false, defaultValue = "100") int size) {
        if (includeAvl != null && includeAvl) {
            return Mono.just(fieldDeviceLinkRepository.find(deviceId, projectId, roadEventId,
                    updatedStartTime, updatedEndTime, PageRequest.of(page, size)));
        }
        return Mono.just(fieldDeviceLinkRepository.findNonAvl(deviceId, projectId, roadEventId,
                updatedStartTime, updatedEndTime, PageRequest.of(page, size)));
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @PostMapping("/field_device_links")
    public Mono<FieldDeviceLink> createFieldDeviceLink(
            @RequestBody FieldDeviceLink deviceLink) {
        return Mono.fromCallable(() -> {
            fieldDeviceLinkRepository.update(deviceLink.getDeviceId(), deviceLink); // Save the report to MongoDB
            return deviceLink; // Return the report with the unique ID
        });
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @PutMapping("/field_device_links")
    public Mono<Void> updateFieldDeviceLink(
            @RequestBody FieldDeviceLink deviceLink) {
        fieldDeviceLinkRepository.update(deviceLink.getDeviceId(), deviceLink);
        return Mono.empty();
    }

    @PreAuthorize("hasRole('ROLE_ADMIN') || hasRole('ROLE_USER')")
    @DeleteMapping("/field_device_links")
    public Mono<Void> deleteFieldDeviceLinks(
            @RequestParam() Integer id) {
        // TODO: implement
        throw new ResponseStatusException(HttpStatus.NOT_IMPLEMENTED, "Delete field device link not implemented");
    }

    @PreAuthorize("hasRole('ROLE_ADMIN') || hasRole('ROLE_USER')")
    @GetMapping("/field_device_readings")
    public Mono<Page<FieldDeviceReading>> getFieldDeviceReadings(
            @RequestParam(name = "device_id", required = false) String deviceId,
            @RequestParam(name = "updated_start_time_millis", required = false) Long updatedStartTime,
            @RequestParam(name = "updated_end_time_millis", required = false) Long updatedEndTime,
            @RequestParam(name = "include_avl", required = false) Boolean includeAvl,
            // @RequestParam(name = "latest", required = false) Boolean updatedEndTime,
            @RequestParam(required = false, defaultValue = "0") int page,
            @RequestParam(required = false, defaultValue = "100") int size) {
        if (deviceId != null && !deviceId.isEmpty()) {
            return Mono.just(fieldDeviceReadingRepository.find(deviceId, updatedStartTime, updatedEndTime,
                    PageRequest.of(page, size)));
        } else {
            List<FieldDeviceReading> entries;
            if (Boolean.TRUE.equals(includeAvl)) {
                entries = fieldDeviceReadingRepository.findUnique(updatedStartTime, updatedEndTime);
            } else {
                entries = fieldDeviceReadingRepository.findUniqueNonAvl(updatedStartTime, updatedEndTime);
            }
            return Mono.just(new PageImpl<>(entries, PageRequest.of(0, size), entries.size()));
        }
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @PostMapping("/field_device_readings")
    public Mono<FieldDeviceReading> createFieldDeviceReading(
            @RequestBody FieldDeviceReading deviceReading) {
        return Mono.fromCallable(() -> {
            fieldDeviceReadingRepository.insert(deviceReading); // Save the report to MongoDB
            return deviceReading; // Return the report with the unique ID
        });
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @GetMapping("/field_devices/ver-mac")
    public Mono<Void> fetchFieldDeviceFeedVerMac() {
        verMacDeviceFeedFetcher.fetchDeviceFeeds();
        return Mono.empty();
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @PostMapping("/field_devices/ver-mac")
    public Mono<List<FieldDeviceReading>> createFieldDeviceVerMac(
            @RequestBody DeviceFeed deviceFeed) {
        List<FieldDeviceReading> readings = verMacDeviceFeedFetcher.handleFieldDeviceFeedUpdate(deviceFeed);
        return Mono.just(readings);
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @PostMapping("/field_devices/icone")
    public Mono<List<FieldDeviceReading>> createFieldDeviceIcone(
            @RequestBody DeviceFeed deviceFeed) {
        List<FieldDeviceReading> readings = iconeDeviceFeedFetcher.handleFieldDeviceFeedUpdate(deviceFeed);
        return Mono.just(readings);
    }

    @PreAuthorize("hasRole('ROLE_ADMIN') || hasRole('ROLE_USER')")
    @DeleteMapping("/field_device_readings")
    public Mono<Void> deleteFieldDeviceReadings(
            @RequestParam() Integer id) {
        // TODO: implement
        throw new ResponseStatusException(HttpStatus.NOT_IMPLEMENTED, "Delete field device reading not implemented");
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @PostMapping("/road-event-approval")
    public Mono<Void> submitApproval(
            @RequestBody String approvalJson) throws InvalidProtocolBufferException {
        ConAdminRoadEventApproval.Builder builder = ConAdminRoadEventApproval.newBuilder();
        JsonFormat.parser().ignoringUnknownFields().merge(approvalJson, builder);
        ConAdminRoadEventApproval approval = builder.build();
        // TODO: implement
        roadEventApprovalController.handleRoadEventApproval(approval);
        return Mono.just(null);
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @GetMapping("/gis/geometryToMeasure")
    public Mono<GeometryToMeasureResponse> geometryToMeasure(
            @RequestParam double latitude,
            @RequestParam double longitude,
            @RequestParam(required = false, defaultValue = "1000") int tolerance) {
        LatLng latLng = LatLng.newBuilder().setLatitude(latitude).setLongitude(longitude).build();
        return gisApi.geometryToMeasure(latLng, tolerance);
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @GetMapping("/gis/queryAttributeSet")
    public Mono<QueryAttributeSetResponse> queryAttributeSet(
            @RequestParam String routeId,
            @RequestParam double fromMeasure,
            @RequestParam double toMeasure) {
        return gisApi.queryAttributeSet(routeId, fromMeasure, toMeasure);
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @GetMapping("/gis/translate")
    public Mono<TranslateResponse> translate(
            @RequestParam String routeId,
            @RequestParam double measure) {
        return gisApi.translate(routeId, measure);
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @GetMapping("/gis/measureToGeometry")
    public Mono<MeasureToGeometryResponse> measureToGeometry(
            @RequestParam String routeId,
            @RequestParam double measure) {
        return gisApi.measureToGeometry(routeId, measure);
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @GetMapping("/gis/measureToGeometryRange")
    public Mono<MeasureToGeometryResponse> measureToGeometryRange(
            @RequestParam String routeId,
            @RequestParam double fromMeasure,
            @RequestParam double toMeasure) {
        return gisApi.measureToGeometryRange(routeId, fromMeasure, toMeasure);
    }
}
