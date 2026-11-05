package com.wydot.wz_datahub.api.models.audit;

import java.time.Instant;

// Simple record for the bus
public record AuditLogEntry(
        Long correlationId,
        String message,
        AuditLogSeverity severity,
        Instant timestamp) {
}