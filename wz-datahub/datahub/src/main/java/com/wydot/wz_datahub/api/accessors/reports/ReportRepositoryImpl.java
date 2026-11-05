package com.wydot.wz_datahub.api.accessors.reports;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.accessors.CustomCriteria;
import com.wydot.wz_datahub.api.accessors.PageableQuery;
import com.wydot.wz_datahub.api.models.reports.ReportWithId;

import java.util.Collections;

@Component
public class ReportRepositoryImpl
        implements ReportRepository, PageableQuery {

    private final MongoTemplate mongoTemplate;

    private final String COLLECTION_NAME = "reports";
    private final String COUNTER_NAME = "report_counter";
    private final String ID_FIELD = "_id";
    private final String USER_ID_FIELD = "userId";
    private final String GENERATED_AT_DATE_FIELD = "timestamp";
    private final String ACTIVE_START_DATE_FIELD = "startDate";
    private final String ACTIVE_END_DATE_FIELD = "endDate";

    public ReportRepositoryImpl(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    /**
     * Get a page representing the count of data for a given id
     * and userId
     *
     * @param id     the report ID to query by, if null will not be
     *               applied
     * @param userId the submitter's user ID to query by, if null will not be
     *               applied
     * @return the paginated data that matches the given criteria
     */
    public long count(
            Long id,
            String userId,
            Long generatedStartTime,
            Long generatedEndTime,
            Long activeStartTime,
            Long activeEndTime) {
        Criteria criteria = new CustomCriteria()
                .whereOptional(ID_FIELD, id)
                .whereOptional(USER_ID_FIELD, userId)
                .withinTimeWindow(GENERATED_AT_DATE_FIELD,
                        generatedStartTime,
                        generatedEndTime)
                .rangeWithinTimeWindow(
                        ACTIVE_START_DATE_FIELD,
                        ACTIVE_END_DATE_FIELD,
                        activeStartTime, activeEndTime);
        Query query = Query.query(criteria);
        return mongoTemplate.count(query, COLLECTION_NAME);
    }

    /**
     * Get paginated data from a given id and userId
     *
     * @param id       the report ID to query by, if null will not be
     *                 applied
     * @param userId   the submitter's user ID to query by, if null will not be
     *                 applied
     * @param pageable the pageable object to use for pagination
     * @return the paginated data that matches the given criteria
     */
    public Page<ReportWithId> find(
            Long id,
            String userId,
            Long generatedStartTime,
            Long generatedEndTime,
            Long activeStartTime,
            Long activeEndTime,
            Pageable pageable) {
        Criteria criteria = new CustomCriteria()
                .whereOptional(ID_FIELD, id)
                .whereOptional(USER_ID_FIELD, userId)
                .withinTimeWindow(GENERATED_AT_DATE_FIELD,
                        generatedStartTime,
                        generatedEndTime)
                .rangeWithinTimeWindow(
                        ACTIVE_START_DATE_FIELD,
                        ACTIVE_END_DATE_FIELD,
                        activeStartTime, activeEndTime);
        Sort sort = Sort.by(Sort.Direction.DESC, ID_FIELD);
        return findPage(mongoTemplate, COLLECTION_NAME, pageable, criteria, sort, Collections.emptyList(),
                ReportWithId.class);
    }

    /**
     * Get an individual report from a given id and userId
     *
     * @param id     the report ID to query by, if null will not be
     *               applied
     * @param userId the submitter's user ID to query by, if null will not be
     *               applied
     * @return the paginated data that matches the given criteria
     */
    public ReportWithId findLatest(
            Long id,
            String userId,
            Long generatedStartTime,
            Long generatedEndTime,
            Long activeStartTime,
            Long activeEndTime) {
        Criteria criteria = new CustomCriteria()
                .whereOptional(ID_FIELD, id)
                .whereOptional(USER_ID_FIELD, userId)
                .withinTimeWindow(GENERATED_AT_DATE_FIELD,
                        generatedStartTime,
                        generatedEndTime)
                .rangeWithinTimeWindow(
                        ACTIVE_START_DATE_FIELD,
                        ACTIVE_END_DATE_FIELD,
                        activeStartTime, activeEndTime);
        Sort sort = Sort.by(Sort.Direction.DESC, ID_FIELD);
        return mongoTemplate.findOne(Query.query(criteria).with(sort), ReportWithId.class, COLLECTION_NAME);
    }

    @Override
    public void insert(ReportWithId item) {
        mongoTemplate.insert(item, COLLECTION_NAME);
    }

    @Override
    public void update(Long id, ReportWithId item, Boolean upsert) {
        Query query = new Query(Criteria.where(ID_FIELD).is(id));
        ReportWithId replaced = mongoTemplate.findAndReplace(query, item, COLLECTION_NAME);
        if (replaced == null && upsert) {
            this.insert(item);
        }
    }

    public long delete(Long id) {
        Query query = new Query(Criteria.where(ID_FIELD).is(id));
        return mongoTemplate.remove(query, COLLECTION_NAME).getDeletedCount();
    }

    // Service method to generate a unique ID
    public Long generateUniqueId() {
        return generateUniqueIdFromCounter(mongoTemplate, COUNTER_NAME);
    }

}
