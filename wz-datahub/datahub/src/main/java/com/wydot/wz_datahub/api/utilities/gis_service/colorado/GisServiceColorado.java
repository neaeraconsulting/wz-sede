package com.wydot.wz_datahub.api.utilities.gis_service.colorado;

import java.util.List;

import org.springframework.stereotype.Component;

import com.google.type.LatLng;
import com.wydot.wz_datahub.api.models.gis_service.LatLngAndMilepost;
import com.wydot.wz_datahub.api.models.gis_service.RouteAndMeasure;
import com.wydot.wz_datahub.api.models.gis_service.RouteAndMeasureRange;
import com.wydot.wz_datahub.api.models.gis_service.colorado.responses.PointAttributes;
import com.wydot.wz_datahub.api.models.gis_service.colorado.responses.measure_at_point.MeasureAtPointResponse;
import com.wydot.wz_datahub.api.models.gis_service.colorado.responses.route_between_measures.RouteBetweenMeasuresResponse;
import com.wydot.wz_datahub.api.models.gis_service.colorado.responses.point_at_measure.PointAtMeasureResponse;
import com.wydot.wz_datahub.api.models.gis_service.colorado.responses.PointGeometry;
import com.wydot.wz_datahub.api.update_processors.UpdateProcessorProperties;

import reactor.core.publisher.Mono;
import wyo.dot.protobuf.FieldDevice;

@Component
public class GisServiceColorado {
    private final GisApiColorado gisApi;
    private final UpdateProcessorProperties properties;
    
    private final int GEOMETRY_INDEX_LONGITUDE = 0;
    private final int GEOMETRY_INDEX_LATITUDE = 1;

    GisServiceColorado(GisApiColorado gisApi, UpdateProcessorProperties properties) {
        this.gisApi = gisApi;
        this.properties = properties;
    }

    public Mono<RouteAndMeasure> getClosestRouteAndMeasureForDevice(FieldDevice device) {
        int roadwayDistance = properties.getMaxRoadwayDistanceMeters().intValue();

        // Use the GisService to check if the device is on a roadway
        return getClosestRouteAndMeasure(
                device.getGeometry().getCoordinates(), roadwayDistance);
    }

    public Mono<RouteAndMeasure> getClosestRouteAndMeasure(LatLng point, int tolerance) {
        return gisApi.measureAtPoint(point, tolerance).map((MeasureAtPointResponse response) -> {
            if (response == null || response.getFeatures().isEmpty()
                    || response.getFeatures().getFirst().getAttributes() == null) {
                return null;
            }
            PointAttributes closestResult = response.getFeatures().getFirst().getAttributes();
            RouteAndMeasure route = new RouteAndMeasure(closestResult.getRoute(), closestResult.getRoute(),
                    closestResult.getMeasure(), closestResult.getMeasure());
            return route; 
        }).doOnError(error -> Mono.empty());
    }

    public Mono<RouteAndMeasure> getExpectedRouteAndMeasure(LatLng point, int tolerance,
            String expectedRouteId) {
        return getClosestRouteAndMeasure(point, tolerance).flatMap(routeAndMeasure -> {
            if (routeAndMeasure == null) {
                return Mono.empty();
            }
            if (routeAndMeasure.getRouteId().equals(expectedRouteId)) {
                return Mono.just(routeAndMeasure);
            } else {
                return Mono.empty();
            }
        }).doOnError(error -> Mono.empty());
    }

    public Mono<RouteAndMeasureRange> getMatchingRouteAndMeasure(LatLng point1, LatLng point2, int tolerance) {
        return Mono.zip(
                gisApi.measureAtPoint(point1, tolerance),
                gisApi.measureAtPoint(point2, tolerance)).map(tuple -> {
                    MeasureAtPointResponse response1 = tuple.getT1();
                    MeasureAtPointResponse response2 = tuple.getT2();

                    // Validate responses
                    if (response1 == null || response1.getFeatures().isEmpty()
                            || response1.getFeatures().getFirst().getAttributes() == null) {
                        return null;
                    }
                    if (response2 == null || response2.getFeatures().isEmpty()
                            || response2.getFeatures().getFirst().getAttributes() == null) {
                        return null;
                    }

                    PointAttributes a1 = response1.getFeatures().getFirst().getAttributes();
                    PointAttributes a2 = response2.getFeatures().getFirst().getAttributes();

                    if (a1.getRoute().equals(a2.getRoute())) {
                        return new RouteAndMeasureRange(a1.getRoute(), a1.getRoute(), a1.getMeasure(), a1.getMeasure(), a2.getMeasure(), a2.getMeasure());
                    } else {
                        return null;
                    }
                }).doOnError(error -> Mono.empty());
    }

    public Mono<RouteAndMeasure> translateMeasure(RouteAndMeasure route) {
        if (route.getTranslatedMeasure() == null) {
            return Mono.just(new RouteAndMeasure(route.getRouteId(), route.getRouteId(), route.getMeasure(),
                    route.getMeasure()));
        }
        return Mono.just(route);
    }

    public Mono<List<LatLng>> getRouteGeometry(RouteAndMeasureRange range) {
        return gisApi
                .routeBetweenMeasures(range.getRouteId(), range.getTranslatedStartMeasure(),
                        range.getTranslatedEndMeasure())
                .map((RouteBetweenMeasuresResponse response) -> {
                    if (response == null || response.getFeatures().isEmpty()
                            || response.getFeatures().getFirst().getGeometry() == null) {
                        return List.of();
                    }
                    return response.getFeatures().getFirst().getGeometry().getPaths().getFirst().stream()
                            .map((List<Double> point) -> LatLng.newBuilder()
                                    .setLongitude(point.get(GEOMETRY_INDEX_LONGITUDE))
                                    .setLatitude(point.get(GEOMETRY_INDEX_LATITUDE))
                                    .build())
                            .toList();
                });
    }

    public Mono<List<LatLngAndMilepost>> getRouteGeometryWithMeasures(RouteAndMeasureRange range) {
        return gisApi
                .routeBetweenMeasures(range.getRouteId(), range.getStartMeasure(),
                        range.getEndMeasure())
                .flatMap((RouteBetweenMeasuresResponse response) -> {
                    if (response == null || response.getFeatures().isEmpty()
                            || response.getFeatures().getFirst().getGeometry() == null) {
                        return Mono.just(List.of());
                    }
                    List<List<Double>> points = response.getFeatures().getFirst().getGeometry().getPaths().getFirst();

                                    int numPoints = points.size();
                    double measureIncrement = (range.getEndMeasure() - range.getStartMeasure()) / (numPoints - 1);
                                    return Mono.just(points.stream()
                                        .map((List<Double> point) -> new LatLngAndMilepost(
                                                LatLng.newBuilder().setLongitude(point.get(GEOMETRY_INDEX_LONGITUDE))
                                                        .setLatitude(point.get(GEOMETRY_INDEX_LATITUDE)).build(),
                                    range.getStartMeasure() + measureIncrement * points.indexOf(point)))
                            .toList());
                });
    }

    public Mono<LatLng> getGeometryAtMeasure(RouteAndMeasure measure) {
        return gisApi
                .pointAtMeasure(measure.getRouteId(), measure.getMeasure())
                .map((PointAtMeasureResponse response) -> {
                    if (response == null || response.getFeatures().isEmpty()
                            || response.getFeatures().getFirst().getGeometry() == null) {
                        return null;
                    }
                    PointGeometry geometry = response.getFeatures().getFirst().getGeometry();
                    return LatLng.newBuilder()
                            .setLongitude(geometry.getX())
                            .setLatitude(geometry.getY())
                            .build();
                });
    }
}
