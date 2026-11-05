package com.wydot.wz_datahub.api.utilities.gis_service.colorado;

import lombok.extern.slf4j.Slf4j;

import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.ExchangeStrategies;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.server.ResponseStatusException;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.type.LatLng;
import com.wydot.wz_datahub.api.models.gis_service.colorado.responses.measure_at_point.MeasureAtPointResponse;
import com.wydot.wz_datahub.api.models.gis_service.colorado.responses.point_at_measure.PointAtMeasureResponse;
import com.wydot.wz_datahub.api.models.gis_service.colorado.responses.route_between_measures.RouteBetweenMeasuresResponse;

import reactor.core.publisher.Mono;

@Slf4j
@Component
public class GisApiColorado {
    private final WebClient webClient;
    final ObjectMapper mapper;

    GisApiColorado(GisServicePropertiesColorado props, WebClient.Builder webClientBuilder) {
        ExchangeStrategies strategies = ExchangeStrategies.builder()
                .codecs(configurer -> configurer
                        .defaultCodecs()
                        .maxInMemorySize(16 * 1024 * 1024)) // optional: increase buffer size
                .codecs(configurer -> configurer
                        .customCodecs()
                        .register(new org.springframework.http.codec.json.Jackson2JsonDecoder(
                                new com.fasterxml.jackson.databind.ObjectMapper(),
                                MediaType.TEXT_PLAIN, MediaType.APPLICATION_JSON)))
                .build();
        this.mapper = new ObjectMapper();
        this.webClient = webClientBuilder.baseUrl(props.getEndpoint()).exchangeStrategies(strategies).build();
    }

    public Mono<MeasureAtPointResponse> measureAtPoint(LatLng point, int tolerance) {
        return webClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/MeasureAtPoint")
                        .queryParam("x", point.getLongitude())
                        .queryParam("y", point.getLatitude())
                        .queryParam("tolerance", tolerance)
                        .queryParam("inSR", 4326)
                        .queryParam("f", "json")
                        .build())
                .exchangeToMono(response -> {
                    if (!response.statusCode().is2xxSuccessful()) {
                        return response.bodyToMono(String.class)
                                .doOnNext(body -> log.error("HTTP error: {}", body))
                                .flatMap(body -> Mono.error(new ResponseStatusException(response.statusCode(),
                                        "Failed to get measure from geometry: " + body)));
                    }

                    // Read body as String once, then parse it
                    return response.bodyToMono(String.class)
                            .flatMap(body -> {
                                try {
                                    // Check for error in JSON
                                    if (mapper.readTree(body).has("error")) {
                                        log.error("GIS API returned error: {}", body);
                                        return Mono.empty();
                                    }

                                    // Parse to response object
                                    MeasureAtPointResponse parsedResponse = mapper.readValue(body,
                                            MeasureAtPointResponse.class);
                                    return Mono.just(parsedResponse);

                                } catch (JsonProcessingException e) {
                                    log.error("Failed to parse response body: {}", body, e);
                                    return Mono.error(new ResponseStatusException(response.statusCode(),
                                            "Failed to get measure from geometry: " + body));
                                }
                            });
                });
    }

    public Mono<PointAtMeasureResponse> pointAtMeasure(String routeId, double measure) {
        return webClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/PointAtMeasure")
                        .queryParam("routeId", routeId)
                        .queryParam("measure", measure)
                        .queryParam("outSR", 4326)
                        .queryParam("f", "json")
                        .build())
                .exchangeToMono(response -> {
                    if (!response.statusCode().is2xxSuccessful()) {
                        return response.bodyToMono(String.class)
                                .doOnNext(body -> log.error("HTTP error: {}", body))
                                .flatMap(body -> Mono.error(new ResponseStatusException(response.statusCode(),
                                        "Failed to get geometry at measure: " + body)));
                    }

                    // Read body as String once, then parse it
                    return response.bodyToMono(String.class)
                            .flatMap(body -> {
                                try {
                                    // Check for error in JSON
                                    if (mapper.readTree(body).has("error")) {
                                        log.error("GIS API returned error: {}", body);
                                        return Mono.empty();
                                    }

                                    // Parse to response object
                                    PointAtMeasureResponse parsedResponse = mapper.readValue(body,
                                            PointAtMeasureResponse.class);
                                    return Mono.just(parsedResponse);

                                } catch (JsonProcessingException e) {
                                    log.error("Failed to parse response body: {}", body, e);
                                    return Mono.error(new ResponseStatusException(response.statusCode(),
                                            "Failed to get geometry at measure: " + body));
                                }
                            });
                });
    }

    public Mono<RouteBetweenMeasuresResponse> routeBetweenMeasures(String routeId, double fromMeasure,
            double toMeasure) {
        return webClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/RouteBetweenMeasures")
                        .queryParam("routeId", routeId)
                        .queryParam("fromMeasure", fromMeasure)
                        .queryParam("toMeasure", toMeasure)
                        .queryParam("outSR", 4326)
                        .queryParam("f", "json")
                        .build())
                .exchangeToMono(response -> {
                    if (!response.statusCode().is2xxSuccessful()) {
                        return response.bodyToMono(String.class)
                                .doOnNext(body -> log.error("HTTP error: {}", body))
                                .flatMap(body -> Mono.error(new ResponseStatusException(response.statusCode(),
                                        "Failed to get route between measures: " + body)));
                    }

                    // Read body as String once, then parse it
                    return response.bodyToMono(String.class)
                            .flatMap(body -> {
                                try {
                                    // Check for error in JSON
                                    if (mapper.readTree(body).has("error")) {
                                        log.error("GIS API returned error: {}", body);
                                        return Mono.empty();
                                    }

                                    // Parse to response object
                                    RouteBetweenMeasuresResponse parsedResponse = mapper.readValue(body,
                                            RouteBetweenMeasuresResponse.class);
                                    return Mono.just(parsedResponse);

                                } catch (JsonProcessingException e) {
                                    log.error("Failed to parse response body: {}", body, e);
                                    return Mono.error(new ResponseStatusException(response.statusCode(),
                                            "Failed to get route between measures: " + body));
                                }
                            });
                });
    }
}
