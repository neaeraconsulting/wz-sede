package com.wydot.wz_datahub.api.retrievers.wanco;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
public class WancoTokenService {

    private final WancoDeviceFeedApi api;
    private final WancoTokenStore tokenStore;
    private final WancoIngestProperties wancoProperties;

    private Mono<WancoTokenStore> refreshTokens() {
        return api.generateAccessToken(wancoProperties.getApiKey())
                .map(accessToken -> {
                    tokenStore.setAccessToken(accessToken.getToken(),
                            Instant.now().plusSeconds(wancoProperties.getTokenLifespan().toSeconds()));
                    return tokenStore;
                });
    }

    public Mono<WancoTokenStore> getTokenStore() {
        if (!tokenStore.isAccessTokenValid()) {
            log.debug("Refreshing Tokens - Returning Store {}", tokenStore.isAccessTokenValid());
            return refreshTokens();
        } else {
            log.debug("Returning Store {}", tokenStore.isAccessTokenValid());
            return Mono.just(tokenStore);
        }
    }
}
