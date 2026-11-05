package com.wydot.wz_datahub.api.models.audit;

import java.time.Duration;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import lombok.Data;

@Configuration
@ConfigurationProperties(prefix = "audit")
@Data // Using Lombok here for the config bean
public class AuditLoggingConfig {
    private boolean loggingEnabled = false;
    private AuditLogSeverity loggingMinSeverity = AuditLogSeverity.INFO;
    private Duration autoFlushAge = Duration.ofMinutes(5);
}