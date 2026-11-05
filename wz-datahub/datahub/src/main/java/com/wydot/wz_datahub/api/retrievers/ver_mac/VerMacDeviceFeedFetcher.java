package com.wydot.wz_datahub.api.retrievers.ver_mac;

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
import wyo.dot.protobuf.FieldDevice.FieldDeviceStatus;

@Slf4j
@Component
@RequiredArgsConstructor
public class VerMacDeviceFeedFetcher {

    private final GisService gisService;
    private final VerMacDeviceFeedApi verMacApi;
    private final FieldDeviceUpdateProcessor fieldDeviceUpdateProcessor;
    private final VerMacIngestProperties ingestProperties;
    private final FieldDeviceTransformer fieldDeviceTransformer;
    private final FieldDeviceLinkRepository fieldDeviceLinkRepository;
    private final DataSourceSummaryRepository dataSourceSummaryRepository;

    @Scheduled(fixedDelayString = "${ingest.ver-mac.fetch-interval:5m}") // Default to 5 minutes
    public void fetchFeeds() {
        if (!ingestProperties.isEnabled()) {
            log.debug("Ver-Mac ingestion is disabled, skipping feed fetch.");
            return;
        }
        List<FieldDeviceReading> readings = fetchDeviceFeeds();
        dataSourceSummaryRepository.update(DataFeedSourceSummary.VerMac());
        log.info("Successfully fetched {} Ver-Mac devices.", readings.size());

    }

    public List<FieldDeviceReading> fetchDeviceFeeds() {
        DeviceFeed feed = verMacApi.retrieveAsync().block();
        return handleFieldDeviceFeedUpdate(feed);
    }

    public List<FieldDeviceReading> handleFieldDeviceFeedUpdate(DeviceFeed deviceFeed) {
        List<FieldDeviceReading> readings = deviceFeed.getFeatures().stream().map(
                fieldDeviceFeature -> fieldDeviceTransformer
                        .transformToFieldDevice(fieldDeviceFeature, RawDataType.VER_MAC, gisService).block())
                .filter(reading -> reading != null) // Filter out null readings
                .toList();
        readings.stream().forEach(
                (v) -> fieldDeviceUpdateProcessor.handleNewFieldDeviceReading(v, ingestProperties.isUpdatesEnabled()));
        this.updateRemovedDevices(readings);
        return readings;
    }

    private void updateRemovedDevices(List<FieldDeviceReading> latestReadings) {
        List<FieldDeviceLink> currentLinks = fieldDeviceLinkRepository
                .findByDeviceSource(RawDataType.VER_MAC);
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
