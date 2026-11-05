package com.wydot.wz_datahub.api.retrievers.pi_lit;

import java.util.concurrent.CompletionException;

import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.wydot.wz_datahub.api.accessors.raw.RawDataRepository;
import com.wydot.wz_datahub.api.models.pi_lit.PiLitTokenRequest;
import com.wydot.wz_datahub.api.models.pi_lit.PiLitTokenResponse;
import com.wydot.wz_datahub.api.models.raw_data.RawDataType;
import com.wydot.wz_datahub.api.models.raw_data.RawDataWrapper;
import com.wydot.wz_datahub.api.models.wz.device_feed.DeviceFeed;

import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

@Slf4j
@Service
public class PiLitEventFeedApi {

    private final WebClient webClient;
    private final ObjectMapper objectMapper;
    private final RawDataRepository rawDataRepository;

    public PiLitEventFeedApi(
            ObjectMapper objectMapper,
            PiLitIngestProperties props,
            RawDataRepository rawDataRepository) {
        this.objectMapper = objectMapper;
        this.rawDataRepository = rawDataRepository;
        this.webClient = WebClient.builder()
                .baseUrl(props.getUrl())
                // .defaultHeader(HttpHeaders.AUTHORIZATION, "Bearer " + props.getPassword())
                .build();
    }

    @Async
    public Mono<DeviceFeed> retrieveAsync(String accessToken) {
        return webClient.get()
                .uri("/wzdx/active_flare_event")
                .header("Authorization", "Bearer " + accessToken)
                .retrieve()
                .bodyToMono(String.class) // raw JSON first
                .map(json -> {
                    try {
                        log.trace("Received Pi-Lit Device Feed JSON: {}", json);
                        return objectMapper.readValue(json, DeviceFeed.class);
                    } catch (Exception e) {
                        log.error("Failed to parse Pi-Lit Device Feed JSON: {}", json, e);
                        throw new CompletionException("Failed to parse Pi-Lit Device Feed JSON", e);
                    } finally {
                        RawDataWrapper rawMessage = new RawDataWrapper(System.currentTimeMillis(), RawDataType.PI_LIT,
                                json);

                        // Asynchronously log raw data, errors are logged but do not interrupt
                        // processing
                        Mono.fromRunnable(() -> rawDataRepository.insert(rawMessage))
                                .doOnError(
                                        ex -> System.err
                                                .println("Failed to insert raw Pi-Lit data: " + ex.getMessage()))
                                .subscribe();
                    }
                });
    }

    @Async
    public Mono<PiLitTokenResponse> generateAccessToken(String email, String password) {
        PiLitTokenRequest requestBody = new PiLitTokenRequest(email, password);
        return webClient.post()
                .uri("/login")
                .headers(headers -> {
                    headers.set(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_FORM_URLENCODED_VALUE);
                })
                .body(BodyInserters.fromFormData(requestBody.getFormData()))
                .retrieve()
                .bodyToMono(PiLitTokenResponse.class);
    }
}
