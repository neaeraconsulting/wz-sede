package com.wydot.wz_datahub.api.accessors.raw;

import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.accessors.PageableQuery;
import com.wydot.wz_datahub.api.models.raw_data.RawDataWrapper;

@Component
public class RawDataRepositoryImpl
        implements RawDataRepository, PageableQuery {

    private final MongoTemplate mongoTemplate;

    public RawDataRepositoryImpl(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    public void insert(RawDataWrapper object) {
        mongoTemplate.insert(object, object.getType().getCollectionName());
    }
}