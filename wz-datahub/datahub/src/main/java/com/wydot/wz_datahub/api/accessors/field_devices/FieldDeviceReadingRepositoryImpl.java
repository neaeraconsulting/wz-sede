package com.wydot.wz_datahub.api.accessors.field_devices;

import org.bson.Document;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.Aggregation;
import org.springframework.data.mongodb.core.aggregation.AggregationResults;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.accessors.CustomCriteria;
import com.wydot.wz_datahub.api.accessors.PageableQuery;
import com.wydot.wz_datahub.api.models.field_devices.FieldDeviceReading;

import lombok.extern.slf4j.Slf4j;

import java.util.Collections;
import java.util.List;
import java.util.Objects;

@Slf4j
@Component
public class FieldDeviceReadingRepositoryImpl
        implements FieldDeviceReadingRepository, PageableQuery {

    private final MongoTemplate mongoTemplate;

    private final String COLLECTION_NAME = "field_device_readings";
    private final String ID_FIELD = "device.id";
    private final String GENERATED_AT_DATE_FIELD = "lastUpdated";

    public FieldDeviceReadingRepositoryImpl(MongoTemplate mongoTemplate) {
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
            String id,
            Long generatedStartTime,
            Long generatedEndTime) {
        Criteria criteria = new CustomCriteria()
                .whereOptional(ID_FIELD, id)
                .withinTimeWindow(GENERATED_AT_DATE_FIELD,
                        generatedStartTime,
                        generatedEndTime);
        Query query = Query.query(criteria);
        return mongoTemplate.count(query, COLLECTION_NAME);
    }

    /**
     * Finds the latest document in the collection that matches the given criteria.
     *
     * @param id                 the device ID to query by; if {@code null}, this
     *                           criterion will not be applied.
     * @param generatedStartTime the start of the time window for filtering; if
     *                           {@code null}, this criterion will not be applied.
     * @param generatedEndTime   the end of the time window for filtering; if
     *                           {@code null}, this criterion will not be applied.
     * @return the latest {@link FieldDeviceReading} matching the criteria, or
     *         {@code null} if no match is found.
     */
    public FieldDeviceReading findLatest(
            String id,
            Long generatedStartTime,
            Long generatedEndTime) {
        Criteria criteria = new CustomCriteria()
                .whereOptional(ID_FIELD, id)
                .withinTimeWindow(GENERATED_AT_DATE_FIELD,
                        generatedStartTime,
                        generatedEndTime);
        Query query = Query.query(criteria);
        Sort sort = Sort.by(Sort.Direction.DESC, GENERATED_AT_DATE_FIELD);
        Document result = mongoTemplate.findOne(query.with(sort), Document.class, COLLECTION_NAME);
        try {
            return mongoTemplate.getConverter().read(FieldDeviceReading.class, result);
        } catch (Exception e) {
            log.warn("Failed to parse document into RoadEventWrapper: {}", result.getObjectId("_id"), e);
            return null; // Skip invalid documents
        }
    }

    public List<FieldDeviceReading> findUnique(
            Long generatedStartTime,
            Long generatedEndTime) {
        Criteria criteria = new CustomCriteria()
                .withinTimeWindow(GENERATED_AT_DATE_FIELD, generatedStartTime, generatedEndTime);

        // Define the aggregation pipeline
        Aggregation aggregation = Aggregation.newAggregation(
                Aggregation.match(criteria), // Match the time window
                Aggregation.sort(Sort.by(Sort.Direction.DESC, GENERATED_AT_DATE_FIELD)), // Sort by generated date
                                                                                         // descending
                Aggregation.group(ID_FIELD) // Group by ID_FIELD
                        .first(Aggregation.ROOT).as("latestEntry"), // Take the latest entry for each ID
                Aggregation.replaceRoot("latestEntry") // Replace the root with the latest entry
        );

        // Execute the aggregation
        AggregationResults<Document> results = mongoTemplate.aggregate(aggregation, COLLECTION_NAME,
                Document.class);

        return results.getMappedResults().stream()
                .map(doc -> {
                    try {
                        return mongoTemplate.getConverter().read(FieldDeviceReading.class, doc);
                    } catch (Exception e) {
                        log.warn("Failed to parse document into FieldDeviceReading: {}", doc.getObjectId("_id"), e);
                        return null; // Skip invalid documents
                    }
                })
                .filter(Objects::nonNull) // Remove null entries
                .toList();
    }

    public List<FieldDeviceReading> findUniqueNonAvl(
            Long generatedStartTime,
            Long generatedEndTime) {
        Criteria criteria = new CustomCriteria() // Exclude documents where device.coreDetails.make is
                                                 // "AVL"
                .withinTimeWindow(GENERATED_AT_DATE_FIELD, generatedStartTime, generatedEndTime)
                .andOperator(Criteria.where("device.coreDetails.make").ne("WYDOT AVL"));

        // Define the aggregation pipeline
        Aggregation aggregation = Aggregation.newAggregation(
                Aggregation.match(criteria), // Match the time window
                Aggregation.sort(Sort.by(Sort.Direction.DESC, GENERATED_AT_DATE_FIELD)), // Sort by generated date
                                                                                         // descending
                Aggregation.group(ID_FIELD) // Group by ID_FIELD
                        .first(Aggregation.ROOT).as("latestEntry"), // Take the latest entry for each ID
                Aggregation.replaceRoot("latestEntry") // Replace the root with the latest entry
        );

        // Execute the aggregation
        AggregationResults<Document> results = mongoTemplate.aggregate(aggregation, COLLECTION_NAME,
                Document.class);

        return results.getMappedResults().stream()
                .map(doc -> {
                    try {
                        return mongoTemplate.getConverter().read(FieldDeviceReading.class, doc);
                    } catch (Exception e) {
                        log.warn("Failed to parse document into FieldDeviceReading: {}", doc.getObjectId("_id"), e);
                        return null; // Skip invalid documents
                    }
                })
                .filter(Objects::nonNull) // Remove null entries
                .toList();
    }

    /**
     * Finds paginated data in the collection that matches the given criteria.
     *
     * @param id                 the device ID to query by; if {@code null}, this
     *                           criterion will not be applied.
     * @param generatedStartTime the start of the time window for filtering; if
     *                           {@code null}, this criterion will not be applied.
     * @param generatedEndTime   the end of the time window for filtering; if
     *                           {@code null}, this criterion will not be applied.
     * @param pageable           the pageable object to use for pagination; must not
     *                           be {@code null}.
     * @return a {@link Page} of {@link FieldDeviceReading} objects matching the
     *         criteria.
     */
    public Page<FieldDeviceReading> find(
            String id,
            Long generatedStartTime,
            Long generatedEndTime,
            Pageable pageable) {
        Criteria criteria = new CustomCriteria()
                .whereOptional(ID_FIELD, id)
                .withinTimeWindow(GENERATED_AT_DATE_FIELD,
                        generatedStartTime,
                        generatedEndTime);
        Sort sort = Sort.by(Sort.Direction.DESC, ID_FIELD);
        Page<Document> pagedResults = findPage(mongoTemplate, COLLECTION_NAME, pageable, criteria, sort,
                Collections.emptyList(),
                Document.class);

        List<FieldDeviceReading> readings = pagedResults.getContent().stream()
                .map(doc -> {
                    try {
                        return mongoTemplate.getConverter().read(FieldDeviceReading.class, doc);
                    } catch (Exception e) {
                        log.warn("Failed to parse document into FieldDeviceReading: {}", doc.getObjectId("_id"), e);
                        return null; // Skip invalid documents
                    }
                })
                .filter(Objects::nonNull) // Remove null entries
                .toList();

        return new PageImpl<FieldDeviceReading>(
                readings,
                pageable, pagedResults.getTotalElements());
    }

    @Override
    public void insert(FieldDeviceReading item) {
        mongoTemplate.insert(item, COLLECTION_NAME);
    }
}
