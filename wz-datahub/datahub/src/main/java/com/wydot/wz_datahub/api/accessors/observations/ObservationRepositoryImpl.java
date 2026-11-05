package com.wydot.wz_datahub.api.accessors.observations;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.bson.Document;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.Aggregation;
import org.springframework.data.mongodb.core.aggregation.AggregationResults;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.accessors.CustomCriteria;
import com.wydot.wz_datahub.api.accessors.PageableQuery;
import com.wydot.wz_datahub.api.models.update_processing.Observation;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

@Component
public class ObservationRepositoryImpl
        implements ObservationRepository, PageableQuery {

    private final MongoTemplate mongoTemplate;

    private final String COLLECTION_NAME = "road_event_observations";
    private final String SOURCE_ID_FIELD = "sourceId";
    private final String ROAD_EVENT_ID_FIELD = "roadEventId";
    private final String VALID_FROM_FIELD = "validFrom";
    private final String VALID_TO_FIELD = "validTo";

    TypeReference<Observation<?>> observationTypeReference = new TypeReference<>() {
    };
    private ObjectMapper mapper = new ObjectMapper().configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES,
            false);

    public ObservationRepositoryImpl(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    /**
     * Counts the number of documents in the collection that match the given
     * criteria.
     *
     * @param id                 the device ID to query by; if {@code null}, this
     *                           criterion will not be applied.
     * @param generatedStartTime the start of the time window for filtering; if
     *                           {@code null}, this criterion will not be applied.
     * @param generatedEndTime   the end of the time window for filtering; if
     *                           {@code null}, this criterion will not be applied.
     * @return the count of documents matching the criteria.
     */
    public long count(
            String roadEventId,
            String sourceId,
            Instant activeDate) {
        Criteria criteria = new CustomCriteria()
                .whereOptional(ROAD_EVENT_ID_FIELD, roadEventId)
                .whereOptional(SOURCE_ID_FIELD, sourceId)
                .timestampWithinWindow(VALID_FROM_FIELD, VALID_TO_FIELD, activeDate);
        Query query = Query.query(criteria);
        return mongoTemplate.count(query, COLLECTION_NAME);
    }

    public List<Observation<?>> findUnique(
            String roadEventId,
            String sourceId,
            Instant activeDate) {
        Criteria criteria = new CustomCriteria()
                .whereOptional(ROAD_EVENT_ID_FIELD, roadEventId)
                .whereOptional(SOURCE_ID_FIELD, sourceId)
                .timestampWithinWindow(VALID_FROM_FIELD, VALID_TO_FIELD, activeDate);

        // Define the aggregation pipeline
        Aggregation aggregation = Aggregation.newAggregation(
                Aggregation.match(criteria), // Match the time window
                Aggregation.sort(Sort.by(Sort.Direction.DESC, VALID_FROM_FIELD)), // Sort by generated date
                                                                                  // descending
                Aggregation.group(SOURCE_ID_FIELD) // Group by ID_FIELD
                        .first(Aggregation.ROOT).as("latestEntry"), // Take the latest entry for each ID
                Aggregation.replaceRoot("latestEntry") // Replace the root with the latest entry
        );

        // Execute the aggregation
        AggregationResults<Document> results = mongoTemplate.aggregate(aggregation, COLLECTION_NAME,
                Document.class);

        List<Document> documents = results.getMappedResults();
        return documents.stream()
                .<Observation<?>>map(doc -> mapper.convertValue(doc, observationTypeReference))
                .toList();
    }

        @Override
        public List<Long> findRoadEventIdsWithExpiredObservations(Instant now) {
                if (now == null) {
                        return List.of();
                }

                Criteria criteria = new Criteria().andOperator(
                                Criteria.where(VALID_TO_FIELD).ne(null),
                                Criteria.where(VALID_TO_FIELD).lt(now),
                                Criteria.where(ROAD_EVENT_ID_FIELD).ne(null));

                Aggregation aggregation = Aggregation.newAggregation(
                                Aggregation.match(criteria),
                                Aggregation.group(ROAD_EVENT_ID_FIELD),
                                Aggregation.project().and("_id").as(ROAD_EVENT_ID_FIELD));

                AggregationResults<Document> results = mongoTemplate.aggregate(aggregation, COLLECTION_NAME, Document.class);

                List<Long> roadEventIds = new ArrayList<>();
                for (Document doc : results.getMappedResults()) {
                        Object rawId = doc.get(ROAD_EVENT_ID_FIELD);
                        if (rawId instanceof Number number) {
                                roadEventIds.add(number.longValue());
                        } else if (rawId instanceof String value) {
                                try {
                                        roadEventIds.add(Long.parseLong(value));
                                } catch (NumberFormatException ignored) {
                                        // skip invalid ID format
                                }
                        }
                }
                return roadEventIds;
        }

    @Override
    public void insert(Observation<?> item) {
        mongoTemplate.insert(item, COLLECTION_NAME);
    }
}
