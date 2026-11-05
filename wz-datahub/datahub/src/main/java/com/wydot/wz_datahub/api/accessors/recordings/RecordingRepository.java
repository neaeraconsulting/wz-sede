
package com.wydot.wz_datahub.api.accessors.recordings;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.wydot.wz_datahub.api.models.recordings.RecordingWithId;

public interface RecordingRepository {
    long count(Long id, String userId, Long generatedStartTime, Long generatedEndTime,
            Long activeStartTime,
            Long activeEndTime);

    Page<RecordingWithId> find(Long id, String userId, Long generatedStartTime, Long generatedEndTime,
            Long activeStartTime, Long activeEndTime, Pageable pageable);

    void insert(RecordingWithId recording);

    void update(Long id, RecordingWithId recording, Boolean upsert);

    long delete(Long id);

    Long generateUniqueId();
}