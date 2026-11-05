package com.wydot.wz_datahub.api.utilities.gis_service;

import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.google.type.LatLng;
import com.wydot.wz_datahub.api.models.gis_service.LatLngAndMilepost;
import com.wydot.wz_datahub.api.models.gis_service.RouteAndMeasure;
import com.wydot.wz_datahub.api.models.gis_service.RouteAndMeasureRange;
import com.wydot.wz_datahub.api.models.gis_service.responses.geometry_to_measure.GeometryToMeasureResponse;
import com.wydot.wz_datahub.api.models.gis_service.responses.geometry_to_measure.Result;
import com.wydot.wz_datahub.api.models.gis_service.responses.measure_to_geometry.Geometry;
import com.wydot.wz_datahub.api.models.gis_service.responses.measure_to_geometry.MeasureToGeometryResponse;
import com.wydot.wz_datahub.api.models.gis_service.responses.query.QueryResponse;
import com.wydot.wz_datahub.api.models.gis_service.responses.translate.TranslateResponse;
import com.wydot.wz_datahub.api.models.gis_service.responses.translate.TranslatedLocation;
import com.wydot.wz_datahub.api.update_processors.UpdateProcessorProperties;

import kotlin.Pair;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import wyo.dot.protobuf.FieldDevice;

@Slf4j
@Component
public class GisServiceWyoming {
    private final GisApiWyoming gisApi;
    private final UpdateProcessorProperties properties;

    private final int GEOMETRY_INDEX_LONGITUDE = 0;
    private final int GEOMETRY_INDEX_LATITUDE = 1;
    // Index 2 is something else, almost always 0 or 1e-9
    private final int GEOMETRY_INDEX_MEASURE = 3;

    GisServiceWyoming(GisApiWyoming gisApi, UpdateProcessorProperties properties) {
        this.gisApi = gisApi;
        this.properties = properties;
    }

    public Mono<RouteAndMeasure> getClosestRouteAndMeasureForDevice(FieldDevice device) {
        int roadwayDistance = properties.getMaxRoadwayDistanceMeters().intValue();

        // Use the GisService to check if the device is on a roadway
        return getClosestRouteAndMeasure(
                device.getGeometry().getCoordinates(), roadwayDistance).doOnError(error -> Mono.empty());
    }

    public Mono<RouteAndMeasure> getClosestRouteAndMeasure(LatLng point, int tolerance) {
        return gisApi.geometryToMeasure(point, tolerance).flatMap((GeometryToMeasureResponse response) -> {
            if (response == null || response.getLocations().isEmpty()
                    || response.getLocations().getFirst().getResults().isEmpty()) {
                return Mono.empty();
            }
            Result closestResult = response.getLocations().getFirst().getResults().getLast();
            RouteAndMeasure route = new RouteAndMeasure(closestResult.getRouteId(), null,
                    closestResult.getMeasure(), null);
            return translateMeasure(route);
        }).doOnError(error -> Mono.empty());
    }

    public Mono<RouteAndMeasure> getExpectedRouteAndMeasure(LatLng point, int tolerance,
            String expectedRouteId) {
        return gisApi.geometryToMeasure(point, tolerance).flatMap((GeometryToMeasureResponse response) -> {
            if (response == null || response.getLocations().isEmpty()
                    || response.getLocations().getFirst().getResults().isEmpty()) {
                return Mono.empty();
            }
            Result closestResult = response.getLocations().getFirst().getResults().stream()
                    .filter(result -> result.getRouteId().equals(expectedRouteId))
                    .findFirst()
                    .orElse(null);
            if (closestResult == null) {
                return Mono.empty(); // No result found for the expected route ID
            }
            RouteAndMeasure route = new RouteAndMeasure(closestResult.getRouteId(), null,
                    closestResult.getMeasure(), null);
            return translateMeasure(route);
        }).doOnError(error -> Mono.empty());
    }

    public Mono<RouteAndMeasureRange> getMatchingRouteAndMeasure(LatLng point1, LatLng point2, int tolerance) {
        return Mono.zip(
                gisApi.geometryToMeasure(point1, tolerance),
                gisApi.geometryToMeasure(point2, tolerance)).flatMap(tuple -> {
                    GeometryToMeasureResponse response1 = tuple.getT1();
                    GeometryToMeasureResponse response2 = tuple.getT2();

                    // Validate responses
                    if (response1 == null || response1.getLocations().isEmpty()
                            || response1.getLocations().getFirst().getResults().isEmpty()) {
                        return Mono.empty();
                    }
                    if (response2 == null || response2.getLocations().isEmpty()
                            || response2.getLocations().getFirst().getResults().isEmpty()) {
                        return Mono.empty();
                    }

                    // Record all entries in map
                    Map<String, Pair<Double, RouteAndMeasure>> matchingRouteMap1 = new HashMap<>();
                    for (Result result : response1.getLocations().getFirst().getResults()) {
                        matchingRouteMap1.put(result.getRouteId(), new Pair<>(result.getDistance(),
                                new RouteAndMeasure(result.getRouteId(), null, result.getMeasure(), null)));
                    }

                    // Find the closest matching route
                    return Flux.fromIterable(response2.getLocations().getFirst().getResults())
                            .filter(result -> matchingRouteMap1.containsKey(result.getRouteId()))
                            .flatMap(result -> {
                                double totalDistance = matchingRouteMap1.get(result.getRouteId()).getFirst()
                                        + result.getDistance();
                                RouteAndMeasure route1 = matchingRouteMap1.get(result.getRouteId()).getSecond();
                                RouteAndMeasure route2 = new RouteAndMeasure(result.getRouteId(), null,
                                        result.getMeasure(),
                                        null);

                                // Translate measures and create RouteAndMeasureRange
                                return Mono.zip(
                                        translateMeasure(route1),
                                        translateMeasure(route2)).map(translated -> {
                                            RouteAndMeasure translatedRoute1 = translated.getT1();
                                            RouteAndMeasure translatedRoute2 = translated.getT2();
                                            return new Pair<>(totalDistance,
                                                    RouteAndMeasureRange.fromMeasures(translatedRoute1,
                                                            translatedRoute2));
                                        });
                            })
                            .sort(Comparator.comparingDouble(Pair::getFirst)) // Sort by total distance
                            .next() // Take the closest match
                            .map(Pair::getSecond); // Extract the RouteAndMeasureRange
                }).doOnError(error -> Mono.empty());
    }

