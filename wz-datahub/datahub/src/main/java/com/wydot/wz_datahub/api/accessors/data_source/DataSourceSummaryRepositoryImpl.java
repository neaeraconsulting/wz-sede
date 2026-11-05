package com.wydot.wz_datahub.api.accessors.data_source;

import lombok.extern.slf4j.Slf4j;

import java.util.List;

import org.bson.Document;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.accessors.CustomCriteria;
import com.wydot.wz_datahub.api.models.data_sources.DataFeedSourceType;
import com.wydot.wz_datahub.api.models.data_sources.DataFeedSourceSummary;

@Slf4j
@Component
public class DataSourceSummaryRepositoryImpl
        implements DataSourceSummaryRepository {

    private final MongoTemplate mongoTemplate;

    private final String COLLECTION_NAME = "data_source_summaries";
    private final String DATA_SOURCE_TYPE_FIELD = "dataSourceType";

    public DataSourceSummaryRepositoryImpl(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    public DataFeedSourceSummary findOne(
            DataFeedSourceType dataSourceType) {
        Criteria criteria = new CustomCriteria()
                .whereOptional(DATA_SOURCE_TYPE_FIELD, dataSourceType);
        Sort sort = Sort.by(Sort.Direction.DESC, DATA_SOURCE_TYPE_FIELD);

        Document result = mongoTemplate.findOne(new Query(criteria).with(sort),
                Document.class, COLLECTION_NAME);
        try {
            return mongoTemplate.getConverter().read(DataFeedSourceSummary.class, result);
        } catch (Exception e) {
            log.warn("Failed to parse document into FeedDataSourceSummary: {}", result.getObjectId("_id"), e);
            return null; // Skip invalid documents
        }
    }

    public List<DataFeedSourceSummary> findAll() {
        return mongoTemplate.find(
                new Query(),
                DataFeedSourceSummary.class,
                COLLECTION_NAME);
    }

    public void update(DataFeedSourceSummary summary) {
        Query query = new Query(Criteria.where(DATA_SOURCE_TYPE_FIELD).is(summary.getDataSourceType()));
        DataFeedSourceSummary replaced = mongoTemplate.findAndReplace(query, summary, COLLECTION_NAME);
        if (replaced == null) {
            mongoTemplate.insert(summary, COLLECTION_NAME);
        }
    }
}
