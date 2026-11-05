package com.wydot.message_generator.kafka;

import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.conadmin.ConAdminRoadEventUpdate;

import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

import com.wydot.message_generator.controllers.kafka.RoadEventUpdateController;

@Component
@Slf4j
public class RoadEventUpdateForwardListener {

    private final RoadEventUpdateController roadEventUpdateController;

    public RoadEventUpdateForwardListener(RoadEventUpdateController roadEventUpdateController) {
        this.roadEventUpdateController = roadEventUpdateController;
    }

    @KafkaListener(id = ListenerIds.ROAD_EVENT_UPDATE, topics = KafkaTopics.CON_ADMIN_ROAD_EVENT_UPDATE, containerFactory = "conAdminRoadEventUpdateKafkaListenerContainerFactory")
    public void listen(ConsumerRecord<String, ConAdminRoadEventUpdate> record) {
        try {
            log.debug("Processing road event with offset {}", record.offset());
            roadEventUpdateController.handleRoadEventUpdate(record.value());
            log.trace("Successfully processed road event with offset {}", record.offset());
        } catch (Exception e) {
            log.error("Error processing road event message at offset {}: {}", record.offset(), e.getMessage(), e);
            // Don't rethrow - this would cause Kafka to retry the message indefinitely
            // Instead, log the error and continue to the next message
        }
    }
}
