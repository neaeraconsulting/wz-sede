package com.wydot.message_generator.datahub;

import java.time.Instant;
import java.util.Map;

import javax.annotation.Nullable;

import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.server.ResponseStatusException;

import com.wydot.message_generator.keycloak.KeycloakTokenService;
import com.wydot.message_generator.models.data_sources.DataFeedSourceSummary;

import reactor.core.publisher.Mono;

@Component
public class DataHubApi {
    private final WebClient webClient;
    private final KeycloakTokenService tokenService;

    public DataHubApi(DataHubApiProperties properties, WebClient.Builder webClientBuilder,
            KeycloakTokenService tokenService) {
        this.webClient = webClientBuilder.baseUrl(properties.getEndpoint()).build();
        this.tokenService = tokenService;
    }

    public Mono<DataFeedSourceSummary[]> getDataFeedSourceSummaries() {
        return tokenService.getTokenStore()
                .flatMap(accessToken -> webClient.get()
                        .uri("/message-generator/data-source-summaries")
                        .headers(headers -> {
                            headers.setBearerAuth(accessToken.getAccessToken());
                        })
                        .exchangeToMono(response -> {
                            if (response.statusCode().is2xxSuccessful()) {
                                return response
                                        .bodyToMono(DataFeedSourceSummary[].class);
                            } else {
                                return response.bodyToMono(String.class)
                                        .flatMap(body -> Mono.error(new ResponseStatusException(response.statusCode(),
                                                String.format("Failed to get data feed summaries: %s", body))));
                            }
                        }));
    }

    public Mono<Long[]> startRoadEventSync(@Nullable Long roadEventId) {
        return tokenService.getTokenStore()
                .flatMap(accessToken -> webClient.post()
                        .uri(uriBuilder -> {
                            uriBuilder.path("/kafka/message_generator_sync");
                            if (roadEventId != null) {
                                uriBuilder.queryParam("road_event_id", roadEventId);
                            }
                            return uriBuilder.build();
                        })
                        .headers(headers -> {
                            headers.setBearerAuth(accessToken.getAccessToken());
                        })
                        .exchangeToMono(response -> {
                            if (response.statusCode().is2xxSuccessful()) {
                                return response
                                        .bodyToMono(Long[].class);
                            } else {
                                return response.bodyToMono(String.class)
                                        .flatMap(body -> Mono.error(new ResponseStatusException(response.statusCode(),
                                                String.format("Failed to start road event sync: %s", body))));
                            }
                        }));
    }

    public Mono<Long[]> getExpiredRoadEventsSince(@Nullable Instant lastQueryTime) {
        // Define query parameters internally
        Map<String, String> queryParams = Map.of(
                "event_end_time_max_millis", String.valueOf(Instant.now().toEpochMilli()),
                "limit", "10000");

        if (lastQueryTime != null) {

            queryParams.put("event_end_time_min_millis", String.valueOf(lastQueryTime.toEpochMilli()));
        }

        return tokenService.getTokenStore()
                .flatMap(accessToken -> webClient.get()
                        .uri(uriBuilder -> {
                            uriBuilder.path("/road-events/ids");
                            queryParams.forEach(uriBuilder::queryParam);
                            return uriBuilder.build();
                        })
                        .headers(headers -> {
                            headers.setBearerAuth(accessToken.getAccessToken());
                            headers.set(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE);
                        })
                        .exchangeToMono(response -> {
                            if (response.statusCode().is2xxSuccessful()) {
                                return response.bodyToMono(Long[].class);
                            } else {
                                return response.bodyToMono(String.class)
                                        .flatMap(body -> Mono.error(new ResponseStatusException(response.statusCode(),
                                                String.format("Failed to create user: %s", body))));
                            }
                        }));
    }
}
