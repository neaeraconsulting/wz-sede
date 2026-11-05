package com.wydot.wz_datahub.api.accessors.road_event;

import com.wydot.wz_datahub.api.accessors.CustomCriteria;
import com.wydot.wz_datahub.api.accessors.PageableQuery;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventAudit;

import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.FieldDevice;

import org.bson.Document;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Objects;

@Slf4j
@Component
public class RoadEventAuditRepositoryImpl
        implements RoadEventAuditRepository, PageableQuery {

    private final MongoTemplate mongoTemplate;

    private final String COLLECTION_NAME = "road_event_audits";
    private final String ROAD_EVENT_ID_FIELD = "roadEventId";
    private final String REQUEST_ID_FIELD = "requestId";
    private final String UPDATE_DATE_FIELD = "timestamp";

    public RoadEventAuditRepositoryImpl(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    /**
     * Get a page representing the count of data for a given id
     * and userId
     *
     * @param id     the road event ID to query by, if null will not be
     *               applied
     * @param userId the submitter's user ID to query by, if null will not be
     *               applied
     * @return the paginated data that matches the given criteria
     */
    public long count(
            Long roadEventId,
            Long requestId,
            Long updatedStartTime,
            Long updatedEndTime) {
        Criteria criteria = new CustomCriteria()
                .whereOptional(ROAD_EVENT_ID_FIELD, roadEventId)
                .whereOptional(REQUEST_ID_FIELD, requestId)
                .withinTimeWindow(
                        UPDATE_DATE_FIELD,
                        updatedStartTime, updatedEndTime);
        Query query = Query.query(criteria);
        return mongoTemplate.count(query, COLLECTION_NAME);
    }

    /**
     * Finds the latest document in the collection that matches the given criteria.
     *
     * @param id               the device ID to query by; if {@code null}, this
     *                         criterion will not be applied.
     * @param updatedStartTime the start of the time window for filtering; if
     *                         {@code null}, this criterion will not be applied.
     * @param updatedEndTime   the end of the time window for filtering; if
     *                         {@code null}, this criterion will not be applied.
     * @return the latest {@link FieldDevice} matching the criteria, or
     *         {@code null} if no match is found.
     */
    public RoadEventAudit findLatest(
            Long roadEventId,
            Long requestId,
            Long updatedStartTime,
            Long updatedEndTime) {
        Criteria criteria = new CustomCriteria()
                .whereOptional(ROAD_EVENT_ID_FIELD, roadEventId)
                .whereOptional(REQUEST_ID_FIELD, requestId)
                .withinTimeWindow(
                        UPDATE_DATE_FIELD,
                        updatedStartTime, updatedEndTime);
        Sort sort = Sort.by(Sort.Direction.DESC, UPDATE_DATE_FIELD);

        Document result = mongoTemplate.findOne(new Query(criteria).with(sort),
                Document.class, COLLECTION_NAME);
        if (result == null) {
            return null;
        }
        try {
            return mongoTemplate.getConverter().read(RoadEventAudit.class, result);
        } catch (Exception e) {
            log.warn("Failed to parse document into RoadEventAudit: {}", result.getObjectId("_id"), e);
            return null; // Skip invalid documents
        }
    }

    /**
     * Get paginated data from a given id and userId
     *
     * @param id       the road event ID to query by, if null will not be
     *                 applied
     * @param userId   the submitter's user ID to query by, if null will not be
     *                 applied
     * @param pageable the pageable object to use for pagination
     * @return the paginated data that matches the given criteria
     */
    public Page<RoadEventAudit> find(
            Long roadEventId,
            Long requestId,
            Long updatedStartTime,
            Long updatedEndTime,
            Pageable pageable) {
        Criteria criteria = new CustomCriteria()
                .whereOptional(ROAD_EVENT_ID_FIELD, roadEventId)
                .whereOptional(REQUEST_ID_FIELD, requestId)
                .withinTimeWindow(
                        UPDATE_DATE_FIELD,
                        updatedStartTime, updatedEndTime);
        Sort sort = Sort.by(Sort.Direction.DESC, UPDATE_DATE_FIELD);

        // Fetch all matching documents
        List<Document> rawResults = mongoTemplate.find(new Query(criteria).with(sort), Document.class, COLLECTION_NAME);

        // Parse documents into RoadEventAudit, skipping invalid ones
        List<RoadEventAudit> results = rawResults.stream()
                .map(doc -> {
                    try {
                        return mongoTemplate.getConverter().read(RoadEventAudit.class, doc);
                    } catch (Exception e) {
                        log.warn("Failed to parse document into RoadEventAudit: {}", doc.getObjectId("_id"), e);
                        return null; // Skip invalid documents
                    }
                })
                .filter(Objects::nonNull) // Remove null entries
                .toList();

        return new PageImpl<RoadEventAudit>(
                results,
                pageable, results.size());
    }

    @Override
    public void insert(RoadEventAudit item) {
        mongoTemplate.insert(item, COLLECTION_NAME);
    }
}
