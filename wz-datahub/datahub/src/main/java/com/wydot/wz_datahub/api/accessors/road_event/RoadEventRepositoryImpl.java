package com.wydot.wz_datahub.api.accessors.road_event;

import com.wydot.wz_datahub.api.accessors.CustomCriteria;
import com.wydot.wz_datahub.api.accessors.PageableQuery;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventWrapper;

import lombok.extern.slf4j.Slf4j;

import org.bson.Document;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Component;

import java.time.Instant;
import java.util.Collections;
import java.util.List;
import java.util.Objects;

import com.wydot.wz_datahub.api.models.update_processing.ObservationSource;

@Slf4j
@Component
public class RoadEventRepositoryImpl
        implements RoadEventRepository, PageableQuery {

    private final MongoTemplate mongoTemplate;

    private final String COLLECTION_NAME = "road_events";
    private final String ID_FIELD = "roadEvent.id";
    private final String USER_ID_FIELD = "roadEvent.keycloakId";
    private final String EVENT_START_DATE_FIELD = "start_date";
    private final String EVENT_END_DATE_FIELD = "end_date";
    private final String OBSERVATION_VALID_FROM_FIELD = "observations.validFrom";
    private final String OBSERVATION_VALID_TO_FIELD = "observations.validTo";
    private final String OBSERVATION_SOURCE_FIELD = "observations.source";

    public RoadEventRepositoryImpl(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    public List<RoadEventWrapper> findAll() {
        List<Document> rawResults = mongoTemplate.findAll(Document.class, COLLECTION_NAME);

        // Parse documents into RoadEventWrapper, skipping invalid ones
        return rawResults.stream()
                .map(doc -> {
                    try {
                        return mongoTemplate.getConverter().read(RoadEventWrapper.class, doc);
                    } catch (Exception e) {
                        log.warn("Failed to parse document into RoadEventWrapper: {}", doc.getObjectId("_id"), e);
                        return null; // Skip invalid documents
                    }
                })
                .filter(Objects::nonNull) // Remove null entries
                .toList();
    }

    public Page<RoadEventWrapper> find(
            Long id,
            String userId,
            Long generatedStartTime,
            Long generatedEndTime,
            Long eventStartTimeMin,
            Long eventStartTimeMax,
            Long eventEndTimeMin,
            Long eventEndTimeMax,
            Pageable pageable) {
        Criteria criteria = new CustomCriteria()
                .whereOptional(ID_FIELD, id == null ? null : id.toString())
                .whereOptional(USER_ID_FIELD, userId)
                .withinTimeWindow(
                        EVENT_START_DATE_FIELD,
                        eventStartTimeMin,
                        eventStartTimeMax)
                .withinTimeWindow(
                        EVENT_END_DATE_FIELD,
                        eventEndTimeMin,
                        eventEndTimeMax);
        Sort sort = Sort.by(Sort.Direction.DESC, ID_FIELD);

        Page<Document> rawResults = findPage(mongoTemplate, COLLECTION_NAME, pageable, criteria, sort,
                Collections.emptyList(),
                Document.class);

        // Parse documents into RoadEventWrapper, skipping invalid ones
        List<RoadEventWrapper> results = rawResults.getContent().stream()
                .map(doc -> {
                    try {
                        return mongoTemplate.getConverter().read(RoadEventWrapper.class, doc);
                    } catch (Exception e) {
                        log.warn("Failed to parse document into RoadEventWrapper: {}", doc.getObjectId("_id"), e);
                        return null; // Skip invalid documents
                    }
                })
                .filter(Objects::nonNull) // Remove null entries
                .toList();

        return new PageImpl<RoadEventWrapper>(
                results,
                pageable, rawResults.getTotalElements());
    }

    public <T> Page<T> findProjection(
            Long id,
            String userId,
            Long generatedStartTime,
            Long generatedEndTime,
            Long eventStartTimeMin,
            Long eventStartTimeMax,
            Long eventEndTimeMin,
            Long eventEndTimeMax,
            Pageable pageable,
            Class<T> projectionClass) {
        Criteria criteria = new CustomCriteria()
                .whereOptional(ID_FIELD, id == null ? null : id.toString())
                .whereOptional(USER_ID_FIELD, userId)
                .withinTimeWindow(
                        EVENT_START_DATE_FIELD,
                        eventStartTimeMin,
                        eventStartTimeMax)
                .withinTimeWindow(
                        EVENT_END_DATE_FIELD,
                        eventEndTimeMin,
                        eventEndTimeMax);
        Sort sort = Sort.by(Sort.Direction.DESC, ID_FIELD);

        return findPage(mongoTemplate, COLLECTION_NAME, pageable, criteria, sort,
                Collections.emptyList(),
                projectionClass);
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
    public RoadEventWrapper findOne(
            Long id,
            String userId,
            Long generatedStartTime,
            Long generatedEndTime,
            Long eventStartTimeMin,
            Long eventStartTimeMax,
            Long eventEndTimeMin,
            Long eventEndTimeMax) {
        Criteria criteria = new CustomCriteria()
                .whereOptional(ID_FIELD, id == null ? null : id.toString())
                .whereOptional(USER_ID_FIELD, userId)
                .withinTimeWindow(
                        EVENT_START_DATE_FIELD,
                        eventStartTimeMin,
                        eventStartTimeMax)
                .withinTimeWindow(
                        EVENT_END_DATE_FIELD,
                        eventEndTimeMin,
                        eventEndTimeMax);

        Sort sort = Sort.by(Sort.Direction.DESC, ID_FIELD);

        Document result = mongoTemplate.findOne(new Query(criteria).with(sort),
                Document.class, COLLECTION_NAME);
        try {
            return mongoTemplate.getConverter().read(RoadEventWrapper.class, result);
        } catch (Exception e) {
            if (result != null) {
                log.warn("Failed to parse document into RoadEventWrapper: {}", result.getObjectId("_id"), e);
            }
            return null; // Skip invalid documents
        }
    }

    @Override
    public List<RoadEventWrapper> findRoadEventIdsWithExpiredObservations(Instant now) {
        if (now == null) {
            return List.of();
        }

        Criteria criteria = new Criteria().andOperator(
                Criteria.where(OBSERVATION_VALID_TO_FIELD).ne(null),
                Criteria.where(OBSERVATION_VALID_TO_FIELD).lt(now));
        Query query = new Query(criteria);

        List<Document> results = mongoTemplate.find(query, Document.class, COLLECTION_NAME);
        return parseRoadEventWrappers(results);
    }

    @Override
    public List<RoadEventWrapper> findRoadEventsWithRecentlyActiveObservations(Instant windowStart, Instant windowEnd) {
        if (windowStart == null || windowEnd == null || windowEnd.isBefore(windowStart)) {
            return List.of();
        }

        Criteria hasRecentValidFrom = new Criteria().andOperator(
                Criteria.where(OBSERVATION_VALID_FROM_FIELD).ne(null),
                Criteria.where(OBSERVATION_VALID_FROM_FIELD).gte(windowStart),
                Criteria.where(OBSERVATION_VALID_FROM_FIELD).lte(windowEnd));

        Criteria hasScheduleObservation = Criteria.where(OBSERVATION_SOURCE_FIELD)
                .in(
                        ObservationSource.WZAM_REPORT_SCHEDULE.name(),
                        ObservationSource.WZAM_RECORDING_SCHEDULE.name(),
                        ObservationSource.CON_ADMIN_SCHEDULE.name());

        Query query = new Query(new Criteria().orOperator(hasRecentValidFrom, hasScheduleObservation));
        List<Document> results = mongoTemplate.find(query, Document.class, COLLECTION_NAME);
        return parseRoadEventWrappers(results);
    }

    private List<RoadEventWrapper> parseRoadEventWrappers(List<Document> docs) {
        return docs.stream()
                .map(doc -> {
                    try {
                        return mongoTemplate.getConverter().read(RoadEventWrapper.class, doc);
                    } catch (Exception e) {
                        log.warn("Failed to parse document into RoadEventWrapper: {}", doc.getObjectId("_id"), e);
                        return null;
                    }
                })
                .filter(Objects::nonNull)
                .toList();
    }

    @Override
    public void update(Long id, RoadEventWrapper item) {
        Query query = new Query(Criteria.where(ID_FIELD).is(id.toString()));
        RoadEventWrapper replaced = mongoTemplate.findAndReplace(query, item, COLLECTION_NAME);
        if (replaced == null) {
            mongoTemplate.insert(item, COLLECTION_NAME);
        }
    }

    public void delete(Long id) {
        Query query = new Query(Criteria.where(ID_FIELD).is(id.toString()));
        mongoTemplate.remove(query, COLLECTION_NAME);
    }
}
