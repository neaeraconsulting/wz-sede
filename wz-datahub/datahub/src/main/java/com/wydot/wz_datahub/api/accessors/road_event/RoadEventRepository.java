
package com.wydot.wz_datahub.api.accessors.road_event;

import java.time.Instant;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.wydot.wz_datahub.api.models.wrappers.RoadEventWrapper;

public interface RoadEventRepository {
    List<RoadEventWrapper> findAll();

    Page<RoadEventWrapper> find(Long id,
            String userId,
            Long generatedStartTime,
            Long generatedEndTime,
            Long eventStartTimeMin,
            Long eventStartTimeMax,
            Long eventEndTimeMin,
            Long eventEndTimeMax,
            Pageable pageable);

    RoadEventWrapper findOne(Long id,
            String userId,
            Long generatedStartTime,
            Long generatedEndTime,
            Long eventStartTimeMin,
            Long eventStartTimeMax,
            Long eventEndTimeMin,
            Long eventEndTimeMax);

    <T> Page<T> findProjection(
            Long id,
            String userId,
            Long generatedStartTime,
            Long generatedEndTime,
            Long eventStartTimeMin,
            Long eventStartTimeMax,
            Long eventEndTimeMin,
            Long eventEndTimeMax,
            Pageable pageable,
            Class<T> projectionClass);

    List<RoadEventWrapper> findRoadEventIdsWithExpiredObservations(Instant now);

    List<RoadEventWrapper> findRoadEventsWithRecentlyActiveObservations(Instant windowStart, Instant windowEnd);

    void update(Long id, RoadEventWrapper roadEvent);

    void delete(Long id);
}