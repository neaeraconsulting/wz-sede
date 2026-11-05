package com.wydot.wz_datahub.api.controllers;

import com.google.type.LatLng;
import com.wydot.wz_datahub.api.models.gis_service.LatLngAndMilepost;
import com.wydot.wz_datahub.api.models.gis_service.RouteAndMeasure;
import com.wydot.wz_datahub.api.models.gis_service.RouteAndMeasureRange;
import com.wydot.wz_datahub.api.models.gis_service.responses.geometry_to_measure.GeometryToMeasureResponse;
import com.wydot.wz_datahub.api.models.gis_service.responses.measure_to_geometry.MeasureToGeometryResponse;
import com.wydot.wz_datahub.api.models.gis_service.responses.query_attribute_set.QueryAttributeSetResponse;
import com.wydot.wz_datahub.api.models.gis_service.responses.translate.TranslateResponse;
import com.wydot.wz_datahub.api.utilities.gis_service.GisApiWyoming;
import com.wydot.wz_datahub.api.utilities.gis_service.GisService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.List;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import reactor.core.publisher.Mono;

@Slf4j
@RestController
@RequestMapping("/gis")
@RequiredArgsConstructor
public class GisController {
    private final GisApiWyoming gisApi;
    private final GisService gisService;

    @PreAuthorize("hasRole('ROLE_USER') or hasRole('ROLE_ADMIN')")
    @GetMapping("closest-route-to-measure")
    public Mono<RouteAndMeasure> getClosestRouteAndMeasure(
            @RequestParam double latitude,
            @RequestParam double longitude,
            @RequestParam(required = false, defaultValue = "1000") int tolerance) {
        LatLng latLng = LatLng.newBuilder().setLatitude(latitude).setLongitude(longitude).build();
        return gisService.getClosestRouteAndMeasure(latLng, tolerance);
    }

    @PreAuthorize("hasRole('ROLE_USER') or hasRole('ROLE_ADMIN')")
    @GetMapping("expected-route-and-measure")
    public Mono<RouteAndMeasure> getExpectedRouteAndMeasure(
            @RequestParam double latitude,
            @RequestParam double longitude,
            @RequestParam(required = false, defaultValue = "1000") int tolerance,
            @RequestParam String expectedRouteId) {
        LatLng latLng = LatLng.newBuilder().setLatitude(latitude).setLongitude(longitude).build();
        return gisService.getExpectedRouteAndMeasure(latLng, tolerance, expectedRouteId);
    }

    @PreAuthorize("hasRole('ROLE_USER') or hasRole('ROLE_ADMIN')")
    @GetMapping("matching-route-and-measure")
    public Mono<RouteAndMeasureRange> getMatchingRouteAndMeasure(
            @RequestParam double latitude1,
            @RequestParam double longitude1,
            @RequestParam double latitude2,
            @RequestParam double longitude2,
            @RequestParam(required = false, defaultValue = "1000") int tolerance) {
        LatLng latLng1 = LatLng.newBuilder().setLatitude(latitude1).setLongitude(longitude1).build();
        LatLng latLng2 = LatLng.newBuilder().setLatitude(latitude2).setLongitude(longitude2).build();
        return gisService.getMatchingRouteAndMeasure(latLng1, latLng2, tolerance);
    }

    @PreAuthorize("hasRole('ROLE_USER') or hasRole('ROLE_ADMIN')")
    @GetMapping("translate-measure")
    public Mono<RouteAndMeasure> translateMeasure(
            @RequestParam String routeId,
            @RequestParam double measure) {
        RouteAndMeasure ram = new RouteAndMeasure(routeId, null, measure, null);
        return gisService.translateMeasure(ram);
    }

    @PreAuthorize("hasRole('ROLE_USER') or hasRole('ROLE_ADMIN')")
    @GetMapping("route-geometry")
    public Mono<List<LatLng>> getRouteGeometry(
            @RequestParam String routeId,
            @RequestParam double startMeasure,
            @RequestParam double endMeasure) {
        RouteAndMeasureRange ram = new RouteAndMeasureRange(routeId, null, startMeasure, null, endMeasure, null);
        return gisService.getRouteGeometry(ram);
    }

    @PreAuthorize("hasRole('ROLE_USER') or hasRole('ROLE_ADMIN')")
    @GetMapping("route-geometry-with-measures")
    public Mono<List<LatLngAndMilepost>> getRouteGeometryWithMeasures(
            @RequestParam String routeId,
            @RequestParam double startMeasure,
            @RequestParam double endMeasure) {
        RouteAndMeasureRange ram = new RouteAndMeasureRange(routeId, null, startMeasure, null, endMeasure, null);
        return gisService.getRouteGeometryWithMeasures(ram);
    }

    @PreAuthorize("hasRole('ROLE_USER') or hasRole('ROLE_ADMIN')")
    @GetMapping("geometry-for-measure")
    public Mono<LatLng> getGeometryForMeasure(
            @RequestParam String routeId,
            @RequestParam double measure) {
        RouteAndMeasure ram = new RouteAndMeasure(routeId, null, measure, null);
        return gisService.getGeometryForMeasure(ram);
    }

    @PreAuthorize("hasRole('ROLE_USER') or hasRole('ROLE_ADMIN')")
    @GetMapping("road-name")
    public Mono<String> getRoadName(
            @RequestParam String routeId,
            @RequestParam double startMeasure,
            @RequestParam double endMeasure) {
        RouteAndMeasureRange ram = new RouteAndMeasureRange(routeId, null, startMeasure, null, endMeasure, null);
        return gisService.getRoadName(ram);
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @GetMapping("/wydot/geometryToMeasure")
    public Mono<GeometryToMeasureResponse> geometryToMeasure(
            @RequestParam double latitude,
            @RequestParam double longitude,
            @RequestParam(required = false, defaultValue = "1000") int tolerance) {
        LatLng latLng = LatLng.newBuilder().setLatitude(latitude).setLongitude(longitude).build();
        return gisApi.geometryToMeasure(latLng, tolerance);
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @GetMapping("/wydot/queryAttributeSet")
    public Mono<QueryAttributeSetResponse> queryAttributeSet(
            @RequestParam String routeId,
            @RequestParam double fromMeasure,
            @RequestParam double toMeasure) {
        return gisApi.queryAttributeSet(routeId, fromMeasure, toMeasure);
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @GetMapping("/wydot/translate")
    public Mono<TranslateResponse> translate(
            @RequestParam String routeId,
            @RequestParam double measure) {
        return gisApi.translate(routeId, measure);
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @GetMapping("/wydot/measureToGeometry")
    public Mono<MeasureToGeometryResponse> measureToGeometry(
            @RequestParam String routeId,
            @RequestParam double measure) {
        return gisApi.measureToGeometry(routeId, measure);
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @GetMapping("/wydot/measureToGeometryRange")
    public Mono<MeasureToGeometryResponse> measureToGeometryRange(
            @RequestParam String routeId,
            @RequestParam double fromMeasure,
            @RequestParam double toMeasure) {
        return gisApi.measureToGeometryRange(routeId, fromMeasure, toMeasure);
    }
}
