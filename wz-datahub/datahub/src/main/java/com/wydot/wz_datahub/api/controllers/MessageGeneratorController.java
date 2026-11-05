package com.wydot.wz_datahub.api.controllers;

import com.wydot.wz_datahub.api.accessors.data_source.DataSourceSummaryRepository;
import com.wydot.wz_datahub.api.models.data_sources.DataFeedSourceSummary;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.List;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import reactor.core.publisher.Mono;

@Slf4j
@RestController
@RequestMapping("/message-generator")
@RequiredArgsConstructor
public class MessageGeneratorController {
    private final DataSourceSummaryRepository dataSourceSummaryRepository;

    @PreAuthorize("hasRole('ROLE_SERVICE')")
    @GetMapping("/data-source-summaries")
    public Mono<List<DataFeedSourceSummary>> getDataFeedSummaries() {
        return Mono.just(dataSourceSummaryRepository.findAll());
    }
}
