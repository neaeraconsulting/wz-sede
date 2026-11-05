package com.wydot.wz_datahub.api.models.wrappers;

import java.time.Instant;
import java.util.List;

import com.wydot.wz_datahub.api.models.audit.AuditLogEntry;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class RoadEventAbandonedAudit {
    Long roadEventId;
    Instant startTimestamp;
    RoadEventWrapper roadEventWrapper;
    List<AuditLogEntry> logs;
}
