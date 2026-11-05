package com.wydot.message_generator.cleanup_tasks;

import lombok.Data;

import java.time.Duration;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConfigurationProperties(prefix = "message-cleanup")
@Data
public class MessageCleanupTaskProperties {
    private Boolean enabled;
    private Duration evalInterval;
}