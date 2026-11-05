package com.wydot.wz_datahub.api.retrievers.pi_lit;

import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

import java.time.Instant;

@Component
@Slf4j
public class PiLitTokenStore {

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
