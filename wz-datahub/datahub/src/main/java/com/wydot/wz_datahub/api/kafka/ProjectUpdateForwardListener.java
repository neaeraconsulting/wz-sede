package com.wydot.wz_datahub.api.kafka;

import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.conadmin.ConAdminProjectUpdate;

import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.controllers.kafka.ProjectUpdateController;

@Component
@Slf4j
public class ProjectUpdateForwardListener extends BaseSeekToEndListener {

    private final ProjectUpdateController projectUpdateController;

    public ProjectUpdateForwardListener(ProjectUpdateController projectUpdateController) {
        this.projectUpdateController = projectUpdateController;
    }

    @KafkaListener(id = ListenerIds.PROJECT, topics = KafkaTopics.CON_ADMIN_PROJECT, containerFactory = "conAdminProjectUpdateKafkaListenerContainerFactory")
    public void listen(ConsumerRecord<String, ConAdminProjectUpdate> record) {
        projectUpdateController.handleProjectUpdate(record.value());
        log.trace("Received project with offset {}", record.offset());
    }

}
