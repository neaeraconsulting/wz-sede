package com.wydot.message_generator.kafka;

import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.CreateRoadEvent;

import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

import com.wydot.message_generator.controllers.kafka.DataHubSyncController;

@Component
@Slf4j
public class DataHubSyncForwardListener {

    private final DataHubSyncController dataHubSyncController;

    public DataHubSyncForwardListener(DataHubSyncController dataHubSyncController) {
        this.dataHubSyncController = dataHubSyncController;
    }

    @KafkaListener(id = ListenerIds.DATAHUB_SYNC, topics = KafkaTopics.MESSAGE_GENERATOR_SYNC, containerFactory = "createRoadEventKafkaListenerContainerFactory")
    public void listen(ConsumerRecord<String, CreateRoadEvent> record) {
        log.info("Received road event with offset {}", record.offset());
        try {
            log.debug("Processing road event with offset {}", record.offset());
            dataHubSyncController.handleRoadEventUpdate(record.value());
            log.trace("Successfully processed road event with offset {}", record.offset());
        } catch (Exception e) {
            log.error("Error processing road event message at offset {}: {}", record.offset(), e.getMessage(), e);
            // Don't rethrow - this would cause Kafka to retry the message indefinitely
            // Instead, log the error and continue to the next message
        }
    }
}
