package com.wydot.wz_datahub.api.notifications;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import lombok.Data;

@Data
@Configuration
@ConfigurationProperties(prefix = "slack-notification")
public class SlackNotificationConfig {

    private NotificationChannel newUserRegistration;
    private NotificationChannel supportRequest;
    private NotificationChannel report;
    private NotificationChannel mobileSession;

    @Data
    public static class NotificationChannel {
        private boolean enabled;
        private String webhookUrl;
    }
}
