package com.wydot.message_generator.accessors.cosmos_id_link;

import java.util.List;

import org.bson.Document;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Component;

import com.wydot.message_generator.accessors.CustomCriteria;
import com.wydot.message_generator.models.sdx.CosmosIdLink;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class CosmosIdLinkRepositoryImpl
        implements CosmosIdLinkRepository {

    private final MongoTemplate mongoTemplate;

    private final String COLLECTION_NAME = "sdx_cosmos_id_links";
    private final String COSMOS_ID_FIELD = "cosmosId";
    private final String ROAD_EVENT_ID_FIELD = "roadEventId";

    public CosmosIdLinkRepositoryImpl(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    public List<CosmosIdLink> findAll() {
        return mongoTemplate.findAll(CosmosIdLink.class, COLLECTION_NAME);
    }

    public CosmosIdLink findOne(
            String cosmosId,
            Long roadEventId) {
        Criteria criteria = new CustomCriteria()
                .whereOptional(COSMOS_ID_FIELD, cosmosId)
                .whereOptional(ROAD_EVENT_ID_FIELD, roadEventId);
        Sort sort = Sort.by(Sort.Direction.DESC, ROAD_EVENT_ID_FIELD);

        Document result = mongoTemplate.findOne(new Query(criteria).with(sort),
                Document.class, COLLECTION_NAME);

        if (result == null) {
            return null;
        }

        try {
            return mongoTemplate.getConverter().read(CosmosIdLink.class, result);
        } catch (Exception e) {
            log.warn("Failed to parse document into CosmosIdLink: {}", result.getObjectId("_id"), e);
            return null; // Skip invalid documents
        }
    }

    @Override
    public void insert(CosmosIdLink item) {
        mongoTemplate.insert(item, COLLECTION_NAME);
    }

    public void delete(String cosmosId) {
        Query query = new Query(Criteria.where(COSMOS_ID_FIELD).is(cosmosId));
        mongoTemplate.remove(query, COLLECTION_NAME);
    }
}
