package com.wydot.wz_datahub.api.retrievers.wanco;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
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
import com.wydot.wz_datahub.api.models.wanco.WancoDeviceFeedWZDx42;
import com.wydot.wz_datahub.api.models.wanco.sabp.WancoDeviceFeedSABP;
import com.wydot.wz_datahub.api.models.wanco.sabp.WancoSABPArrowboard;
import com.wydot.wz_datahub.api.models.wz.device_feed.DeviceFeed;
import com.wydot.wz_datahub.api.models.wz.device_feed.FieldDeviceFeature;
import com.wydot.wz_datahub.api.update_processors.field_device.FieldDeviceUpdateProcessor;
import com.wydot.wz_datahub.api.utilities.gis_service.GisService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.FieldDevice.FieldDeviceStatus;

@Slf4j
@Component
@RequiredArgsConstructor
public class WancoDeviceFeedFetcher {

    private final GisService gisService;
    private final WancoDeviceFeedApi wancoApi;
    private final FieldDeviceUpdateProcessor fieldDeviceUpdateProcessor;
    private final WancoIngestProperties ingestProperties;
    private final WancoTokenService tokenService;
    private final FieldDeviceTransformer fieldDeviceTransformer;
    private final FieldDeviceLinkRepository fieldDeviceLinkRepository;
    private final DataSourceSummaryRepository dataSourceSummaryRepository;

    @Scheduled(fixedDelayString = "${ingest.wanco.fetch-interval:5m}") // Default to 5 minutes
    public void fetchFeeds() {
        if (!ingestProperties.isEnabled()) {
            log.debug("Wanco ingestion is disabled, skipping feed fetch.");
            return;
        }
        List<FieldDeviceReading> readings = fetchDeviceFeeds();
        dataSourceSummaryRepository.update(DataFeedSourceSummary.Wanco());
        log.info("Successfully fetched {} Wanco devices.", readings.size());

    }

    public List<FieldDeviceReading> fetchDeviceFeeds() {
        String accessToken = tokenService.getTokenStore().map(token -> token.getAccessToken()).block();
        WancoDeviceFeedWZDx42 firstPage = fetchPage(accessToken, null);
        Map<String, Integer> compassBySerial = Collections.emptyMap();
        if (ingestProperties.isSabpEnabled()) {
            compassBySerial = fetchSabpCompassBySerial(accessToken);
        }

        if (firstPage == null || firstPage.getData() == null) {
            DeviceFeed emptyFeed = new DeviceFeed();
            emptyFeed.setFeatures(Collections.emptyList());
            return handleFieldDeviceFeedUpdate(emptyFeed, compassBySerial);
        }

        DeviceFeed mergedFeed = firstPage.getData();
        List<FieldDeviceFeature> allFeatures = new ArrayList<>();
        appendFeatures(firstPage, allFeatures);

        String continued = firstPage.getContinued();
        while (continued != null) {
            WancoDeviceFeedWZDx42 nextPage = fetchPage(accessToken, continued);
            if (nextPage == null) {
                break;
            }
            appendFeatures(nextPage, allFeatures);
            continued = nextPage.getContinued();
        }

        mergedFeed.setFeatures(allFeatures);
        return handleFieldDeviceFeedUpdate(mergedFeed, compassBySerial);
    }

    private WancoDeviceFeedWZDx42 fetchPage(String accessToken, String continued) {
        return wancoApi.retrieveAsync(accessToken, continued).block();
    }

    private Map<String, Integer> fetchSabpCompassBySerial(String accessToken) {
        Map<String, Integer> compassBySerial = new HashMap<>();

        String continued = null;
        do {
            WancoDeviceFeedSABP page = wancoApi.retrieveSabpAsync(accessToken, continued).block();
            if (page == null) {
                break;
            }

            if (page.getData() != null && page.getData().getArrowboards() != null) {
                for (WancoSABPArrowboard arrowboard : page.getData().getArrowboards()) {
                    if (arrowboard == null || arrowboard.getDisplay() == null) {
                        continue;
                    }
                    String sabpId = arrowboard.getId();
                    Integer compass = arrowboard.getDisplay().getCompass();
                    if (sabpId != null && compass != null) {
                        compassBySerial.put(sabpId, compass);
                        String[] idParts = sabpId.split(";");
                        String trailingId = idParts.length == 0 ? null : idParts[idParts.length - 1];
                        if (trailingId != null && !trailingId.isBlank()) {
                            compassBySerial.put(trailingId, compass);
                        }
                    }
                }
            }

            continued = page.getContinued();
        } while (continued != null);

        return compassBySerial;
    }

    private void appendFeatures(WancoDeviceFeedWZDx42 page, List<FieldDeviceFeature> allFeatures) {
        if (page.getData() != null && page.getData().getFeatures() != null) {
            allFeatures.addAll(page.getData().getFeatures());
        }
    }

    public List<FieldDeviceReading> handleFieldDeviceFeedUpdate(DeviceFeed deviceFeed,
            Map<String, Integer> compassBySerial) {
        List<FieldDeviceReading> readings = deviceFeed.getFeatures().stream().map(
                fieldDeviceFeature -> {
                    FieldDeviceReading reading = fieldDeviceTransformer
                            .transformToFieldDevice(fieldDeviceFeature, RawDataType.WANCO, gisService).block();
                    if (reading != null) {
                        String serialNumber = fieldDeviceFeature.getProperties() != null
                                && fieldDeviceFeature.getProperties().getCoreDetails() != null
                                        ? fieldDeviceFeature.getProperties().getCoreDetails().getSerialNumber()
                                        : null;
                        Integer compass = serialNumber == null ? null : compassBySerial.get(serialNumber);
                        fieldDeviceUpdateProcessor.handleNewFieldDeviceReading(reading,
                                ingestProperties.isUpdatesEnabled(), compass);
                    }
                    return reading;
                })
                .filter(reading -> reading != null) // Filter out null readings
                .toList();
        this.updateRemovedDevices(readings);
        return readings;
    }

    private void updateRemovedDevices(List<FieldDeviceReading> latestReadings) {
        List<FieldDeviceLink> currentLinks = fieldDeviceLinkRepository
                .findByDeviceSource(RawDataType.WANCO);
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
