package com.wydot.message_generator.controllers.kafka;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.wydot.message_generator.accessors.cosmos_id_link.CosmosIdLinkRepository;
import com.wydot.message_generator.message_generators.cwz.CwzMessageGenerator;
import com.wydot.message_generator.models.sdx.CosmosIdLink;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.CreateRoadEvent;

@RestController
@Slf4j
@RequestMapping("/kafka")
@RequiredArgsConstructor
public class DataHubSyncController {
    private final CwzMessageGenerator cwzMessageGenerator;
    private final CosmosIdLinkRepository cosmosIdLinkRepository;

    public void handleRoadEventUpdate(CreateRoadEvent update) {
        log.info("Received road event update: {}", update.getRoadEvent().getId());
        
        CosmosIdLink link = cosmosIdLinkRepository.findOne(null, update.getRoadEvent().getId());

        if (link != null) {
            handleRoadEventUpdated(update, link);
        } else {
            handleRoadEventCreated(update);
        }
    }

    private void handleRoadEventCreated(CreateRoadEvent created) {
        cwzMessageGenerator.handleRoadEventCreated(created.getRoadEvent(), created.getRoadSubEventsList())
                .doOnSuccess((CosmosIdLink link) -> {
                    cosmosIdLinkRepository.insert(link);
                    log.info("Successfully created road event with ID: {}", created.getRoadEvent().getId());
                })
                .doOnError(error -> {
                    log.error("Failed to create road event with ID: {}. Error: {}",
                            created.getRoadEvent().getId(), error.getMessage());
                })
                .subscribe();
    }

    private void handleRoadEventUpdated(CreateRoadEvent updated, CosmosIdLink link) {
            cwzMessageGenerator.handleRoadEventUpdated(link, updated.getRoadEvent(), updated.getRoadSubEventsList())
                    .doOnSuccess(unused -> {
                        log.info("Successfully updated road event with ID: {}", updated.getRoadEvent().getId());
                    })
                    .doOnError(error -> {
                        log.error("Failed to update road event with ID: {}. Error: {}",
                                updated.getRoadEvent().getId(), error.getMessage());
                    })
                    .subscribe();
    }
}
