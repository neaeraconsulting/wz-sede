package com.wydot.wz_datahub.api.update_processors;

import java.time.DayOfWeek;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.ZoneId;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.ProtobufUtils;
import com.wydot.wz_datahub.api.accessors.road_event.RoadEventRepository;
import com.wydot.wz_datahub.api.kafka.KafkaTopics;
import com.wydot.wz_datahub.api.models.audit.AuditLogSeverity;
import com.wydot.wz_datahub.api.models.update_processing.Observation;
import com.wydot.wz_datahub.api.models.update_processing.ObservationSource;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventAudit;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventWrapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.DataHubRoadEventUpdate;
import wyo.dot.protobuf.EventRecurrence;
import wyo.dot.protobuf.UpdateRoadEvent;

@Slf4j
@Component
@RequiredArgsConstructor
public class ObservationReevaluationScheduler {

    private static final ZoneId WYOMING_TIME_ZONE = ZoneId.of("America/Denver");

    private final RoadEventRepository roadEventRepository;
    private final ObservationUpdateProcessor observationUpdateProcessor;
    private final UpdateProcessorProperties updateProcessorProperties;
    private final AuditBus auditBus;
    private final KafkaTemplate<String, DataHubRoadEventUpdate> template;

    @Scheduled(fixedDelayString = "${update-processing.observation-reeval-period:5m}")
    public void reevaluateRoadEventsWithExpiredObservations() {
        Instant now = Instant.now();
        Instant windowStart = now.minus(updateProcessorProperties.getObservationReevalPeriod());

        List<RoadEventWrapper> expiredCandidates = roadEventRepository.findRoadEventIdsWithExpiredObservations(now);
        List<RoadEventWrapper> recentCandidates = roadEventRepository
                .findRoadEventsWithRecentlyActiveObservations(windowStart, now);

        Map<Long, RoadEventWrapper> candidateMap = new LinkedHashMap<>();
        for (RoadEventWrapper wrapper : expiredCandidates) {
            if (wrapper == null || wrapper.getRoadEvent() == null) {
                continue;
            }
            candidateMap.put(wrapper.getRoadEvent().getId(), wrapper);
        }
        for (RoadEventWrapper wrapper : recentCandidates) {
            if (wrapper == null || wrapper.getRoadEvent() == null) {
                continue;
            }
            candidateMap.put(wrapper.getRoadEvent().getId(), wrapper);
        }

        List<RoadEventWrapper> roadEventWrappers = candidateMap.values().stream().toList();

        if (roadEventWrappers.isEmpty()) {
            log.debug("Observation reevaluation: no road events with expired/recent-active observations.");
            return;
        }

        int scanned = 0;
        int changed = 0;
        int skipped = 0;
        int failed = 0;

        for (RoadEventWrapper roadEventWrapper : roadEventWrappers) {
            scanned += 1;
            RoadEventWrapper existing = roadEventWrapper;
            Long roadEventId = existing.getRoadEvent().getId();
            try {
                if (!shouldReevaluate(existing, windowStart, now)) {
                    skipped += 1;
                    continue;
                }

                auditBus.startSession(roadEventId, existing);
                auditBus.record(roadEventId,
                        "Reevaluating road event due to expired/recent-active observations",
                        AuditLogSeverity.INFO);

                RoadEventWrapper updated = observationUpdateProcessor
                        .newRoadEventFromObservations(roadEventId, existing.getObservations());

                if (updated == null) {
                    skipped += 1;
                    auditBus.terminateSession(roadEventId,
                            "Reevaluation produced null RoadEventWrapper");
                    continue;
                }

                if (UpdateProcessorUtils.compareRoadEventWrappers(updated, existing, updateProcessorProperties)) {
                    skipped += 1;
                    auditBus.terminateSession(roadEventId,
                            "No changes detected during scheduled observation reevaluation");
                    continue;
                }

                roadEventRepository.update(roadEventId, updated);

                DataHubRoadEventUpdate updateMessage = createUpdateMessage(updated);
                template.send(
                        KafkaTopics.DATAHUB_ROAD_EVENT,
                        String.valueOf(updateMessage.getRequestId()),
                        updateMessage);

                RoadEventAudit audit = UpdateProcessorUtils.auditFromWrapper(updated, existing, updateMessage);
                auditBus.submitAudit(roadEventId, audit);
                changed += 1;
            } catch (Exception ex) {
                failed += 1;
                log.error("Observation reevaluation failed for roadEventId={}", roadEventId, ex);
                auditBus.terminateSession(roadEventId,
                        "Scheduled observation reevaluation failed: " + ex.getMessage());
            }
        }

        log.info(
                "Observation reevaluation completed. expiredCandidates={}, recentCandidates={}, uniqueCandidates={}, scanned={}, changed={}, skipped={}, failed={}",
                expiredCandidates.size(),
                recentCandidates.size(),
                roadEventWrappers.size(),
                scanned,
                changed,
                skipped,
                failed);
    }

