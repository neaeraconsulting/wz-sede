package com.wydot.message_generator.cleanup_tasks;

import java.time.Instant;
import java.util.Arrays;
import java.util.List;

import org.springframework.scheduling.annotation.Scheduled;

import com.wydot.message_generator.accessors.cosmos_id_link.CosmosIdLinkRepository;
import com.wydot.message_generator.datahub.DataHubApi;
import com.wydot.message_generator.models.sdx.CosmosIdLink;
import com.wydot.message_generator.sdx.SdxApiService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

@Slf4j
@RequiredArgsConstructor
public class ExpiredMessageCleanupTask {
    private final MessageCleanupTaskProperties properties;
    private final CosmosIdLinkRepository cosmosIdLinkRepository;
    private final DataHubApi dataHubApi;
    private final SdxApiService sdxApi;
    private Instant lastQueryTime;

    @Scheduled(fixedDelayString = "${message-cleanup.eval-interval:5m}") // Default to 5 minutes
    public void removeExpiredMessages() {
        if (!properties.getEnabled()) {
            log.debug("Message cleanup is disabled, skipping expired message removal.");
            return;
        }

        listExpiredRoadEvents()
                .flatMap(expiredEventIds -> {
                    List<CosmosIdLink> currentLinks = getCurrentRoadEventLinks();
                    List<Long> expiredIds = Arrays.asList(expiredEventIds);

                    List<CosmosIdLink> expiredLinks = currentLinks.stream()
                            .filter(link -> expiredIds.contains(link.getRoadEventId()))
                            .toList();

                    // Process all deletions in parallel and wait for all to complete
                    return Mono.when(
                            expiredLinks.stream()
                                    .map(this::deleteExpiredRoadEvent)
                                    .toArray(Mono[]::new));
                })
                .doOnError(error -> log.error("Error during expired message cleanup: {}", error.getMessage()))
                .subscribe();
    }

    private Mono<Void> deleteExpiredRoadEvent(CosmosIdLink link) {
        return sdxApi.deleteWorkZone(link.getCosmosId())
                .doOnSuccess(unused -> {
                    cosmosIdLinkRepository.delete(link.getCosmosId());
                    log.info("Successfully deleted expired road event with ID: {}", link.getRoadEventId());
                })
                .doOnError(error -> log.error("Failed to delete expired road event with ID: {}. Error: {}",
                        link.getRoadEventId(), error.getMessage()));
    }

    private Mono<Long[]> listExpiredRoadEvents() {
        Instant queryTime = Instant.now();
        return dataHubApi.getExpiredRoadEventsSince(lastQueryTime)
                .doOnError(error -> log.error("Error while fetching expired road events: {}", error.getMessage()))
                .doOnSuccess(signalType -> lastQueryTime = queryTime);
    }

    private List<CosmosIdLink> getCurrentRoadEventLinks() {
        return cosmosIdLinkRepository.findAll();
    }
}
