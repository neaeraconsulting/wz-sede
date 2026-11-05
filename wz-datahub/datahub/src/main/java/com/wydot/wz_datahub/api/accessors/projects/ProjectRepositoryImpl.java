package com.wydot.wz_datahub.api.accessors.projects;

import com.wydot.wz_datahub.api.accessors.CustomCriteria;
import com.wydot.wz_datahub.api.accessors.PageableQuery;
import com.wydot.wz_datahub.api.models.wrappers.ProjectWrapper;
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

import java.util.List;
import java.util.Objects;

@Slf4j
@Component
public class ProjectRepositoryImpl
        implements ProjectRepository, PageableQuery {

    private final MongoTemplate mongoTemplate;

    private final String COLLECTION_NAME = "projects";
    private final String ID_FIELD = "project.id";
    private final String ACTIVE_START_DATE_FIELD = "project.start_date";
    private final String ACTIVE_END_DATE_FIELD = "project.end_date";

    public ProjectRepositoryImpl(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    /**
     * Get a page representing the count of data for a given id
     * and userId
     *
     * @param id     the project ID to query by, if null will not be
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
                .whereOptional(ID_FIELD, id == null ? null : id.toString())
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
     * @param id       the project ID to query by, if null will not be
     *                 applied
     * @param userId   the submitter's user ID to query by, if null will not be
     *                 applied
     * @param pageable the pageable object to use for pagination
     * @return the paginated data that matches the given criteria
     */
    public Page<ProjectWrapper> find(
            Long id,
            String userId,
            Long generatedStartTime,
            Long generatedEndTime,
            Long activeStartTime,
            Long activeEndTime,
            Pageable pageable) {
        Criteria criteria = new CustomCriteria()
                .whereOptional(ID_FIELD, id == null ? null : id.toString())
                .rangeWithinTimeWindow(
                        ACTIVE_START_DATE_FIELD,
                        ACTIVE_END_DATE_FIELD,
                        activeStartTime, activeEndTime);
        Sort sort = Sort.by(Sort.Direction.DESC, ID_FIELD);

        // Fetch all matching documents
        List<Document> rawResults = mongoTemplate.find(new Query(criteria).with(sort), Document.class, COLLECTION_NAME);

        // Parse documents into ProjectWrapper, skipping invalid ones
        List<ProjectWrapper> results = rawResults.stream()
                .map(doc -> {
                    try {
                        return mongoTemplate.getConverter().read(ProjectWrapper.class, doc);
                    } catch (Exception e) {
                        log.warn("Failed to parse document into ProjectWrapper: {}", doc.getObjectId("_id"), e);
                        return null; // Skip invalid documents
                    }
                })
                .filter(Objects::nonNull) // Remove null entries
                .toList();

        return new PageImpl<ProjectWrapper>(
                results,
                pageable, results.size());
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
            Long activeStartTime,
            Long activeEndTime) {
        Criteria criteria = new CustomCriteria()
                .whereOptional(ID_FIELD, id == null ? null : id)
                .rangeWithinTimeWindow(
                        ACTIVE_START_DATE_FIELD,
                        ACTIVE_END_DATE_FIELD,
                        activeStartTime, activeEndTime);
        Sort sort = Sort.by(Sort.Direction.DESC, ID_FIELD);

        Document result = mongoTemplate.findOne(new Query(criteria).with(sort),
                Document.class, COLLECTION_NAME);
        try {
            return mongoTemplate.getConverter().read(RoadEventWrapper.class, result);
        } catch (Exception e) {
            log.warn("Failed to parse document into RoadEventWrapper: {}", result.getObjectId("_id"), e);
            return null; // Skip invalid documents
        }
    }

    @Override
    public void update(Long id, ProjectWrapper item) {
        Query query = new Query(Criteria.where(ID_FIELD).is(id.toString()));
        ProjectWrapper replaced = mongoTemplate.findAndReplace(query, item, COLLECTION_NAME);
        if (replaced == null) {
            mongoTemplate.insert(item, COLLECTION_NAME);
        }
    }

    public void delete(Long id) {
        Query query = new Query(Criteria.where(ID_FIELD).is(id));
        mongoTemplate.remove(query, COLLECTION_NAME);
    }
}