    private DataHubRoadEventUpdate createUpdateMessage(RoadEventWrapper wrapper) {
        Long requestId = ProtobufUtils.generateRequestId("observation-reeval-" + wrapper.getRoadEvent().getId());
        UpdateRoadEvent updateRoadEvent = UpdateRoadEvent.newBuilder()
                .setRoadEvent(wrapper.getRoadEvent())
                .addAllRoadSubEvents(wrapper.getUnwrappedRoadSubEvents())
                .build();

        return DataHubRoadEventUpdate.newBuilder()
                .setRequestId(requestId)
                .setTimestamp(ProtobufUtils.timestampFromInstant(Instant.now()))
                .setUpdated(updateRoadEvent)
                .build();
    }

    private boolean shouldReevaluate(RoadEventWrapper wrapper, Instant windowStart, Instant now) {
        List<Observation<?>> observations = wrapper.getObservations();
        if (observations == null || observations.isEmpty()) {
            return false;
        }

        // Do not need to consider schedule, because schedule is handled client side
        return observations.stream().anyMatch(obs -> isExpired(obs, now)
                || isRecentlyActivated(obs, windowStart, now));
    }

    private boolean isExpired(Observation<?> obs, Instant now) {
        return obs != null && obs.getValidTo() != null && obs.getValidTo().isBefore(now);
    }

    private boolean isRecentlyActivated(Observation<?> obs, Instant windowStart, Instant now) {
        if (obs == null || obs.getValidFrom() == null) {
            return false;
        }
        Instant validFrom = obs.getValidFrom();
        return !validFrom.isBefore(windowStart) && !validFrom.isAfter(now);
    }

    public static boolean isScheduleObservation(Observation<?> obs) {
        if (obs == null || obs.getSource() == null) {
            return false;
        }

        return obs.getSource() == ObservationSource.WZAM_REPORT_SCHEDULE
                || obs.getSource() == ObservationSource.WZAM_RECORDING_SCHEDULE
                || obs.getSource() == ObservationSource.CON_ADMIN_SCHEDULE;
    }

    public static boolean isScheduleActiveAt(Observation<?> obs, EventRecurrence recurrence, Instant instant) {
        Instant validFrom = obs.getValidFrom();
        if (validFrom != null && instant.isBefore(validFrom)) {
            return false;
        }

        Instant validTo = obs.getValidTo();
        if (validTo != null && !instant.isBefore(validTo)) {
            return false;
        }

        LocalDate localDate = instant.atZone(WYOMING_TIME_ZONE).toLocalDate();
        LocalTime localTime = instant.atZone(WYOMING_TIME_ZONE).toLocalTime();

        if (recurrence.hasStartDate()) {
            LocalDate startDate = LocalDate.of(
                    recurrence.getStartDate().getYear(),
                    recurrence.getStartDate().getMonth(),
                    recurrence.getStartDate().getDay());
            if (localDate.isBefore(startDate)) {
                return false;
            }
        }

        if (recurrence.hasEndDate()) {
            LocalDate endDate = LocalDate.of(
                    recurrence.getEndDate().getYear(),
                    recurrence.getEndDate().getMonth(),
                    recurrence.getEndDate().getDay());
            if (localDate.isAfter(endDate)) {
                return false;
            }
        }

        if (hasAnyDayFlag(recurrence) && !isDayEnabled(recurrence, localDate.getDayOfWeek())) {
            return false;
        }

        boolean inTimeWindow = true;
        if (recurrence.hasStartTime() || recurrence.hasEndTime()) {
            LocalTime start = recurrence.hasStartTime()
                    ? LocalTime.of(
                            recurrence.getStartTime().getHours(),
                            recurrence.getStartTime().getMinutes(),
                            recurrence.getStartTime().getSeconds(),
                            recurrence.getStartTime().getNanos())
                    : LocalTime.MIN;
            LocalTime end = recurrence.hasEndTime()
                    ? LocalTime.of(
                            recurrence.getEndTime().getHours(),
                            recurrence.getEndTime().getMinutes(),
                            recurrence.getEndTime().getSeconds(),
                            recurrence.getEndTime().getNanos())
                    : LocalTime.MAX;

            if (!start.isAfter(end)) {
                inTimeWindow = !localTime.isBefore(start) && localTime.isBefore(end);
            } else {
                // overnight schedule (for example 22:00-06:00)
                inTimeWindow = !localTime.isBefore(start) || localTime.isBefore(end);
            }
        }

        if (recurrence.hasExclusion() && recurrence.getExclusion()) {
            return !inTimeWindow;
        }

        return inTimeWindow;
    }

    private static boolean hasAnyDayFlag(EventRecurrence recurrence) {
        return recurrence.getMonday()
                || recurrence.getTuesday()
                || recurrence.getWednesday()
                || recurrence.getThursday()
                || recurrence.getFriday()
                || recurrence.getSaturday()
                || recurrence.getSunday();
    }

    private static boolean isDayEnabled(EventRecurrence recurrence, DayOfWeek day) {
        return switch (day) {
            case MONDAY -> recurrence.getMonday();
            case TUESDAY -> recurrence.getTuesday();
            case WEDNESDAY -> recurrence.getWednesday();
            case THURSDAY -> recurrence.getThursday();
            case FRIDAY -> recurrence.getFriday();
            case SATURDAY -> recurrence.getSaturday();
            case SUNDAY -> recurrence.getSunday();
        };
    }
}
