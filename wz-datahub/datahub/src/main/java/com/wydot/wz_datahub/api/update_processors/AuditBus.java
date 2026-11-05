package com.wydot.wz_datahub.api.update_processors;

import java.time.Instant;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Service;

import com.wydot.wz_datahub.api.accessors.road_event.RoadEventAbandonedAuditRepository;
import com.wydot.wz_datahub.api.accessors.road_event.RoadEventAuditRepository;
import com.wydot.wz_datahub.api.models.audit.AuditLogEntry;
import com.wydot.wz_datahub.api.models.audit.AuditLogSeverity;
import com.wydot.wz_datahub.api.models.audit.AuditLoggingConfig;
import com.wydot.wz_datahub.api.models.audit.AuditSession;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventAbandonedAudit;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventAudit;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventWrapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class AuditBus {
    // Stores everything we know about an active "Session"
    private final Map<Long, AuditSession> activeSessions = new ConcurrentHashMap<>();
    private final RoadEventAuditRepository auditRepo;
    private final RoadEventAbandonedAuditRepository abandonedRepo;
    private final AuditLoggingConfig config;

    // Called at the very start of the window
    public void startSession(Long id, RoadEventWrapper initialState) {
        activeSessions.put(id, new AuditSession(id, initialState));
    }

    public void record(Long id, String message, AuditLogSeverity severity) {
        AuditSession session = activeSessions.get(id);
        if (session != null) {
            AuditLogEntry entry = new AuditLogEntry(
                    id,
                    message,
                    severity,
                    Instant.now());
            session.addLog(entry);

            // 2. Mirror to standard logs if enabled and severity matches
            if (config.isLoggingEnabled() && severity.ordinal() >= config.getLoggingMinSeverity().ordinal()) {
                mirrorToStandardLog(entry);
            }
        }
    }

    private void mirrorToStandardLog(AuditLogEntry entry) {
        String logMessage = String.format("[AUDIT][%s] ID: %d - %s",
                entry.severity(), entry.correlationId(), entry.message());

        switch (entry.severity()) {
            case INFO -> log.info(logMessage);
            case WARN -> log.warn(logMessage);
            case ERROR -> log.error(logMessage);
            case DEBUG -> log.debug(logMessage);
        }
    }

    // "Claim" is called by the Success Logic. It removes the session so the Orphan
    // listener ignores it.
    public Optional<AuditSession> claimSession(Long id) {
        return Optional.ofNullable(activeSessions.remove(id));
    }

    public Map<Long, AuditSession> getActiveSessions() {
        return activeSessions;
    }

    public void submitAudit(Long id, RoadEventAudit audit) {
        claimSession(id).ifPresent(session -> {
            audit.setLogs(session.getLogs());
            auditRepo.insert(audit);
        });
    }

    public void terminateSession(Long id, String reason) {
        record(id, "Session terminated: " + reason, AuditLogSeverity.INFO);
        claimSession(id).ifPresent(session -> {
            RoadEventAbandonedAudit abandoned = new RoadEventAbandonedAudit(
                    session.getCorrelationId(),
                    session.getStartTime(),
                    session.getInitialState(), // Even abandoned ones have the "before"
                    session.getLogs());
            abandonedRepo.insert(abandoned);
        });
    }
}