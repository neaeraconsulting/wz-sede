package com.wydot.message_generator.sdx;

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;

import com.wydot.message_generator.models.wz.cwz.CwzFeed;

import reactor.core.publisher.Mono;

@Component
@ConditionalOnProperty(name = "sdx.enabled", havingValue = "true", matchIfMissing = false)
public class SdxApi implements SdxApiService {
    private final String accessToken;
    private final WebClient webClient;

    public SdxApi(SdxProperties sdxProperties, WebClient.Builder webClientBuilder) {
        this.accessToken = sdxProperties.getAccessToken();
        this.webClient = webClientBuilder.baseUrl(sdxProperties.getEndpoint()).build();
    }

    public Mono<CwzFeed> getWorkZoneFeed() {
        return webClient.get()
                .header("apikey", accessToken)
                .retrieve()
                .bodyToMono(CwzFeed.class);
    }

    public Mono<String> depositWorkZone(CwzFeed workZoneFeed) {
        return webClient.post()
                .uri("/api/wz/post-individual-message")
                .header("apikey", accessToken)
                .bodyValue(workZoneFeed)
                .exchangeToMono(response -> {
                    if (response.statusCode().is2xxSuccessful()) {
                        return response.bodyToMono(String.class).map(this::processRecordId);
                    } else {
                        return response.bodyToMono(String.class)
                                .flatMap(body -> Mono.error(new RuntimeException(
                                        "Failed to deposit CWZ Feed: " + body)));
                    }
                });
    }

    public Mono<Void> updateWorkZone(String recordId, CwzFeed workZoneFeed) {
        return webClient.put()
                .uri("/api/wz/{recordId}", recordId)
                .header("apikey", accessToken)
                .bodyValue(workZoneFeed)
                .retrieve()
                .bodyToMono(Void.class);
    }

    public Mono<Void> deleteWorkZone(String recordId) {
        return webClient.delete()
                .uri("/api/wz/{recordId}", recordId)
                .header("apikey", accessToken)
                .retrieve()
                .bodyToMono(Void.class);
    }

    public String processRecordId(String recordId) {
        // Example response body: '{"id":"fb363735-3622-455e-8376-a92fdfed12da"}'
        return recordId.trim().replace("{\"id\":\"", "").replace("\"}", "");
    }
}
