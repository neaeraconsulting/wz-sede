package com.wydot.wz_datahub.api.controllers.kafka;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.wydot.wz_datahub.api.ProtobufUtils;
import com.wydot.wz_datahub.api.accessors.field_devices.FieldDeviceLinkRepository;
import com.wydot.wz_datahub.api.kafka.KafkaTopics;
import com.wydot.wz_datahub.api.models.field_devices.FieldDeviceLink;

import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.DataHubFieldDeviceUpdate;
import wyo.dot.protobuf.FieldDevice;
import wyo.dot.protobuf.conadmin.ConAdminFieldDeviceUpdate;

@RestController
@Slf4j
@RequestMapping("/kafka")
public class FieldDeviceUpdateController {
    private final FieldDeviceLinkRepository fieldDeviceRepository;

    @Autowired
    private KafkaTemplate<String, DataHubFieldDeviceUpdate> template;

    public FieldDeviceUpdateController(
            FieldDeviceLinkRepository fieldDeviceRepository) {
        this.fieldDeviceRepository = fieldDeviceRepository;
    }

    public void submitFieldDeviceUpdate(DataHubFieldDeviceUpdate update) {
        log.debug("Submitting field device update: {}", update.getRequestId());
        this.template.send(KafkaTopics.DATAHUB_FIELD_DEVICE, String.valueOf(update.getRequestId()), update);
    }

    public void handleFieldDeviceUpdate(ConAdminFieldDeviceUpdate update) {
        log.debug("Received road event update: {}", update.getRequestId());

        switch (update.getTypeCase()) {
            case UPDATED:
                handleFieldDeviceUpdated(update);
                break;
            default:
                log.warn("Received unrecognized field device update: {}", update.getRequestId());
        }
    }

    private void handleFieldDeviceUpdated(ConAdminFieldDeviceUpdate update) {
        String deviceId = update.getUpdated().getFieldDevice().getId();
        Long timestamp = ProtobufUtils.millisFromTimestamp(update.getTimestamp());
        FieldDevice fieldDevice = update.getUpdated().getFieldDevice();
        // TODO: Handle diff of existing data to ensure no links are lost
        fieldDeviceRepository.update(deviceId, new FieldDeviceLink(timestamp, fieldDevice));
    }
}
