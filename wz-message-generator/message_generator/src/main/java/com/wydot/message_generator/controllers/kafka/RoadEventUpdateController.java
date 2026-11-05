package com.wydot.message_generator.controllers.kafka;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.wydot.message_generator.accessors.cosmos_id_link.CosmosIdLinkRepository;
import com.wydot.message_generator.kafka.KafkaTopics;
import com.wydot.message_generator.message_generators.cwz.CwzMessageGenerator;
import com.wydot.message_generator.models.sdx.CosmosIdLink;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;
import wyo.dot.protobuf.DataHubRoadEventUpdate;
import wyo.dot.protobuf.conadmin.ConAdminRoadEventUpdate;
import wyo.dot.protobuf.conadmin.RoadEventCreated;
import wyo.dot.protobuf.conadmin.RoadEventRemoved;
import wyo.dot.protobuf.conadmin.RoadEventUpdated;

@RestController
@Slf4j
@RequestMapping("/kafka")
@RequiredArgsConstructor
public class RoadEventUpdateController {
    private final CwzMessageGenerator cwzMessageGenerator;
    private final CosmosIdLinkRepository cosmosIdLinkRepository;

    @Autowired
    private KafkaTemplate<String, DataHubRoadEventUpdate> template;

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @PostMapping("/road_events")
    public Mono<Void> submitRoadEventUpdate(@RequestBody DataHubRoadEventUpdate request) {
        this.template.send(KafkaTopics.CON_ADMIN_ROAD_EVENT_UPDATE, String.valueOf(request.getRequestId()), request);
        return Mono.empty();
    }

    public void handleRoadEventUpdate(ConAdminRoadEventUpdate update) {
        log.info("Received road event update: {}", update.getTypeCase());

        switch (update.getTypeCase()) {
            case CREATED:
                handleRoadEventCreated(update);
                break;
            case UPDATED:
                handleRoadEventUpdated(update);
                break;
            case REMOVED:
                handleRoadEventRemoved(update);
                break;
            default:
                log.warn("Received unrecognized field device update: {}", update.getTypeCase());
        }
    }

    private void handleRoadEventCreated(ConAdminRoadEventUpdate update) {
        RoadEventCreated created = update.getCreated();
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

        // cwzMessageGenerator.handleRoadEventCreated(created.getRoadEvent(),
        // created.getRoadSubEventsList());
    }

    private void handleRoadEventUpdated(ConAdminRoadEventUpdate update) {
        RoadEventUpdated updated = update.getUpdated();
        CosmosIdLink link = cosmosIdLinkRepository.findOne(null, updated.getRoadEvent().getId());
        if (link != null) {
            cwzMessageGenerator.handleRoadEventUpdated(link, updated.getRoadEvent(), updated.getRoadSubEventsList())
                    .doOnSuccess(unused -> {
                        log.info("Successfully updated road event with ID: {}", updated.getRoadEvent().getId());
                    })
                    .doOnError(error -> {
                        log.error("Failed to update road event with ID: {}. Error: {}",
                                updated.getRoadEvent().getId(), error.getMessage());
                    })
                    .subscribe();
            // cwzMessageGenerator.handleRoadEventUpdated(link, updated.getRoadEvent(),
            // updated.getRoadSubEventsList());
        } else {
            // Message must not exist - create it
            log.info("Road event with ID {} not found, creating new one", updated.getRoadEvent().getId());
            cwzMessageGenerator.handleRoadEventCreated(updated.getRoadEvent(), updated.getRoadSubEventsList())
                    .doOnSuccess((CosmosIdLink newLink) -> {
                        cosmosIdLinkRepository.insert(newLink);
                        log.info("Successfully created road event with ID: {}", updated.getRoadEvent().getId());
                    })
                    .doOnError(error -> {
                        log.error("Failed to create road event with ID: {}. Error: {}",
                                updated.getRoadEvent().getId(), error.getMessage());
                    })
                    .subscribe();
            // cwzMessageGenerator.handleRoadEventCreated(updated.getRoadEvent(),
            // updated.getRoadSubEventsList());
        }
    }

    private void handleRoadEventRemoved(ConAdminRoadEventUpdate update) {
        RoadEventRemoved removed = update.getRemoved();
        CosmosIdLink link = cosmosIdLinkRepository.findOne(null, removed.getRoadEventId());
        if (link != null) {
            cwzMessageGenerator.handleRoadEventDeleted(link)
                    .doOnSuccess(unused -> {
                        cosmosIdLinkRepository.delete(link.getCosmosId());
                        log.info("Successfully deleted road event with ID: {}", removed.getRoadEventId());
                    })
                    .doOnError(error -> {
                        log.error("Failed to delete road event with ID: {}. Error: {}",
                                removed.getRoadEventId(), error.getMessage());
                    })
                    .subscribe();
        } else {
            log.warn("Attempted to delete road event with ID {} but no link found", removed.getRoadEventId());
        }

        // cwzMessageGenerator.handleRoadEventDeleted(link);
    }
}
