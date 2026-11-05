package com.wydot.wz_datahub.api.controllers.kafka;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.wydot.wz_datahub.api.accessors.road_event.RoadEventRepository;
import com.wydot.wz_datahub.api.kafka.KafkaTopics;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventWrapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;
import wyo.dot.protobuf.CreateRoadEvent;

@RestController
@Slf4j
@RequestMapping("/kafka")
@RequiredArgsConstructor
public class MessageGeneratorSyncController {
    private final RoadEventRepository roadEventRepository;

    @Autowired
    private KafkaTemplate<String, CreateRoadEvent> template;

    @PreAuthorize("hasRole('ROLE_ADMIN') || hasRole('ROLE_SERVICE')")
    @PostMapping("/message_generator_sync")
    public Mono<List<Long>> syncAllRoadEvents(
            @RequestParam(name = "road_event_id", required = false) Long roadEventId) {
        List<RoadEventWrapper> roadEvents = new ArrayList<>();
        if (roadEventId != null) {
            RoadEventWrapper roadEvent = roadEventRepository.findOne(roadEventId, null, null, null, null,
                    null, null, null);
            roadEvents.add(roadEvent);
        } else {
            roadEvents.addAll(roadEventRepository.findAll());
        }

        for (RoadEventWrapper roadEvent : roadEvents) {
            CreateRoadEvent createRoadEvent = CreateRoadEvent.newBuilder()
                    .setRoadEvent(roadEvent.getRoadEvent())
                    .addAllRoadSubEvents(
                            roadEvent.getRoadSubEvents().stream().map(rse -> rse.getRoadSubEvent()).toList())
                    .build();
            Long id = createRoadEvent.getRoadEvent().getId();
            this.template.send(KafkaTopics.MESSAGE_GENERATOR_SYNC, String.valueOf(id), createRoadEvent);
        }
        return Mono.just(roadEvents.stream().map(re -> re.getRoadEvent().getId()).collect(Collectors.toList()));
    }
}
