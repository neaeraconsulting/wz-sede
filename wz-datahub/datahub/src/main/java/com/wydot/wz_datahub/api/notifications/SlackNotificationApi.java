package com.wydot.wz_datahub.api.notifications;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.google.type.LatLng;
import com.wydot.wz_datahub.api.keycloak.KeycloakApi;
import com.wydot.wz_datahub.api.models.SupportRequestBody;
import com.wydot.wz_datahub.api.models.keycloak.KeycloakUserInfo;
import com.wydot.wz_datahub.api.models.keycloak.KeycloakUserRequestDto;
import com.wydot.wz_datahub.api.models.recordings.Recording;
import com.wydot.wz_datahub.api.models.recordings.RecordingPoint;
import com.wydot.wz_datahub.api.models.reports.Report;
import com.wydot.wz_datahub.api.models.reports.WorkerPresenceReport;
import com.wydot.wz_datahub.api.models.workers.LiveWorkerLocation;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class SlackNotificationApi {

    private final SlackNotificationConfig config;
    private final KeycloakApi keycloakApi;
    private final RestTemplate restTemplate = new RestTemplate();

    /**
     * Send a notification for new user registration
     */
    public void sendUserRegistrationNotification(KeycloakUserRequestDto userRequest) {
        if (!config.getNewUserRegistration().isEnabled()) {
            log.debug("User registration notifications are disabled");
            return;
        }

        String message = String.format(
                "🎉 *New User Registration*\n" +
                        "Name: `%s %s`\n" +
                        "Username: `%s`\n" +
                        "Platform: `%s`\n" +
                        "Message: `%s`",
                userRequest.getFirstName(),
                userRequest.getLastName(),
                userRequest.getUsername(),
                userRequest.getPlatform(),
                userRequest.getMessage());

        sendSlackMessage(config.getNewUserRegistration().getWebhookUrl(), message);
    }

    /**
     * Send a notification for new user registration failure
     */
    public void sendUserRegistrationFailureNotification(KeycloakUserRequestDto userRequest, Throwable e) {
        if (!config.getNewUserRegistration().isEnabled()) {
            log.debug("User registration notifications are disabled");
            return;
        }

        String message = String.format(
                "❌ *Error in User Registration*\n" +
                        "Name: `%s %s`\n" +
                        "Username: `%s`\n" +
                        "Platform: `%s`\n" +
                        "Request Message: `%s`\n" +
                        "Error Message: `%s`",
                userRequest.getFirstName(),
                userRequest.getLastName(),
                userRequest.getUsername(),
                userRequest.getPlatform(),
                userRequest.getMessage(),
                e.getMessage());

        sendSlackMessage(config.getNewUserRegistration().getWebhookUrl(), message);
    }

    /**
     * Send a notification for support request
     */
    public void sendSupportRequestNotification(SupportRequestBody supportRequest) {
        if (!config.getSupportRequest().isEnabled()) {
            log.debug("Support request notifications are disabled");
            return;
        }

        String slackMessage = String.format(
                "*New Support Request*\n" +
                        "From: `%s`\n" +
                        "Subject: *%s*\n" +
                        "Message:\n```%s```",
                supportRequest.getUsername(), supportRequest.getSubject(), supportRequest.getMessage());

        sendSlackMessage(config.getSupportRequest().getWebhookUrl(), slackMessage);
    }

    /**
     * Send a notification for worker presence report
     */
    public void sendWorkerPresenceReportNotification(WorkerPresenceReport report) {
        if (!config.getReport().isEnabled()) {
            log.debug("Report notifications are disabled");
            return;
        }

        String measureString = String.format("Route: `%s` `%.2f` - `%.2f`",
                report.getRouteAndMeasureRange().getRouteId(),
                report.getRouteAndMeasureRange().getStartMeasure(),
                report.getRouteAndMeasureRange().getEndMeasure());
        String slackMessage = String.format(
                "*New Worker Presence Report*\n" +
                        "Road Event ID: `%s`\n" +
                        "Location: `%s`\n" +
                        "User: `%s`",
                report.getRoadEventId(), measureString, report.getUserId());

        sendSlackMessage(config.getReport().getWebhookUrl(), slackMessage);
    }

    /**
     * Send a notification for report
     */
    public void sendReportNotification(Report report) {
        if (!config.getReport().isEnabled()) {
            log.debug("Report notifications are disabled");
            return;
        }
        String slackMessage;
        if (report.getGeometry() != null && !report.getGeometry().isEmpty()) {
            LatLng location = report.getGeometry().getFirst();
            String locationString = String.format("Location: <%s|View on Google Maps>",
                    createSlackGoogleMapsLink(location.getLatitude(), location.getLongitude(), "View on Google Maps"));

            slackMessage = String.format(
                    "*New Report*\n" +
                            "Name: `%s`\n" +
                            "Description: `%s`\n" +
                            "Location: `%s`",
                    report.getName(), report.getDescription(), locationString);
        } else {
            slackMessage = String.format(
                    "*New Report*\n" +
                            "Name: `%s`\n" +
                            "Description: `%s`\n" +
                            "Location: MISSING",
                    report.getName(), report.getDescription());
        }

        sendSlackMessage(config.getReport().getWebhookUrl(), slackMessage);
    }

    /**
     * Send a notification for report
     */
    public void sendRecordingNotification(Recording recording) {
        if (!config.getReport().isEnabled()) {
            log.debug("Recording notifications are disabled");
            return;
        }
        RecordingPoint location = recording.getPoints().getFirst();
        String locationString = String.format("Location: <%s|View on Google Maps>",
                createSlackGoogleMapsLink(location.getLatitude(), location.getLongitude(), "View on Google Maps"));

        String slackMessage = String.format(
                "*New Recording*\n" +
                        "Name: `%s`\n" +
                        "Description: `%s`\n" +
                        "Location: `%s`",
                recording.getName(), recording.getDescription(), locationString);

        sendSlackMessage(config.getReport().getWebhookUrl(), slackMessage);
    }

    /**
     * Send a notification for mobile session
     */
    public void sendMobileSessionNotification(LiveWorkerLocation workerLocation) {
        if (!config.getMobileSession().isEnabled()) {
            log.debug("Mobile session notifications are disabled");
            return;
        }
        LatLng location = workerLocation.getLocation();
        String locationString = String.format("Location: <%s|View on Google Maps>",
                createSlackGoogleMapsLink(location.getLatitude(), location.getLongitude(), "View on Google Maps"));

        KeycloakUserInfo userInfo = keycloakApi.getUserInfo(workerLocation.getWorkerId()).block();
        String name = userInfo != null ? String.format("%s %s", userInfo.getFirstName(), userInfo.getLastName())
                : workerLocation.getWorkerId();

        String slackMessage = String.format(
                "*New Mobile Session*\n" +
                        "Name: `%s`\n" +
                        "Description: `%s`\n" +
                        "Location: `%s`",
                name, workerLocation.getIsActive(), locationString);

        sendSlackMessage(config.getMobileSession().getWebhookUrl(), slackMessage);
    }

    /**
     * Send a notification for worker presence report
     */
    public void sendErrorNotification(String errorMessage) {
        if (!config.getReport().isEnabled()) {
            log.debug("Report notifications are disabled");
            return;
        }

        String slackMessage = String.format(
                "*Error occurred*\n" +
                        "Error Message: `%s`",
                errorMessage);

        sendSlackMessage(config.getReport().getWebhookUrl(), slackMessage);
    }

    /**
     * Send a custom notification to a specific channel
     */
    public void sendCustomNotification(NotificationType type, String message) {
        String webhookUrl = switch (type) {
            case USER_REGISTRATION -> config.getNewUserRegistration().getWebhookUrl();
            case SUPPORT_REQUEST -> config.getSupportRequest().getWebhookUrl();
        };

        boolean enabled = switch (type) {
            case USER_REGISTRATION -> config.getNewUserRegistration().isEnabled();
            case SUPPORT_REQUEST -> config.getSupportRequest().isEnabled();
        };

        if (!enabled) {
            log.debug("{} notifications are disabled", type);
            return;
        }

        sendSlackMessage(webhookUrl, message);
    }

    /**
     * Send a message to Slack webhook
     */
    private void sendSlackMessage(String webhookUrl, String message) {
        if (webhookUrl == null || webhookUrl.isBlank()) {
            log.warn("Slack webhook URL is not configured");
            return;
        }

        try {
            Map<String, Object> payload = new HashMap<>();
            payload.put("text", message);
            payload.put("mrkdwn", true);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            HttpEntity<Map<String, Object>> request = new HttpEntity<>(payload, headers);

            restTemplate.postForEntity(webhookUrl, request, String.class);
            log.debug("Slack notification sent successfully");

        } catch (Exception e) {
            log.error("Failed to send Slack notification", e);
        }
    }

    // For a URL-clickable link in Slack
    public static String createSlackGoogleMapsLink(double latitude, double longitude, String label) {
        String url = String.format("https://www.google.com/maps?q=%.6f,%.6f", latitude, longitude);
        return String.format("<%s|%s>", url, label); // Slack link format: <url|text>
    }

    public enum NotificationType {
        USER_REGISTRATION,
        SUPPORT_REQUEST
    }
}
