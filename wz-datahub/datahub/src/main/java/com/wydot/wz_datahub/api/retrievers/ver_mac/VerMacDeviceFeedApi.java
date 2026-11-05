package com.wydot.wz_datahub.api.retrievers.ver_mac;

import java.util.concurrent.CompletionException;

import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.wydot.wz_datahub.api.accessors.raw.RawDataRepository;
import com.wydot.wz_datahub.api.models.raw_data.RawDataType;
import com.wydot.wz_datahub.api.models.raw_data.RawDataWrapper;
import com.wydot.wz_datahub.api.models.wz.device_feed.DeviceFeed;

import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

@Slf4j
@Service
public class VerMacDeviceFeedApi {

    private final WebClient webClient;
    private final ObjectMapper objectMapper;
    private final RawDataRepository rawDataRepository;

    public VerMacDeviceFeedApi(
            ObjectMapper objectMapper,
            VerMacIngestProperties props,
            RawDataRepository rawDataRepository) {
        this.objectMapper = objectMapper;
        this.rawDataRepository = rawDataRepository;
        this.webClient = WebClient.builder()
                .baseUrl(props.getUrl())
                // .defaultHeader(HttpHeaders.AUTHORIZATION, "Bearer " + props.getPassword())
                .build();
    }

    @Async
    public Mono<DeviceFeed> retrieveAsync() {
        return webClient.get()
                .retrieve()
                .bodyToMono(String.class) // raw JSON first
                .map(json -> {
                    try {
                        log.trace("Received Ver-Mac Device Feed JSON: {}", json);
                        return objectMapper.readValue(json, DeviceFeed.class);
                    } catch (Exception e) {
                        log.error("Failed to parse Ver-Mac Device Feed JSON: {}", json, e);
                        throw new CompletionException("Failed to parse Ver-Mac Device Feed JSON", e);
                    } finally {
                        RawDataWrapper rawMessage = new RawDataWrapper(System.currentTimeMillis(), RawDataType.VER_MAC,
                                json);

                        // Asynchronously log raw data, errors are logged but do not interrupt
                        // processing
                        Mono.fromRunnable(() -> rawDataRepository.insert(rawMessage))
                                .doOnError(
                                        ex -> System.err
                                                .println("Failed to insert raw Ver-Mac data: " + ex.getMessage()))
                                .subscribe();
                    }
                });
    }
}
