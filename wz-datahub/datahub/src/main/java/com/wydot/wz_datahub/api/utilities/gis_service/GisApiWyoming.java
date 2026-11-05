package com.wydot.wz_datahub.api.utilities.gis_service;

import java.util.List;
import lombok.extern.slf4j.Slf4j;

import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.ExchangeStrategies;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.server.ResponseStatusException;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.type.LatLng;
import com.wydot.wz_datahub.api.models.gis_service.GisLocationGeometry;
import com.wydot.wz_datahub.api.models.gis_service.GisLocationGeometryPoint;
import com.wydot.wz_datahub.api.models.gis_service.GisLocationRouteFromTo;
import com.wydot.wz_datahub.api.models.gis_service.GisLocationRouteMeasure;
import com.wydot.wz_datahub.api.models.gis_service.GisRouteQuery;
import com.wydot.wz_datahub.api.models.gis_service.responses.geometry_to_measure.GeometryToMeasureResponse;
import com.wydot.wz_datahub.api.models.gis_service.responses.measure_to_geometry.MeasureToGeometryResponse;
import com.wydot.wz_datahub.api.models.gis_service.responses.query.QueryResponse;
import com.wydot.wz_datahub.api.models.gis_service.responses.query_attribute_set.QueryAttributeSetResponse;
import com.wydot.wz_datahub.api.models.gis_service.responses.translate.TranslateResponse;

import reactor.core.publisher.Mono;

@Slf4j
@Component
public class GisApiWyoming {
    private final WebClient webClient;
    final ObjectMapper mapper;

