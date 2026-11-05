package com.wydot.wz_datahub.api.retrievers.pi_lit;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
public class PiLitTokenService {

    private final PiLitEventFeedApi api;
    private final PiLitTokenStore tokenStore;
    private final PiLitIngestProperties piLitProperties;

    private Mono<PiLitTokenStore> refreshTokens() {
        return api.generateAccessToken(piLitProperties.getUsername(), piLitProperties.getPassword())
                .map(accessToken -> {
                    tokenStore.setAccessToken(accessToken.getToken(),
                            Instant.now().plusSeconds(piLitProperties.getTokenLifespan().toSeconds()));
                    return tokenStore;
                });
    }

    public Mono<PiLitTokenStore> getTokenStore() {
        if (!tokenStore.isAccessTokenValid()) {
            log.debug("Refreshing Tokens - Returning Store {}", tokenStore.isAccessTokenValid());
            return refreshTokens();
        } else {
            log.debug("Returning Store {}", tokenStore.isAccessTokenValid());
            return Mono.just(tokenStore);
        }
    }
}
