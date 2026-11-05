package com.wydot.message_generator.controllers;

import java.time.Duration;
import java.util.List;
import java.util.Optional;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.wydot.message_generator.accessors.cosmos_id_link.CosmosIdLinkRepository;
import com.wydot.message_generator.controllers.kafka.RoadEventUpdateController;
import com.wydot.message_generator.datahub.DataHubApi;
import com.wydot.message_generator.models.sdx.CosmosIdLink;
import com.wydot.message_generator.sdx.SdxApiService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import wyo.dot.protobuf.conadmin.ConAdminRoadEventUpdate;
import wyo.dot.protobuf.conadmin.RoadEventRemoved;

@Slf4j
@RestController
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {
    private static final Duration DELETE_DELAY = Duration.ofMillis(50);

    final CosmosIdLinkRepository cosmosIdLinkRepository;
    final RoadEventUpdateController roadEventUpdateController;
    final DataHubApi dataHubApi;
    final Optional<SdxApiService> sdxApi;

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @GetMapping("/cosmos_id_links")
    public Mono<List<CosmosIdLink>> getFieldDeviceLinks() {
        return Mono.just(cosmosIdLinkRepository.findAll());
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @GetMapping("/cosmos_id_link")
    public Mono<CosmosIdLink> getFieldDeviceLinks(
            @RequestParam(name = "road_event_id", required = false) Long roadEventId,
            @RequestParam(name = "cosmos_id", required = false) String cosmosId) {
        return Mono.just(cosmosIdLinkRepository.findOne(cosmosId, roadEventId));
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @GetMapping("/start_road_event_sync")
    public Mono<Long[]> runAllRoadEvents(
            @RequestParam(name = "road_event_id", required = false) Long roadEventId) {
        return dataHubApi.startRoadEventSync(roadEventId)
                .doOnError(error -> log.error("Failed to start road event sync: {}", error.getMessage()));
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @DeleteMapping("/work_zones")
    public Mono<List<String>> deleteAllWorkZones() {
        if (sdxApi.isEmpty()) {
            return Mono.error(new IllegalStateException("SDX is not enabled"));
        }
        SdxApiService sdx = sdxApi.get();
        return Flux.fromIterable(cosmosIdLinkRepository.findAll())
                .delayElements(DELETE_DELAY)
                .concatMap(link -> sdx
                        .deleteWorkZone(link.getCosmosId().replace("{\"id\":\"", "").replace("\"}", ""))
                        .then(Mono.fromRunnable(() -> cosmosIdLinkRepository.delete(link.getCosmosId())))
                        .then(Mono.<String>empty())
                        .onErrorResume(error -> {
                            String message = String.format("cosmos_id=%s, road_event_id=%s: %s",
                                    link.getCosmosId(), link.getRoadEventId(), error.getMessage());
                            log.error("Failed to delete work zone {}", message);
                            return Mono.just(message);
                        }))
                .collectList();
    }

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @DeleteMapping("/road_event")
    public Mono<Void> deleteRoadEvent(
            @RequestParam(name = "road_event_id", required = true) Long roadEventId) {
        roadEventUpdateController.handleRoadEventUpdate(
                ConAdminRoadEventUpdate.newBuilder()
                        .setRemoved(
                                RoadEventRemoved.newBuilder()
                                        .setRoadEventId(roadEventId))
                        .build());
        return Mono.empty();
    }
}
