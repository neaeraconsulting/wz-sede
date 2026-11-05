package com.wydot.wz_datahub.api.controllers;

import com.wydot.wz_datahub.api.accessors.field_devices.FieldDeviceReadingRepository;
import com.wydot.wz_datahub.api.accessors.data_source.DataSourceSummaryRepository;
import com.wydot.wz_datahub.api.accessors.field_devices.FieldDeviceLinkRepository;
import com.wydot.wz_datahub.api.accessors.recordings.RecordingRepository;
import com.wydot.wz_datahub.api.accessors.reports.ReportRepository;
import com.wydot.wz_datahub.api.accessors.road_event.RoadEventRepository;
import com.wydot.wz_datahub.api.controllers.kafka.RecordingUpdateController;
import com.wydot.wz_datahub.api.controllers.kafka.ReportUpdateController;
import com.wydot.wz_datahub.api.models.SupportRequestBody;
import com.wydot.wz_datahub.api.models.data_sources.DataFeedSourceSummary;
import com.wydot.wz_datahub.api.models.field_devices.FieldDeviceLink;
import com.wydot.wz_datahub.api.models.field_devices.FieldDeviceReading;
import com.wydot.wz_datahub.api.models.mobile_vehicle.MobileVehicleLocation;
import com.wydot.wz_datahub.api.models.recordings.Recording;
import com.wydot.wz_datahub.api.models.recordings.RecordingWithId;
import com.wydot.wz_datahub.api.models.reports.Report;
import com.wydot.wz_datahub.api.models.reports.ReportPatch;
import com.wydot.wz_datahub.api.models.reports.ReportWithId;
import com.wydot.wz_datahub.api.models.reports.WorkerPresenceReport;
import com.wydot.wz_datahub.api.models.workers.LiveWorkerLocation;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventStatus;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventUpdateStatus;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventWrapper;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventUpdateStatus.EventStatus;
import com.wydot.wz_datahub.api.notifications.SlackNotificationApi;
import com.wydot.wz_datahub.api.update_processors.field_device.VehicleLocationUpdateProcessor;
import com.wydot.wz_datahub.api.update_processors.field_device.WorkerLocationUpdateProcessor;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import reactor.core.publisher.Mono;

@Slf4j
@RestController
@RequestMapping("/wzam")
@RequiredArgsConstructor
public class WzamController {
    private final ReportRepository reportRepository;
    private final RecordingRepository recordingRepository;
    private final RoadEventRepository roadEventRepository;
    private final FieldDeviceLinkRepository fieldDeviceLinkRepository;
    private final FieldDeviceReadingRepository fieldDeviceReadingRepository;
    private final ReportUpdateController reportUpdateController;
    private final RecordingUpdateController recordingUpdateController;
    private final WorkerLocationUpdateProcessor workerLocationUpdateProcessor;
    private final VehicleLocationUpdateProcessor vehicleLocationUpdateProcessor;
    private final DataSourceSummaryRepository dataSourceSummaryRepository;
    private final SlackNotificationApi slackNotificationApi;

    @PreAuthorize("hasRole('ROLE_ADMIN') || hasRole('ROLE_USER')")
    @GetMapping("/reports")
    public Mono<Page<ReportWithId>> getReports(
            @RequestParam(required = false) Long id,
            @RequestParam(name = "user_id", required = false) String userId,
            @RequestParam(name = "generated_start_time_millis", required = false) Long generatedStartTime,
            @RequestParam(name = "generated_end_time_millis", required = false) Long generatedEndTime,
            @RequestParam(name = "active_start_time_millis", required = false) Long activeStartTime,
            @RequestParam(name = "active_end_time_millis", required = false) Long activeEndTime,
            @RequestParam(required = false, defaultValue = "0") int page,
            @RequestParam(required = false, defaultValue = "100") int size) {
        return Mono.just(reportRepository.find(id, userId, generatedStartTime, generatedEndTime,
                activeStartTime, activeEndTime, PageRequest.of(page, size)));
    }

