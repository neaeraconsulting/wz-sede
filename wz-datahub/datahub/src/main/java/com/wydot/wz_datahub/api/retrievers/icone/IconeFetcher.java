package com.wydot.wz_datahub.api.retrievers.icone;

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
import wyo.dot.protobuf.FieldDevice.FieldDeviceStatus;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@RequiredArgsConstructor
public class IconeFetcher {

    private final GisService gisService;
    private final IconeApi iconeApi;
    private final FieldDeviceUpdateProcessor fieldDeviceUpdateProcessor;
    private final IconeIngestProperties ingestProperties;
    private final FieldDeviceTransformer fieldDeviceTransformer;
    private final FieldDeviceLinkRepository fieldDeviceLinkRepository;
    private final DataSourceSummaryRepository dataSourceSummaryRepository;

    // Fetch iCone data every 5 minutes
    @Scheduled(fixedDelayString = "${ingest.icone.fetch-interval:5m}") // Default to 5 minutes
    public void fetch() {
        if (!ingestProperties.isEnabled()) {
            log.debug("Icone ingestion is disabled, skipping feed fetch.");
            return;
        }
        List<FieldDeviceReading> readings = fetchDeviceFeeds();
        dataSourceSummaryRepository.update(DataFeedSourceSummary.Icone());
        log.info("Successfully fetched {} iCone devices.", readings.size());

    }

    public List<FieldDeviceReading> fetchDeviceFeeds() {
        DeviceFeed feed = iconeApi.retrieveAsync().block();
        return handleFieldDeviceFeedUpdate(feed);
    }

    public List<FieldDeviceReading> handleFieldDeviceFeedUpdate(DeviceFeed deviceFeed) {
        List<FieldDeviceReading> readings = deviceFeed.getFeatures().stream().map(
                fieldDeviceFeature -> fieldDeviceTransformer
                        .transformToFieldDevice(fieldDeviceFeature, RawDataType.ICONE, gisService).block())
                .filter(reading -> reading != null) // Filter out null readings
                .toList();
        readings.stream().forEach(
                (v) -> fieldDeviceUpdateProcessor.handleNewFieldDeviceReading(v, ingestProperties.isUpdatesEnabled()));
        this.updateRemovedDevices(readings);
        return readings;
    }

    private void updateRemovedDevices(List<FieldDeviceReading> latestReadings) {
        List<FieldDeviceLink> currentLinks = fieldDeviceLinkRepository
                .findByDeviceSource(RawDataType.ICONE);
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