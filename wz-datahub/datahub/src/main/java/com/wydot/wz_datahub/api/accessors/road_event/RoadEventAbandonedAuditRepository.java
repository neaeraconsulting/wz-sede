
package com.wydot.wz_datahub.api.accessors.road_event;

import com.wydot.wz_datahub.api.models.wrappers.RoadEventAbandonedAudit;

public interface RoadEventAbandonedAuditRepository {
    void insert(RoadEventAbandonedAudit item);
}