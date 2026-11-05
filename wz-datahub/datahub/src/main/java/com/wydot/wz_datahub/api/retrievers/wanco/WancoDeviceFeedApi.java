package com.wydot.wz_datahub.api.retrievers.wanco;

import java.time.Duration;
import java.util.concurrent.CompletionException;

import org.springframework.http.HttpHeaders;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.wydot.wz_datahub.api.accessors.raw.RawDataRepository;
import com.wydot.wz_datahub.api.models.raw_data.RawDataType;
import com.wydot.wz_datahub.api.models.raw_data.RawDataWrapper;
import com.wydot.wz_datahub.api.models.wanco.WancoDeviceFeedWZDx42;
import com.wydot.wz_datahub.api.models.wanco.WancoTokenResponse;
import com.wydot.wz_datahub.api.models.wanco.sabp.WancoDeviceFeedSABP;

import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

@Slf4j
@Service
public class WancoDeviceFeedApi {

    private static final int DEFAULT_RATE_LIMIT_DELAY_SECONDS = 1;
    private static final int MAX_RATE_LIMIT_RETRIES = 10;

    private final WebClient webClient;
    private final ObjectMapper objectMapper;
    private final RawDataRepository rawDataRepository;
    private final WancoIngestProperties props;

    public WancoDeviceFeedApi(
            ObjectMapper objectMapper,
            WancoIngestProperties props,
            RawDataRepository rawDataRepository) {
        this.objectMapper = objectMapper;
        this.rawDataRepository = rawDataRepository;
        this.props = props;
        this.webClient = WebClient.builder()
                .baseUrl(props.getUrl())
                .build();
    }

    @Async
    public Mono<WancoDeviceFeedWZDx42> retrieveAsync(String token, String continueUrl) {
        String url = continueUrl == null
                ? props.getUrl() + "/2021-12-31/wzdx/devices"
                : continueUrl;
        WebClient deviceFeedClient = WebClient.builder().baseUrl(url).build();

        return fetchWithRateLimitRetry(deviceFeedClient, token, url, 0)
                .map(json -> {
                    try {
                        log.trace("Received Wanco Device Feed JSON: {}", json);
                        return objectMapper.readValue(json, WancoDeviceFeedWZDx42.class);
                    } catch (Exception e) {
                        log.error("Failed to parse Wanco Device Feed JSON: {}", json, e);
                        throw new CompletionException("Failed to parse Wanco Device Feed JSON", e);
                    } finally {
                        RawDataWrapper rawMessage = new RawDataWrapper(System.currentTimeMillis(), RawDataType.WANCO,
                                json);

                        // Asynchronously log raw data, errors are logged but do not interrupt
                        // processing
                        Mono.fromRunnable(() -> rawDataRepository.insert(rawMessage))
                                .doOnError(
                                        ex -> System.err
                                                .println("Failed to insert raw Wanco data: " + ex.getMessage()))
                                .subscribe();
                    }
                });
    }

    private Mono<String> fetchWithRateLimitRetry(WebClient deviceFeedClient, String token, String url, int attempt) {
        return deviceFeedClient.get()
                .headers(headers -> {
                    headers.set(HttpHeaders.AUTHORIZATION, "Bearer " + token);
                })
                .exchangeToMono(response -> {
                    if (response.statusCode().is2xxSuccessful()) {
                        return response.bodyToMono(String.class);
                    }

                    int statusCode = response.statusCode().value();
                    return response.bodyToMono(String.class)
                            .defaultIfEmpty("")
                            .flatMap(body -> {
                                if ((statusCode == 429) && attempt < MAX_RATE_LIMIT_RETRIES) {
                                    long delaySeconds = extractRateLimitDelaySeconds(body);
                                    log.warn(
                                            "Wanco device feed rate-limited (HTTP {}). Retrying in {} seconds (attempt {}/{}). URL: {}",
                                            statusCode,
                                            delaySeconds,
                                            attempt + 1,
                                            MAX_RATE_LIMIT_RETRIES,
                                            url);
                                    return Mono.delay(Duration.ofSeconds(delaySeconds))
                                            .then(fetchWithRateLimitRetry(deviceFeedClient, token, url, attempt + 1));
                                }

                                return Mono.error(new CompletionException(
                                        "Failed to retrieve Wanco Device Feed. HTTP status: " + statusCode
                                                + ", body: " + body,
                                        null));
                            });
                });
    }

    private long extractRateLimitDelaySeconds(String body) {
        try {
            JsonNode root = objectMapper.readTree(body);
            long delay = root.path("error").path("delay").asLong(DEFAULT_RATE_LIMIT_DELAY_SECONDS);
            return Math.max(delay, DEFAULT_RATE_LIMIT_DELAY_SECONDS);
        } catch (Exception ex) {
            log.warn("Unable to parse rate-limit delay from response body; using default delay.", ex);
            return DEFAULT_RATE_LIMIT_DELAY_SECONDS;
        }
    }

    @Async
    public Mono<WancoDeviceFeedSABP> retrieveSabpAsync(String token, String continueUrl) {
        String url = continueUrl == null
                ? props.getUrl() + "/2021-12-31/devices/arrowBoards?format=SABP"
                : continueUrl;
        WebClient deviceFeedClient = WebClient.builder().baseUrl(url).build();

        return deviceFeedClient.get()
                .headers(headers -> {
                    headers.set(HttpHeaders.AUTHORIZATION, "Bearer " + token);
                })
                .retrieve()
                .bodyToMono(String.class) // raw JSON first
                .map(json -> {
                    try {
                        log.trace("Received Wanco SABP Feed JSON: {}", json);
                        return objectMapper.readValue(json, WancoDeviceFeedSABP.class);
                    } catch (Exception e) {
                        log.error("Failed to parse Wanco SABP Feed JSON: {}", json, e);
                        throw new CompletionException("Failed to parse Wanco SABP Feed JSON", e);
                    } finally {
                        RawDataWrapper rawMessage = new RawDataWrapper(System.currentTimeMillis(), RawDataType.WANCO,
                                json);

                        // Asynchronously log raw data, errors are logged but do not interrupt
                        // processing
                        Mono.fromRunnable(() -> rawDataRepository.insert(rawMessage))
                                .doOnError(
                                        ex -> System.err
                                                .println("Failed to insert raw Wanco data: " + ex.getMessage()))
                                .subscribe();
                    }
                });
    }

    @Async
    public Mono<WancoTokenResponse> generateAccessToken(String token) {
        return webClient.get()
                .uri("/2021-12-31/token")
                .headers(headers -> {
                    headers.set(HttpHeaders.AUTHORIZATION, "Bearer " + token);
                })
                .retrieve()
                .bodyToMono(WancoTokenResponse.class);
    }
}
