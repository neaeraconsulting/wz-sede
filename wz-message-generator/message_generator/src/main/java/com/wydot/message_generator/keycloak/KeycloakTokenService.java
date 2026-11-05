package com.wydot.message_generator.keycloak;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
public class KeycloakTokenService {

    private final KeycloakApi api;
    private final KeycloakTokenStore tokenStore;

    private Mono<KeycloakTokenStore> refreshTokens() {
        return api.generateAccessToken()
                .map(accessToken -> {
                    tokenStore.setAccessToken(accessToken.getAccessToken(),
                            Instant.now().plusSeconds(accessToken.getExpiresIn()));
                    return tokenStore;
                });
    }

    public Mono<KeycloakTokenStore> getTokenStore() {
        if (!tokenStore.isAccessTokenValid()) {
            log.debug("Refreshing Tokens - Returning Store {}", tokenStore.isAccessTokenValid());
            return refreshTokens();
        } else {
            log.debug("Returning Store {}", tokenStore.isAccessTokenValid());
            return Mono.just(tokenStore);
        }
    }
}