    public Mono<RouteAndMeasure> translateMeasure(RouteAndMeasure route) {
        return gisApi.translate(route.getRouteId(), route.getMeasure()).flatMap((TranslateResponse response) -> {
            if (response == null) {
                return Mono.empty();
            }

            else if (response.getLocations().getFirst().getTranslatedLocations().isEmpty()) {
                log.warn("No translated locations found for route ID: {} and measure: {}",
                        route.getRouteId(), route.getMeasure());
                return Mono.just(new RouteAndMeasure(route.getRouteId(), route.getRouteId(), route.getMeasure(),
                        route.getMeasure()));
            }
            TranslatedLocation translatedLocation = response.getLocations().getFirst().getTranslatedLocations()
                    .getFirst();
            return Mono
                    .just(new RouteAndMeasure(route.getRouteId(), translatedLocation.getRouteId(), route.getMeasure(),
                            translatedLocation.getMeasure()));
        }).doOnError(error -> Mono.empty());
    }

    public Mono<List<LatLng>> getRouteGeometry(RouteAndMeasureRange range) {
        return gisApi
                .measureToGeometryRange(range.getRouteId(), range.getTranslatedStartMeasure(),
                        range.getTranslatedEndMeasure())
                .map((MeasureToGeometryResponse response) -> {
                    if (response == null || response.getLocations().isEmpty()
                            || response.getLocations().getFirst().getGeometry() == null) {
                        return List.of();
                    }
                    return response.getLocations().getFirst().getGeometry().getPaths().getFirst().stream()
                            .map((List<Double> point) -> LatLng.newBuilder()
                                    .setLongitude(point.get(GEOMETRY_INDEX_LONGITUDE))
                                    .setLatitude(point.get(GEOMETRY_INDEX_LATITUDE))
                                    .build())
                            .toList();
                });
    }

    public Mono<List<LatLngAndMilepost>> getRouteGeometryWithMeasures(RouteAndMeasureRange range) {
        return gisApi
                .measureToGeometryRange(range.getRouteId(), range.getStartMeasure(),
                        range.getEndMeasure())
                .map((MeasureToGeometryResponse response) -> {
                    if (response == null || response.getLocations().isEmpty()
                            || response.getLocations().getFirst().getGeometry() == null) {
                        return List.of();
                    }
                    return response.getLocations().getFirst().getGeometry().getPaths().getFirst().stream()
                            .map((List<Double> point) -> new LatLngAndMilepost(
                                    LatLng.newBuilder().setLongitude(point.get(GEOMETRY_INDEX_LONGITUDE))
                                            .setLatitude(point.get(GEOMETRY_INDEX_LATITUDE)).build(),
                                    point.get(GEOMETRY_INDEX_MEASURE)))
                            .toList();
                });
    }

    public Mono<LatLng> getGeometryAtMeasure(RouteAndMeasure measure) {
        return gisApi
                .measureToGeometry(measure.getRouteId(), measure.getMeasure())
                .flatMap((MeasureToGeometryResponse response) -> {
                    if (response == null || response.getLocations().isEmpty()
                            || response.getLocations().getFirst().getGeometry() == null) {
                        return Mono.empty();
                    }
                    Geometry geometry = response.getLocations().getFirst().getGeometry();
                    return Mono.just(LatLng.newBuilder()
                            .setLongitude(geometry.getX())
                            .setLatitude(geometry.getY())
                            .build());
                });
    }

    public Mono<String> getRoadName(RouteAndMeasureRange range) {
        return gisApi.queryFeatures(range.getRouteId(), range.getStartMeasure(), range.getEndMeasure())
                .flatMap((QueryResponse response) -> {
                    if (response == null || response.getFeatures().isEmpty()) {
                        return Mono.empty();
                    }
                    return Mono.just(response.getFeatures().getFirst().getAttributes().getFullName());
                });
    }

    public Mono<String> getRoadName(RouteAndMeasure measure) {
        return gisApi.queryFeatures(measure.getRouteId(), measure.getMeasure(), measure.getMeasure())
                .flatMap((QueryResponse response) -> {
                    if (response == null || response.getFeatures().isEmpty()) {
                        return Mono.empty();
                    }
                    return Mono.just(response.getFeatures().getFirst().getAttributes().getFullName());
                });
    }
}
