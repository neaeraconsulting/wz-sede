package com.wydot.wz_datahub.api.models.serialization;

import org.bson.Document;
import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.mongo.ProtobufMongoDeserializer;

import wyo.dot.protobuf.RoadEvent;

@Component
public class DocumentToRoadEventConverter implements Converter<Document, RoadEvent> {
    @Override
    public RoadEvent convert(Document document) {
        if (document == null) {
            return null;
        }

        return new ProtobufMongoDeserializer<>(RoadEvent.class).convert(document);
    }
}