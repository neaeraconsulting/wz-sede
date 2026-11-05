package com.wydot.wz_datahub.api.kafka;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.wydot.wz_datahub.api.accessors.data_source.DataSourceSummaryRepository;
import com.wydot.wz_datahub.api.accessors.raw.RawDataRepository;
import com.wydot.wz_datahub.api.controllers.kafka.RawVehicleLocationUpdateController;
import com.wydot.wz_datahub.api.models.data_sources.DataFeedSourceSummary;
import com.wydot.wz_datahub.api.models.raw_data.RawDataType;
import com.wydot.wz_datahub.api.models.raw_data.RawDataWrapper;
import com.wydot.wz_datahub.api.models.raw_vehicle_location.RawVehicleLocation;

@Component
@Slf4j
@RequiredArgsConstructor
public class RawVehicleLocationUpdateForwardListener extends BaseSeekToEndListener {
    private final RawVehicleLocationUpdateController roadEventUpdateController;
    private final DataSourceSummaryRepository dataSourceSummaryRepository;
    private final RawDataRepository rawDataRepository;
    private final ObjectMapper objectMapper;

    @KafkaListener(id = ListenerIds.RAW_VEHICLE_LOCATION, topics = KafkaTopics.RAW_VEHICLE_LOCATION, containerFactory = "rawVehicleLocationListenerContainerFactory")
    public void listen(ConsumerRecord<String, RawVehicleLocation> record) {
        roadEventUpdateController.handleRawVehicleLocationUpdate(record.value());
        dataSourceSummaryRepository.update(DataFeedSourceSummary.Avl());
        try {
            String json = objectMapper.writeValueAsString(record.value());
            rawDataRepository.insert(new RawDataWrapper(System.currentTimeMillis(), RawDataType.AVL_VEHICLE,
                    json));
        } catch (JsonProcessingException e) {
            log.error("Failed to serialize RawVehicleLocation for raw data logging: {}", record.value(), e);
        }
        log.trace("Received raw vehicle location with offset {}", record.offset());
    }
}
