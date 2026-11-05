package com.wydot.wz_datahub.api.models.serialization;

import org.bson.Document;
import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.mongo.ProtobufMongoDeserializer;

import wyo.dot.protobuf.RoadSubEvent;

@Component
public class DocumentToRoadSubEventConverter implements Converter<Document, RoadSubEvent> {
    @Override
    public RoadSubEvent convert(Document document) {
        if (document == null) {
            return null;
        }

        return new ProtobufMongoDeserializer<>(RoadSubEvent.class).convert(document);
    }
}