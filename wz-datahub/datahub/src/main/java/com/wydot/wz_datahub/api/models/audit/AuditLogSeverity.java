package com.wydot.wz_datahub.api.models.audit;

public enum AuditLogSeverity {
    INFO, // Standard process tracking
    WARN, // Unexpected but handled (e.g., "Linked event not found, creating new")
    ERROR, // Critical failure (e.g., "API call failed, data lost")
    DEBUG // Detailed trace data
}
