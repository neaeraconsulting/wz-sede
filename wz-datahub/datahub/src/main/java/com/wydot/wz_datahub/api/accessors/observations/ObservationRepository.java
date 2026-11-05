
package com.wydot.wz_datahub.api.accessors.observations;

import java.time.Instant;
import java.util.List;

import com.wydot.wz_datahub.api.models.update_processing.Observation;

public interface ObservationRepository {
    long count(String roadEventId, String sourceId, Instant activeDate);

    List<Observation<?>> findUnique(String roadEventId, String sourceId, Instant activeDate);

    List<Long> findRoadEventIdsWithExpiredObservations(Instant now);

    void insert(Observation<?> observation);
}