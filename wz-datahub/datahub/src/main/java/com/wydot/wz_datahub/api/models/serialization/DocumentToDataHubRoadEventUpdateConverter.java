package com.wydot.wz_datahub.api.models.serialization;

import org.bson.Document;
import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.mongo.ProtobufMongoDeserializer;

import wyo.dot.protobuf.DataHubRoadEventUpdate;

@Component
public class DocumentToDataHubRoadEventUpdateConverter implements Converter<Document, DataHubRoadEventUpdate> {
    @Override
    public DataHubRoadEventUpdate convert(Document document) {
        if (document == null) {
            return null;
        }

        return new ProtobufMongoDeserializer<>(DataHubRoadEventUpdate.class).convert(document);
    }
}