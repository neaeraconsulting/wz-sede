package com.wydot.wz_datahub.api.controllers;

import com.wydot.wz_datahub.api.accessors.road_event.RoadEventRepository;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventWrapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import reactor.core.publisher.Mono;

@Slf4j
@RestController
@RequestMapping("/road-events")
@RequiredArgsConstructor
public class RoadEventsController {
    private final RoadEventRepository roadEventRepository;

    @PreAuthorize("hasRole('ROLE_ADMIN') || hasRole('ROLE_USER') || hasRole('ROLE_SERVICE')")
    @GetMapping("/ids")
    public Mono<Page<Long>> getRoadEventIds(
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
        return Mono.just(roadEventRepository.findProjection(id, userId,
                generatedStartTime, generatedEndTime,
                eventStartTimeMin, eventStartTimeMax, eventEndTimeMin, eventEndTimeMax,
                PageRequest.of(page, size), RoadEventWrapper.RoadEventIdOnly.class)
                .map(RoadEventWrapper.RoadEventIdOnly::getId));
    }
}
