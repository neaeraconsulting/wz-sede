package com.wydot.wz_datahub.api.retrievers.icone;

import java.util.List;
import java.util.concurrent.CompletionException;

import org.springframework.http.HttpHeaders;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.wydot.wz_datahub.api.accessors.raw.RawDataRepository;
import com.wydot.wz_datahub.api.models.raw_data.RawDataType;
import com.wydot.wz_datahub.api.models.raw_data.RawDataWrapper;
import com.wydot.wz_datahub.api.models.wz.device_feed.DeviceFeed;

import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

@Slf4j
@Service
public class IconeApi {

    private final WebClient webClient;
    private final ObjectMapper objectMapper;
    private final RawDataRepository rawDataRepository;
    TypeReference<List<DeviceFeed>> deviceFeedListTypeRef = new TypeReference<>() {
    };

    public IconeApi(
            ObjectMapper objectMapper,
            IconeIngestProperties props,
            RawDataRepository rawDataRepository) {
        this.objectMapper = objectMapper;
        this.rawDataRepository = rawDataRepository;
        this.webClient = WebClient.builder()
                .baseUrl(props.getUrl())
                .defaultHeader(HttpHeaders.AUTHORIZATION, "Bearer " + props.getApiKey())
                .build();
    }

    @Async
    public Mono<DeviceFeed> retrieveAsync() {
        return webClient.get()
                .retrieve()
                .bodyToMono(String.class) // raw JSON first
                .map(json -> {
                    try {
                        log.trace("Received Icone Device Feed JSON: {}", json);
                        return objectMapper.readValue(json, deviceFeedListTypeRef).getFirst();
                    } catch (Exception e) {
                        log.error("Failed to parse Icone Device Feed JSON: {}", json, e);
                        throw new CompletionException("Failed to parse Icone Device Feed JSON", e);
                    } finally {
                        RawDataWrapper rawMessage = new RawDataWrapper(System.currentTimeMillis(), RawDataType.ICONE,
                                json);

                        // Asynchronously log raw data, errors are logged but do not interrupt
                        // processing
                        Mono.fromRunnable(() -> rawDataRepository.insert(rawMessage))
                                .doOnError(
                                        ex -> System.err.println("Failed to insert raw Icone data: " + ex.getMessage()))
                                .subscribe();
                    }
                });
    }
}
