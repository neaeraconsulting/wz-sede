package com.wydot.wz_datahub.api.models.audit;

import java.time.Instant;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

import com.wydot.wz_datahub.api.models.wrappers.RoadEventWrapper;

import lombok.Data;

// Helper class to hold the state
@Data
public class AuditSession {
    private final Long correlationId;
    private final RoadEventWrapper initialState;
    private final List<AuditLogEntry> logs = new CopyOnWriteArrayList<>();
    private final Instant startTime = Instant.now();

    public void addLog(AuditLogEntry entry) {
        logs.add(entry);
    }
}