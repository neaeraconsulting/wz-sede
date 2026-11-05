package com.wydot.message_generator.accessors.cwz;

import lombok.extern.slf4j.Slf4j;

import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Component;

import com.wydot.message_generator.models.wz.cwz.CwzFeedWrapper;

@Slf4j
@Component
public class CwzRepositoryImpl
        implements CwzRepository {

    private final MongoTemplate mongoTemplate;

    private final String COLLECTION_NAME = "generated_cwz_messages";

    public CwzRepositoryImpl(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    @Override
    public void insert(CwzFeedWrapper item) {
        try {
            log.debug("Inserting CWZ document into collection: {}", COLLECTION_NAME);
            log.debug("Document details - ID: {}, Timestamp: {}",
                    item.getRoadEvent() != null ? item.getRoadEvent().getId() : "null",
                    item.getTimestamp());

            CwzFeedWrapper result = mongoTemplate.insert(item, COLLECTION_NAME);
            log.info("Successfully inserted CWZ document with road event ID: {}",
                    result.getRoadEvent() != null ? result.getRoadEvent().getId() : "null");
        } catch (Exception e) {
            log.error("Failed to insert CWZ document: {}", e.getMessage(), e);
            throw e; // Re-throw to maintain error propagation
        }
    }
}