    @PreAuthorize("hasRole('ROLE_ADMIN') || hasRole('ROLE_USER')")
    @PostMapping("/reports")
    public Mono<ReportWithId> createReport(
            @RequestBody Report report) {
        dataSourceSummaryRepository.update(DataFeedSourceSummary.Wzam());
        return Mono.fromCallable(() -> {
            Long uniqueId = reportRepository.generateUniqueId();
            ReportWithId reportWithId = new ReportWithId(uniqueId, report);
            reportRepository.update(uniqueId, reportWithId, true); // Save the report to MongoDB

            slackNotificationApi.sendReportNotification(report);
            try {
                Long roadEventId = reportUpdateController.createNewRoadEvent(reportWithId);
                reportWithId.setRoadEventId(roadEventId); // Set the road event ID in the report
            } catch (Exception e) {
                slackNotificationApi.sendErrorNotification(
                        "New Report " + uniqueId + " threw an exception: " + e.getMessage());
                log.error("Error handling report create: {}", e.getMessage(), e);
            }
            return reportWithId; // Return the report with the unique ID
        });
    }

    @PreAuthorize("hasRole('ROLE_ADMIN') || hasRole('ROLE_USER')")
    @PostMapping("/reports-update")
    @Deprecated(since = "2026-03", forRemoval = true)
    public Mono<Void> updateReport(
            @RequestBody ReportWithId report) {
        dataSourceSummaryRepository.update(DataFeedSourceSummary.Wzam());
        reportRepository.update(report.getId(), report, true);
        try {
            reportUpdateController.updateRoadEvent(ReportPatch.fromReportWithId(report));
        } catch (Exception e) {
            slackNotificationApi.sendErrorNotification(
                    "Updated Report " + report.getId() + " threw an exception: " + e.getMessage());
            log.error("Error handling report update: {}", e.getMessage(), e);
        }
        return Mono.empty();
    }

