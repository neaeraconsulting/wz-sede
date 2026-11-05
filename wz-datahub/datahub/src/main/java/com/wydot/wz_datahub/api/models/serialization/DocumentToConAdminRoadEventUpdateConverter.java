package com.wydot.wz_datahub.api.models.serialization;

import org.bson.Document;
import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.mongo.ProtobufMongoDeserializer;

import wyo.dot.protobuf.conadmin.ConAdminRoadEventUpdate;

@Component
public class DocumentToConAdminRoadEventUpdateConverter implements Converter<Document, ConAdminRoadEventUpdate> {
    @Override
    public ConAdminRoadEventUpdate convert(Document document) {
        if (document == null) {
            return null;
        }

        return new ProtobufMongoDeserializer<>(ConAdminRoadEventUpdate.class).convert(document);
    }
}