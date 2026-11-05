package com.wydot.wz_datahub.api.update_processors;

import java.time.Instant;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.accessors.road_event.RoadEventAbandonedAuditRepository;
import com.wydot.wz_datahub.api.models.audit.AuditLoggingConfig;
import com.wydot.wz_datahub.api.models.audit.AuditSession;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventAbandonedAudit;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class AbandonedAuditListener {
    private final AuditBus auditBus;
    private final RoadEventAbandonedAuditRepository abandonedRepo;
    private final AuditLoggingConfig config;

    @Scheduled(fixedDelay = 60000) // Check every minute
    public void flushAbandoned() {
        Instant cutoff = Instant.now().minus(config.getAutoFlushAge());

        auditBus.getActiveSessions().entrySet().removeIf(entry -> {
            AuditSession session = entry.getValue();
            if (session.getStartTime().isBefore(cutoff)) {

                // This session was never claimed by the Success Logic!
                RoadEventAbandonedAudit abandoned = new RoadEventAbandonedAudit(
                        session.getCorrelationId(),
                        session.getStartTime(),
                        session.getInitialState(), // Even abandoned ones have the "before"
                        session.getLogs());

                abandonedRepo.insert(abandoned);
                return true; // Removes from the ConcurrentHashMap
            }
            return false;
        });
    }
}