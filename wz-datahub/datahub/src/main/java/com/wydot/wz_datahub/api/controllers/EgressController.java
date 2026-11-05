package com.wydot.wz_datahub.api.controllers;

import com.wydot.wz_datahub.api.models.wz.cwz.CwzFeed;
import com.wydot.wz_datahub.api.models.wz.wzdx.WorkZoneFeed;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;
// import us.dot.its.jpo.ode.plugin.j2735.timstorage.TravelerInformation;

import java.util.List;

@RestController
@RequestMapping("/output")
public class EgressController {

    @GetMapping("/wzdx")
    public Mono<WorkZoneFeed> getWorkZoneDataExchangeMessages() {
        return Mono.just(new WorkZoneFeed());
    }

    @GetMapping("/cwz")
    public Mono<CwzFeed> getConnectedWorkZoneMessages() {
        return Mono.just(new CwzFeed());
    }

    @GetMapping("/tim")
    public Mono<List<Object>> getTravelerInformationMessages() {
        return Mono.just(List.of());
    }

    @GetMapping("/rsm")
    public Mono<List<Object>> getRoadSafetyMessages() {
        return Mono.just(List.of());
    }
}
