package com.wydot.message_generator.sdx;

import com.wydot.message_generator.models.wz.cwz.CwzFeed;

import reactor.core.publisher.Mono;

public interface SdxApiService {
    Mono<CwzFeed> getWorkZoneFeed();

    Mono<String> depositWorkZone(CwzFeed workZoneFeed);

    Mono<Void> updateWorkZone(String recordId, CwzFeed workZoneFeed);

    Mono<Void> deleteWorkZone(String recordId);
}