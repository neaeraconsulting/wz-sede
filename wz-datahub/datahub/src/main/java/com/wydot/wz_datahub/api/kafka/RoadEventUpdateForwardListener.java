package com.wydot.wz_datahub.api.kafka;

import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.conadmin.ConAdminRoadEventUpdate;

import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.controllers.kafka.RoadEventUpdateController;

@Component
@Slf4j
public class RoadEventUpdateForwardListener extends BaseSeekToEndListener {

    private final RoadEventUpdateController roadEventUpdateController;

    public RoadEventUpdateForwardListener(RoadEventUpdateController roadEventUpdateController) {
        this.roadEventUpdateController = roadEventUpdateController;
    }

    @KafkaListener(id = ListenerIds.ROAD_EVENT_UPDATE, topics = KafkaTopics.CON_ADMIN_ROAD_EVENT_UPDATE, containerFactory = "conAdminRoadEventUpdateKafkaListenerContainerFactory")
    public void listen(ConsumerRecord<String, ConAdminRoadEventUpdate> record) {
        roadEventUpdateController.handleRoadEventUpdate(record.value());
        log.trace("Received road event with offset {}", record.offset());
    }
}
