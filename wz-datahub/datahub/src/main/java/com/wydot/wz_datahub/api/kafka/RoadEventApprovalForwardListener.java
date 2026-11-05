package com.wydot.wz_datahub.api.kafka;

import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.conadmin.ConAdminRoadEventApproval;

import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.controllers.kafka.RoadEventApprovalController;

@Component
@Slf4j
public class RoadEventApprovalForwardListener extends BaseSeekToEndListener {

    private final RoadEventApprovalController roadEventApprovalController;

    public RoadEventApprovalForwardListener(RoadEventApprovalController roadEventApprovalController) {
        this.roadEventApprovalController = roadEventApprovalController;
    }

    @KafkaListener(id = ListenerIds.ROAD_EVENT_APPROVAL, topics = KafkaTopics.CON_ADMIN_ROAD_EVENT_APPROVAL, containerFactory = "conAdminRoadEventApprovalKafkaListenerContainerFactory")
    public void listen(ConsumerRecord<String, ConAdminRoadEventApproval> record) {
        roadEventApprovalController.handleRoadEventApproval(record.value());
        log.trace("Received road event with offset {}", record.offset());
    }
}