    @PreAuthorize("hasRole('ROLE_ADMIN') || hasRole('ROLE_USER')")
    @PatchMapping("/reports")
    public Mono<Void> patchReport(
            @Valid @RequestBody ReportPatch report) {
        dataSourceSummaryRepository.update(DataFeedSourceSummary.Wzam());
        reportRepository.update(report.getId(), report.toReportWithId(), true);
        try {
            reportUpdateController.updateRoadEvent(report);
        } catch (Exception e) {
            slackNotificationApi.sendErrorNotification(
                    "Patched Report " + report.getId() + " threw an exception: " + e.getMessage());
            log.error("Error handling report update: {}", e.getMessage(), e);
        }
        return Mono.empty();
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @DeleteMapping("/reports")
    public Mono<Long> deleteReport(
            @RequestParam(required = true) Long id) {
        dataSourceSummaryRepository.update(DataFeedSourceSummary.Wzam());
        return Mono.fromCallable(() -> reportRepository.delete(id))
                .flatMap(count -> {
                    if (count > 0) {
                        return Mono.empty(); // Successfully deleted
                    } else {
                        return Mono.error(new ResponseStatusException(HttpStatus.NOT_FOUND, "Recording not found"));
                    }
                });
    }

    @PreAuthorize("hasRole('ROLE_ADMIN') || hasRole('ROLE_USER')")
    @PostMapping("/reports/live_position")
    public Mono<LiveWorkerLocation> updateLiveReport(
            @RequestBody LiveWorkerLocation workerLocation) {
        workerLocationUpdateProcessor.processWorkerLocationUpdate(workerLocation);
        return Mono.empty();
    }

    @PreAuthorize("hasRole('ROLE_ADMIN') || hasRole('ROLE_USER')")
    @PostMapping("/reports/mobile-vehicle")
    public Mono<LiveWorkerLocation> updateMobileVehicleReport(
            @RequestBody MobileVehicleLocation vehicleLocation) {
        vehicleLocationUpdateProcessor.processVehicleLocationUpdate(vehicleLocation);
        return Mono.empty();
    }

    // @PreAuthorize("hasRole('ROLE_ADMIN') || hasRole('ROLE_USER')")
    // @DeleteMapping("/report")
    // public Mono<Void> deleteReport(
    // @RequestParam() Integer id) {
    // return Mono.empty();
    // }

    @PreAuthorize("hasRole('ROLE_ADMIN') || hasRole('ROLE_USER')")
    @GetMapping("/recordings")
    public Mono<Page<RecordingWithId>> getRecordings(
            @RequestParam(required = false) Long id,
            @RequestParam(name = "user_id", required = false) String userId,
            @RequestParam(name = "generated_start_time_millis", required = false) Long generatedStartTime,
            @RequestParam(name = "generated_end_time_millis", required = false) Long generatedEndTime,
            @RequestParam(name = "active_start_time_millis", required = false) Long activeStartTime,
            @RequestParam(name = "active_end_time_millis", required = false) Long activeEndTime,
            @RequestParam(required = false, defaultValue = "0") int page,
            @RequestParam(required = false, defaultValue = "100") int size) {
        return Mono.just(recordingRepository.find(id, userId, generatedStartTime, generatedEndTime,
                activeStartTime, activeEndTime, PageRequest.of(page, size)));
    }

    @PreAuthorize("hasRole('ROLE_ADMIN') || hasRole('ROLE_USER')")
    @PostMapping("/recordings")
    public Mono<RecordingWithId> createRecording(
            @RequestBody Recording recording) {
        dataSourceSummaryRepository.update(DataFeedSourceSummary.Wzam());
        return Mono.fromCallable(() -> {
            Long uniqueId = recordingRepository.generateUniqueId();
            RecordingWithId recordingWithId = new RecordingWithId(uniqueId, recording);
            recordingRepository.update(uniqueId, recordingWithId, true); // Save the recording to MongoDB

            slackNotificationApi.sendRecordingNotification(recording);
            try {
                Long roadEventId = recordingUpdateController.updateRoadEvent(recordingWithId);
                recordingWithId.setRoadEventId(roadEventId); // Set the road event ID in the recording
            } catch (Exception e) {
                slackNotificationApi.sendErrorNotification(
                        "New Recording " + uniqueId + " threw an exception: " + e.getMessage());
                log.error("Error handling recording update: {}", e.getMessage(), e);
            }
            return recordingWithId; // Return the recording with the unique ID
        });
    }

    @PreAuthorize("hasRole('ROLE_ADMIN') || hasRole('ROLE_USER')")
    @PutMapping("/recordings")
    public Mono<Void> updateRecording(
            @RequestBody RecordingWithId recording) {
        dataSourceSummaryRepository.update(DataFeedSourceSummary.Wzam());
        recordingRepository.update(recording.getId(), recording, true);
        try {
            try {
                recordingUpdateController.updateRoadEvent(recording);
            } catch (Exception e) {
                slackNotificationApi.sendErrorNotification(
                        "Updated Recording " + recording.getId() + " threw an exception: " + e.getMessage());
                log.error("Error handling recording update: {}", e.getMessage(), e);
            }
        } catch (Exception e) {
            log.error("Error handling recording update: {}", e.getMessage(), e);
        }
        return Mono.empty();
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @DeleteMapping("/recordings")
    public Mono<Void> deleteRecording(
            @RequestParam(required = true) Long id) {
        dataSourceSummaryRepository.update(DataFeedSourceSummary.Wzam());
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
    @PostMapping("/worker-presence-reports")
    public Mono<Void> createWorkerPresenceReport(
            @RequestBody WorkerPresenceReport report) {
        dataSourceSummaryRepository.update(DataFeedSourceSummary.Wzam());
        Long uniqueId = recordingRepository.generateUniqueId();
        report.setId(uniqueId);

        slackNotificationApi.sendWorkerPresenceReportNotification(report);

        try {
            Long response = reportUpdateController.updateRoadEventWorkerPresence(report);
            if (response == null) {
                slackNotificationApi.sendErrorNotification(
                        "Worker Presence Report " + report.getId() + " failed to update RoadEvent");
            }
        } catch (Exception e) {
            slackNotificationApi.sendErrorNotification(
                    "Worker Presence Report " + report.getId() + " threw an exception: " + e.getMessage());
            log.error("Error handling worker presence report update: {}", e.getMessage(), e);
            return null;
        }
        return Mono.empty();
    }

    @PreAuthorize("hasRole('ROLE_ADMIN') || hasRole('ROLE_USER')")
    @GetMapping("/road_events")
    public Mono<Page<RoadEventWrapper>> getRoadEvents(
            @RequestParam(required = false) Long id,
            @RequestParam(name = "user_id", required = false) String userId,
            @RequestParam(name = "generated_start_time_millis", required = false) Long generatedStartTime,
            @RequestParam(name = "generated_end_time_millis", required = false) Long generatedEndTime,
            @RequestParam(name = "event_start_time_min_millis", required = false) Long eventStartTimeMin,
            @RequestParam(name = "event_start_time_max_millis", required = false) Long eventStartTimeMax,
            @RequestParam(name = "event_end_time_min_millis", required = false) Long eventEndTimeMin,
            @RequestParam(name = "event_end_time_max_millis", required = false) Long eventEndTimeMax,
            @RequestParam(required = false, defaultValue = "0") int page,
            @RequestParam(required = false, defaultValue = "100") int size) {
        return Mono.just(roadEventRepository.find(id, userId, generatedStartTime, generatedEndTime,
                eventStartTimeMin, eventStartTimeMax, eventEndTimeMin, eventEndTimeMax, PageRequest.of(page, size)));
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

    @PreAuthorize("hasRole('ROLE_ADMIN') || hasRole('ROLE_USER')")
    @GetMapping("/field_device_readings")
    public Mono<Page<FieldDeviceReading>> getFieldDeviceReadings(
            @RequestParam(name = "device_id", required = false) String deviceId,
            @RequestParam(name = "updated_start_time_millis", required = false) Long updatedStartTime,
            @RequestParam(name = "updated_end_time_millis", required = false) Long updatedEndTime,
            // @RequestParam(name = "latest", required = false) Boolean updatedEndTime,
            @RequestParam(name = "include_avl", required = false) Boolean includeAvl,
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

    @PostMapping("/support-request")
    public Mono<Void> submitSupportRequest(
            @RequestBody SupportRequestBody supportRequest) {
        slackNotificationApi.sendSupportRequestNotification(supportRequest);
        return Mono.empty();
    }

    @PreAuthorize("hasRole('ROLE_ADMIN') || hasRole('ROLE_USER')")
    @GetMapping("/road_event_status")
    public Mono<Page<RoadEventStatus>> getFieldDeviceStatusList(
            @RequestParam(name = "user_id", required = true) String userId,
            @RequestParam(required = false, defaultValue = "0") int page,
            @RequestParam(required = false, defaultValue = "100") int size) {
        PageRequest pageable = PageRequest.of(0, 1000);
        // Filter through reports, recordings, and mobile reports to find all road
        // events associated with this user

        Page<ReportWithId> allReports = reportRepository.find(null, userId, null, null, null, null,
                PageRequest.of(0, 1000));
        Page<RecordingWithId> allRecordings = recordingRepository.find(null, userId, null, null, null, null,
                PageRequest.of(0, 1000));
        // String deviceId = UpdateProcessorUtils.generateDeterministicUuid(userId,
        // "VEHICLE_LOCATION");
        // FieldDeviceReading fieldDeviceReading =
        // fieldDeviceReadingRepository.findLatest(deviceId, null, null);

        Map<Long, List<ReportWithId>> reportRoadEventIds = allReports.getContent().stream()
                .filter(report -> report != null && report.getRoadEventId() != null)
                .collect(Collectors.groupingBy(ReportWithId::getRoadEventId));
        Map<Long, List<RecordingWithId>> recordingRoadEventIds = allRecordings.getContent().stream()
                .filter(recording -> recording != null && recording.getRoadEventId() != null)
                .collect(Collectors.groupingBy(RecordingWithId::getRoadEventId));

        Map<Long, RoadEventWrapper> reportRoadEvents = reportRoadEventIds.keySet().stream()
                .map(key -> {
                    RoadEventWrapper event = roadEventRepository.findOne(key, null, null, null, null, null, null, null);
                    if (event == null) {
                        return null;
                    }
                    return Map.entry(key, event);
                })
                .filter(entry -> entry != null && entry.getValue() != null)
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));
        Map<Long, RoadEventWrapper> recordingRoadEvents = recordingRoadEventIds.keySet().stream()
                .map(key -> {
                    RoadEventWrapper event = roadEventRepository.findOne(key, null, null, null, null, null, null, null);
                    if (event == null) {
                        return null;
                    }
                    return Map.entry(key, event);
                })
                .filter(entry -> entry != null && entry.getValue() != null)
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));

        Map<Long, RoadEventStatus> roadEventStatuses = new HashMap<>();
        reportRoadEventIds.entrySet().forEach((entry) -> {
            Long id = entry.getKey();
            List<ReportWithId> reports = entry.getValue();
            if (reportRoadEvents.containsKey(id)) {
                RoadEventWrapper event = reportRoadEvents.get(id);
                List<RoadEventUpdateStatus> updateStatuses = new ArrayList<>();
                reports.forEach(report -> {
                    RoadEventUpdateStatus updateStatus = new RoadEventUpdateStatus();
                    updateStatus.setSourceType(RoadEventUpdateStatus.SourceType.REPORT);
                    updateStatus.setApprovalStatus(RoadEventUpdateStatus.ApprovalStatus.PENDING);
                    updateStatus.setEventStatus(event.getStatus());
                    updateStatus.setUpdateSubmittedTimestamp(report.getTimestamp());
                    updateStatus.setSource(report);
                    updateStatuses.add(updateStatus);
                });
                if (roadEventStatuses.containsKey(id)) {
                    roadEventStatuses.get(id).getUpdates().addAll(updateStatuses);
                } else {
                    roadEventStatuses.put(id, new RoadEventStatus(event, updateStatuses));
                }
            } else {
                List<RoadEventUpdateStatus> updateStatuses = new ArrayList<>();
                reports.forEach(report -> {
                    RoadEventUpdateStatus updateStatus = new RoadEventUpdateStatus();
                    updateStatus.setSourceType(RoadEventUpdateStatus.SourceType.REPORT);
                    updateStatus.setApprovalStatus(RoadEventUpdateStatus.ApprovalStatus.PENDING);
                    updateStatus.setEventStatus(EventStatus.NOT_CREATED);
                    updateStatus.setUpdateSubmittedTimestamp(report.getTimestamp());
                    updateStatus.setSource(report);
                    updateStatuses.add(updateStatus);
                });

                roadEventStatuses.put(id,
                        new RoadEventStatus(null, updateStatuses));
            }
        });
        recordingRoadEventIds.entrySet().forEach((entry) -> {
            Long id = entry.getKey();
            List<RecordingWithId> recordings = entry.getValue();
            if (recordingRoadEvents.containsKey(id)) {
                RoadEventWrapper event = recordingRoadEvents.get(id);
                List<RoadEventUpdateStatus> updateStatuses = new ArrayList<>();
                recordings.forEach(recording -> {
                    RoadEventUpdateStatus updateStatus = new RoadEventUpdateStatus();
                    updateStatus.setSourceType(RoadEventUpdateStatus.SourceType.RECORDING);
                    updateStatus.setApprovalStatus(RoadEventUpdateStatus.ApprovalStatus.PENDING);
                    updateStatus.setEventStatus(event.getStatus());
                    updateStatus.setUpdateSubmittedTimestamp(recording.getTimestamp());
                    updateStatus.setSource(recording);
                    updateStatuses.add(updateStatus);
                });
                if (roadEventStatuses.containsKey(id)) {
                    roadEventStatuses.get(id).getUpdates().addAll(updateStatuses);
                } else {
                    roadEventStatuses.put(id, new RoadEventStatus(event, updateStatuses));
                }
            } else {
                List<RoadEventUpdateStatus> updateStatuses = new ArrayList<>();
                recordings.forEach(recording -> {
                    RoadEventUpdateStatus updateStatus = new RoadEventUpdateStatus();
                    updateStatus.setSourceType(RoadEventUpdateStatus.SourceType.RECORDING);
                    updateStatus.setApprovalStatus(RoadEventUpdateStatus.ApprovalStatus.PENDING);
                    updateStatus.setEventStatus(EventStatus.NOT_CREATED);
                    updateStatus.setUpdateSubmittedTimestamp(recording.getTimestamp());
                    updateStatus.setSource(recording);
                    updateStatuses.add(updateStatus);
                });

                roadEventStatuses.put(id,
                        new RoadEventStatus(null, updateStatuses));
            }
        });
        return Mono
                .just(new PageImpl<>(new ArrayList<>(roadEventStatuses.values()), pageable, roadEventStatuses.size()));
    }
}
