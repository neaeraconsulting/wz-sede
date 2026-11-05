
package com.wydot.wz_datahub.api.accessors.road_event;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.wydot.wz_datahub.api.models.wrappers.RoadEventAudit;

public interface RoadEventAuditRepository {
    long count(Long roadEventId, Long requestId, Long updatedStartTime, Long updatedEndTime);

    RoadEventAudit findLatest(Long roadEventId, Long requestId, Long updatedStartTime, Long updatedEndTime);

    Page<RoadEventAudit> find(Long roadEventId, Long requestId, Long updatedStartTime, Long updatedEndTime,
            Pageable pageable);

    void insert(RoadEventAudit item);
}