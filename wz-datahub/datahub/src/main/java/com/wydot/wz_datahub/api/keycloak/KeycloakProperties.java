package com.wydot.wz_datahub.api.keycloak;

import lombok.Data;

import java.util.List;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConfigurationProperties(prefix = "keycloak")
@Data
public class KeycloakProperties {
    private String realm;
    private String clientId;
    private String clientSecret;
    private String endpoint;

    private List<String> adminRegistrationEmails;
}
