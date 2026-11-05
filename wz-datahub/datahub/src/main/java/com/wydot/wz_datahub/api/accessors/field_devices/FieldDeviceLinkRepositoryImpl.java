package com.wydot.wz_datahub.api.accessors.field_devices;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.accessors.CustomCriteria;
import com.wydot.wz_datahub.api.accessors.PageableQuery;
import com.wydot.wz_datahub.api.models.field_devices.FieldDeviceLink;
import com.wydot.wz_datahub.api.models.raw_data.RawDataType;

import java.util.Collections;
import java.util.List;

@Component
public class FieldDeviceLinkRepositoryImpl
        implements FieldDeviceLinkRepository, PageableQuery {

    private final MongoTemplate mongoTemplate;

    private final String COLLECTION_NAME = "field_device_links";
    private final String DEVICE_ID_FIELD = "device_id";
    private final String PROJECT_ID_FIELD = "project_id";
    private final String ROAD_EVENT_ID_FIELD = "road_event_id";
    private final String GENERATED_AT_DATE_FIELD = "last_updated";
    private final String DEVICE_SOURCE_FIELD = "data_source";

    public FieldDeviceLinkRepositoryImpl(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    public long count(
            String deviceId,
            Long projectId,
            Long roadEventId,
            Long generatedStartTime,
            Long generatedEndTime) {
        Criteria criteria = new CustomCriteria()
                .whereOptional(DEVICE_ID_FIELD, deviceId)
                .whereOptional(PROJECT_ID_FIELD, projectId)
                .whereOptional(ROAD_EVENT_ID_FIELD, roadEventId)
                .withinTimeWindow(GENERATED_AT_DATE_FIELD,
                        generatedStartTime,
                        generatedEndTime);
        Query query = Query.query(criteria);
        return mongoTemplate.count(query, COLLECTION_NAME);
    }

    public Page<FieldDeviceLink> find(
            String deviceId,
            Long projectId,
            Long roadEventId,
            Long generatedStartTime,
            Long generatedEndTime,
            Pageable pageable) {
        Criteria criteria = new CustomCriteria()
                .whereOptional(DEVICE_ID_FIELD, deviceId)
                .whereOptional(PROJECT_ID_FIELD, projectId)
                .whereOptional(ROAD_EVENT_ID_FIELD, roadEventId)
                .withinTimeWindow(GENERATED_AT_DATE_FIELD,
                        generatedStartTime,
                        generatedEndTime);
        Sort sort = Sort.by(Sort.Direction.DESC, DEVICE_ID_FIELD);
        return findPage(mongoTemplate, COLLECTION_NAME, pageable, criteria, sort, Collections.emptyList(),
                FieldDeviceLink.class);
    }

    public Page<FieldDeviceLink> findNonAvl(
            String deviceId,
            Long projectId,
            Long roadEventId,
            Long generatedStartTime,
            Long generatedEndTime,
            Pageable pageable) {
        Criteria criteria = new CustomCriteria()
                .whereOptional(DEVICE_ID_FIELD, deviceId)
                .whereOptional(PROJECT_ID_FIELD, projectId)
                .whereOptional(ROAD_EVENT_ID_FIELD, roadEventId)
                .withinTimeWindow(GENERATED_AT_DATE_FIELD,
                        generatedStartTime,
                        generatedEndTime)
                .andOperator(Criteria.where(DEVICE_SOURCE_FIELD).ne("AVL_VEHICLE"));
        Sort sort = Sort.by(Sort.Direction.DESC, DEVICE_ID_FIELD);
        return findPage(mongoTemplate, COLLECTION_NAME, pageable, criteria, sort, Collections.emptyList(),
                FieldDeviceLink.class);
    }

    public FieldDeviceLink findOne(String deviceId) {
        Query query = new Query(Criteria.where(DEVICE_ID_FIELD).is(deviceId));
        return mongoTemplate.findOne(query, FieldDeviceLink.class);
    }

    public List<FieldDeviceLink> findByDeviceSource(RawDataType source) {
        Query query = new Query(Criteria.where(DEVICE_SOURCE_FIELD).is(source));
        return mongoTemplate.find(query, FieldDeviceLink.class);
    }

    @Override
    public void update(String deviceId, FieldDeviceLink item) {
        Query query = new Query(Criteria.where(DEVICE_ID_FIELD).is(deviceId));
        FieldDeviceLink replaced = mongoTemplate.findAndReplace(query, item, COLLECTION_NAME);
        if (replaced == null) {
            mongoTemplate.insert(item, COLLECTION_NAME);
        }
    }

    public void delete(String deviceId) {
        Query query = new Query(Criteria.where(DEVICE_ID_FIELD).is(deviceId));
        mongoTemplate.remove(query, COLLECTION_NAME);
    }
}