    GisApiWyoming(GisServiceProperties props, WebClient.Builder webClientBuilder) {
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

    // Geometry to measure
    // - locations=[{"geometry": {"x": -105.4901012, "y": 41.2720173}}]
    // - tolerance=200
    // - inSR=4326
    // - f=pjson
    public Mono<GeometryToMeasureResponse> geometryToMeasure(LatLng point, int tolerance) {
        List<GisLocationGeometry> locations = List.of(new GisLocationGeometry(
                new GisLocationGeometryPoint(point.getLongitude(), point.getLatitude())));
        String locationString;
        try {
            locationString = mapper.writeValueAsString(locations);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            return Mono.empty();
        }
        return webClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/MapServer/exts/LRServer/networkLayers/3/geometryToMeasure")
                        .queryParam("locations", "{location}")
                        .queryParam("tolerance", tolerance)
                        .queryParam("inSR", 4326)
                        .queryParam("f", "json")
                        .build(locationString))
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
                                    GeometryToMeasureResponse parsedResponse = mapper.readValue(body,
                                            GeometryToMeasureResponse.class);
                                    return Mono.just(parsedResponse);

                                } catch (JsonProcessingException e) {
                                    log.error("Failed to parse response body: {}", body, e);
                                    return Mono.error(new ResponseStatusException(response.statusCode(),
                                            "Failed to get measure from geometry: " + body));
                                }
                            });
                });
    }

    // Attribute Set
    // - locations=[{"routeId": "ML80D", "fromFeature": 318.92783801617138,
    // "toMeasure": 319.109999584404}]
    // - attributeSet=[{"layerId": 6, "fields":
    // ["full_name","prefix_type","suffix_type"]}]
    // - outSR=4326
    // - f=pjson
    public Mono<QueryAttributeSetResponse> queryAttributeSet(String routeId, double fromMeasure, double toMeasure) {
        List<GisLocationRouteFromTo> locations = List.of(new GisLocationRouteFromTo(routeId, fromMeasure, toMeasure));
        String locationString;
        try {
            locationString = mapper.writeValueAsString(locations);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            return Mono.empty();
        }
        String attributeSetString = "[{\"layerId\": 6, \"fields\": [\"full_name\",\"prefix_type\",\"suffix_type\"]}]";
        return webClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/MapServer/exts/LRServer/networkLayers/3/queryAttributeSet")
                        .queryParam("locations", "{location}")
                        .queryParam("attributeSet", "{attributeSet}")
                        .queryParam("outSR", 4326)
                        .queryParam("f", "json")
                        .build(locationString, attributeSetString))
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
                                    QueryAttributeSetResponse parsedResponse = mapper.readValue(body,
                                            QueryAttributeSetResponse.class);
                                    return Mono.just(parsedResponse);

                                } catch (JsonProcessingException e) {
                                    log.error("Failed to parse response body: {}", body, e);
                                    return Mono.error(new ResponseStatusException(response.statusCode(),
                                            "Failed to get measure from geometry: " + body));
                                }
                            });
                });
    }

    // Translate
    // - locations=[{"routeId": "ML80D", "measure": 319.109999584404}]
    // - targetNetworkLayerIds=[5]
    // - f=pjson
    public Mono<TranslateResponse> translate(String routeId, double measure) {
        List<GisLocationRouteMeasure> locations = List.of(new GisLocationRouteMeasure(routeId, measure));
        String locationString;
        try {
            locationString = mapper.writeValueAsString(locations);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            return Mono.empty();
        }
        return webClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/MapServer/exts/LRServer/networkLayers/3/translate")
                        .queryParam("locations", "{location}")
                        .queryParam("targetNetworkLayerIds", "[5]")
                        .queryParam("f", "json")
                        .build(locationString))
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
                                    TranslateResponse parsedResponse = mapper.readValue(body,
                                            TranslateResponse.class);
                                    return Mono.just(parsedResponse);

                                } catch (JsonProcessingException e) {
                                    log.error("Failed to parse response body: {}", body, e);
                                    return Mono.error(new ResponseStatusException(response.statusCode(),
                                            "Failed to get measure from geometry: " + body));
                                }
                            });
                });
    }

    // Measure To Geometry
    // - locations=[{"routeId": "ML80D", "fromFeature": 318.92783801617138,
    // "toMeasure": 319.109999584404}]
    // - outSR=4326
    // - f=pjson
    public Mono<MeasureToGeometryResponse> measureToGeometry(String routeId, double measure) {
        List<GisLocationRouteMeasure> locations = List.of(new GisLocationRouteMeasure(routeId, measure));
        String locationString;
        try {
            locationString = mapper.writeValueAsString(locations);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            return Mono.empty();
        }
        return webClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/MapServer/exts/LRServer/networkLayers/3/measureToGeometry")
                        .queryParam("locations", "{location}")
                        .queryParam("outSR", 4326)
                        .queryParam("f", "json")
                        .build(locationString))
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
                                    MeasureToGeometryResponse parsedResponse = mapper.readValue(body,
                                            MeasureToGeometryResponse.class);
                                    return Mono.just(parsedResponse);

                                } catch (JsonProcessingException e) {
                                    log.error("Failed to parse response body: {}", body, e);
                                    return Mono.error(new ResponseStatusException(response.statusCode(),
                                            "Failed to get measure from geometry: " + body));
                                }
                            });
                });
    }

    // Measure To Geometry
    // - locations=[{"routeId": "ML80D", "fromFeature": 318.92783801617138,
    // "toMeasure": 319.109999584404}]
    // - outSR=4326
    // - f=pjson
    public Mono<MeasureToGeometryResponse> measureToGeometryRange(String routeId, double fromMeasure,
            double toMeasure) {
        List<GisLocationRouteFromTo> locations = List.of(new GisLocationRouteFromTo(routeId, fromMeasure, toMeasure));
        String locationString;
        try {
            locationString = mapper.writeValueAsString(locations);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            return Mono.empty();
        }
        return webClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/MapServer/exts/LRServer/networkLayers/3/measureToGeometry")
                        .queryParam("locations", "{location}")
                        .queryParam("outSR", 4326)
                        .queryParam("f", "json")
                        .build(locationString))
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
                                    MeasureToGeometryResponse parsedResponse = mapper.readValue(body,
                                            MeasureToGeometryResponse.class);
                                    return Mono.just(parsedResponse);

                                } catch (JsonProcessingException e) {
                                    log.error("Failed to parse response body: {}", body, e);
                                    return Mono.error(new ResponseStatusException(response.statusCode(),
                                            "Failed to get measure from geometry: " + body));
                                }
                            });
                });
    }

    public Mono<QueryResponse> queryFeatures(String routeId, double fromMeasure,
            double toMeasure) {
        String where = new GisRouteQuery(routeId, fromMeasure, toMeasure).toQueryString();
        return webClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/FeatureServer/6/query")
                        .queryParam("where", "{where}")
                        .queryParam("resultRecordCount", 50)
                        .queryParam("orderByFields", "(endpoint - beginpoint) DESC")
                        .queryParam("outFields",
                                "routeid,beginpoint,endpoint,full_name,roadway_name_type,objectId")
                        .queryParam("returnM", "true")
                        .queryParam("f", "pjson")
                        .build(where))
                .exchangeToMono(response -> {
                    if (!response.statusCode().is2xxSuccessful()) {
                        return response.bodyToMono(String.class)
                                .doOnNext(body -> log.error("HTTP error: {}", body))
                                .flatMap(body -> Mono.error(new ResponseStatusException(response.statusCode(),
                                        "Failed to get road name from measures: " + body)));
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
                                    QueryResponse parsedResponse = mapper.readValue(body,
                                            QueryResponse.class);
                                    return Mono.just(parsedResponse);

                                } catch (JsonProcessingException e) {
                                    log.error("Failed to parse response body: {}", body, e);
                                    return Mono.error(new ResponseStatusException(response.statusCode(),
                                            "Failed to get road name from measures: " + body));
                                }
                            });
                });
    }
}
