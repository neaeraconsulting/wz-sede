package com.wydot.wz_datahub.api.retrievers.pi_lit;

import java.util.List;
import java.util.Map;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.accessors.data_source.DataSourceSummaryRepository;
import com.wydot.wz_datahub.api.accessors.field_devices.FieldDeviceLinkRepository;
import com.wydot.wz_datahub.api.models.data_sources.DataFeedSourceSummary;
import com.wydot.wz_datahub.api.models.field_devices.FieldDeviceLink;
import com.wydot.wz_datahub.api.models.field_devices.FieldDeviceReading;
import com.wydot.wz_datahub.api.models.field_devices.FieldDeviceTransformer;
import com.wydot.wz_datahub.api.models.raw_data.RawDataType;
import com.wydot.wz_datahub.api.models.wz.device_feed.DeviceFeed;
import com.wydot.wz_datahub.api.update_processors.field_device.FieldDeviceUpdateProcessor;
import com.wydot.wz_datahub.api.utilities.gis_service.GisService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import wyo.dot.protobuf.FieldDevice.FieldDeviceStatus;

@Slf4j
@Component
@RequiredArgsConstructor
public class PiLitEventFeedFetcher {

    private final GisService gisService;
    private final PiLitEventFeedApi verMacApi;
    private final PiLitTokenService tokenService;
    private final FieldDeviceUpdateProcessor fieldDeviceUpdateProcessor;
    private final PiLitIngestProperties ingestProperties;
    private final FieldDeviceTransformer fieldDeviceTransformer;
    private final FieldDeviceLinkRepository fieldDeviceLinkRepository;
    private final DataSourceSummaryRepository dataSourceSummaryRepository;

    @Scheduled(fixedDelayString = "${ingest.pi-lit.fetch-interval:5m}") // Default to 5 minutes
    public void fetchFeeds() {
        if (!ingestProperties.isEnabled()) {
            log.debug("Pi-Lit ingestion is disabled, skipping feed fetch.");
            return;
        }
        fetchDeviceFeeds()
                .doOnSuccess(result -> {
                    dataSourceSummaryRepository.update(DataFeedSourceSummary.PiLit());
                    log.info("Successfully fetched {} Pi-Lit devices.", result.size());
                })
                .doOnError(ex -> log.error("Failed to fetch Pi-Lit device feeds", ex))
                .subscribe(); // Trigger the reactive pipeline;
    }

    public Mono<List<FieldDeviceReading>> fetchDeviceFeeds() {
        return tokenService.getTokenStore().flatMap(tokenStore -> verMacApi.retrieveAsync(tokenStore.getAccessToken()))
                .flatMap(eventFeed -> handleFieldDeviceFeedUpdate(eventFeed));
    }

    public Mono<List<FieldDeviceReading>> handleFieldDeviceFeedUpdate(DeviceFeed deviceFeed) {
        return Flux.fromIterable(deviceFeed.getFeatures())
                .flatMap(fieldDeviceFeature -> fieldDeviceTransformer
                        .transformToFieldDevice(fieldDeviceFeature, RawDataType.PI_LIT, gisService))
                .filter(reading -> reading != null) // Filter out null readings
                .doOnNext(reading -> fieldDeviceUpdateProcessor.handleNewFieldDeviceReading(reading,
                        ingestProperties.isUpdatesEnabled()))
                .collectList().doOnNext(this::updateRemovedDevices);
    }

    private void updateRemovedDevices(List<FieldDeviceReading> latestReadings) {
        List<FieldDeviceLink> currentLinks = fieldDeviceLinkRepository
                .findByDeviceSource(RawDataType.PI_LIT);
        Map<String, FieldDeviceStatus> newStatusMap = latestReadings.stream().collect(
                java.util.stream.Collectors.toMap(
                        reading -> reading.getDevice().getId(),
                        reading -> reading.getDevice().getCoreDetails().getDeviceStatus()));
        for (FieldDeviceLink link : currentLinks) {
            FieldDeviceStatus newStatus = newStatusMap.get(link.getDeviceId());
            if (newStatus != null && link.getDeviceStatus() != newStatus) {
                link.setDeviceStatus(newStatus);
                fieldDeviceLinkRepository.update(link.getDeviceId(), link);
            }
        }
    }
}
