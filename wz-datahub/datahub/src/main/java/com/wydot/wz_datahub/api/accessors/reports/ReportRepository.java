
package com.wydot.wz_datahub.api.accessors.reports;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.wydot.wz_datahub.api.models.reports.ReportWithId;

public interface ReportRepository {
    long count(Long id, String userId, Long generatedStartTime, Long generatedEndTime,
            Long activeStartTime,
            Long activeEndTime);

    Page<ReportWithId> find(Long id, String userId, Long generatedStartTime, Long generatedEndTime,
            Long activeStartTime, Long activeEndTime, Pageable pageable);

    ReportWithId findLatest(Long id, String userId, Long generatedStartTime, Long generatedEndTime,
            Long activeStartTime, Long activeEndTime);

    void insert(ReportWithId recording);

    void update(Long id, ReportWithId recording, Boolean upsert);

    long delete(Long id);

    Long generateUniqueId();
}