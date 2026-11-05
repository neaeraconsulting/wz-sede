package com.wydot.wz_datahub.api.kafka;

import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.conadmin.ConAdminFieldDeviceUpdate;

import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.controllers.kafka.FieldDeviceUpdateController;

@Component
@Slf4j
public class FieldDeviceUpdateForwardListener extends BaseSeekToEndListener {

    private final FieldDeviceUpdateController fieldDeviceUpdateController;

    public FieldDeviceUpdateForwardListener(FieldDeviceUpdateController fieldDeviceUpdateController) {
        this.fieldDeviceUpdateController = fieldDeviceUpdateController;
    }

    @KafkaListener(id = ListenerIds.FIELD_DEVICE, topics = KafkaTopics.CON_ADMIN_FIELD_DEVICE, containerFactory = "conAdminFieldDeviceUpdateKafkaListenerContainerFactory")
    public void listen(ConsumerRecord<String, ConAdminFieldDeviceUpdate> record) {
        fieldDeviceUpdateController.handleFieldDeviceUpdate(record.value());
        log.trace("Received field device with offset {}", record.offset());
    }

}
