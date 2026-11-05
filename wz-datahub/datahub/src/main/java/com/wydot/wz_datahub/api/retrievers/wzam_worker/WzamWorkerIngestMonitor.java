package com.wydot.wz_datahub.api.retrievers.wzam_worker;

import java.util.List;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.accessors.field_devices.FieldDeviceLinkRepository;
import com.wydot.wz_datahub.api.models.field_devices.FieldDeviceLink;
import com.wydot.wz_datahub.api.models.raw_data.RawDataType;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.FieldDevice.FieldDeviceStatus;

@Slf4j
@Component
@RequiredArgsConstructor
public class WzamWorkerIngestMonitor {

    private final WzamWorkerIngestProperties ingestProperties;
    private final FieldDeviceLinkRepository fieldDeviceLinkRepository;

    @Scheduled(fixedDelayString = "${ingest.wzam-worker.expiration-eval-interval:5m}") // Default to 5 minutes
    public void fetchFeeds() {
        if (!ingestProperties.isEnabled()) {
            log.debug("WZAM Worker ingestion is disabled, skipping feed fetch.");
            return;
        }
        detectOfflineWorkers();
    }

    private void detectOfflineWorkers() {
        List<FieldDeviceLink> currentLinks = fieldDeviceLinkRepository
                .findByDeviceSource(RawDataType.WZAM_WORKER);
        long currentTime = System.currentTimeMillis();
        for (FieldDeviceLink link : currentLinks) {
            if ((currentTime - link.getTimestamp()) > ingestProperties.getMaxAge().toMillis()) {
                if (link.getDeviceStatus() != FieldDeviceStatus.FIELD_DEVICE_STATUS_OFFLINE) {
                    log.info("Marking device {} as OFFLINE due to inactivity.", link.getDeviceId());
                    link.setDeviceStatus(FieldDeviceStatus.FIELD_DEVICE_STATUS_OFFLINE);
                    fieldDeviceLinkRepository.update(link.getDeviceId(), link);
                }
            }
        }
    }
}
