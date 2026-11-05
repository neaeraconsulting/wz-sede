package com.wydot.message_generator.keycloak;

import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

import java.time.Instant;

@Component
@Slf4j
public class KeycloakTokenStore {

    private String accessToken;
    private Instant accessTokenExpirationTime;

    public synchronized String getAccessToken() {
        return accessToken;
    }

    public synchronized void setAccessToken(String accessToken, Instant tokenExpiration) {
        this.accessToken = accessToken;
        this.accessTokenExpirationTime = tokenExpiration;
    }

    public synchronized boolean isAccessTokenValid() {
        return accessTokenExpirationTime != null && Instant.now().isBefore(accessTokenExpirationTime);
    }
}