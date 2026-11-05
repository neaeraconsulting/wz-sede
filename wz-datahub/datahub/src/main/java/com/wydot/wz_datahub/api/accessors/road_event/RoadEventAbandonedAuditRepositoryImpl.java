package com.wydot.wz_datahub.api.accessors.road_event;

import com.wydot.wz_datahub.api.accessors.PageableQuery;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventAbandonedAudit;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class RoadEventAbandonedAuditRepositoryImpl
        implements RoadEventAbandonedAuditRepository, PageableQuery {

    private final MongoTemplate mongoTemplate;

    private final String COLLECTION_NAME = "road_event_abandoned_audits";

    @Override
    public void insert(RoadEventAbandonedAudit item) {
        mongoTemplate.insert(item, COLLECTION_NAME);
    }
}
