package com.wydot.wz_datahub.api.models.serialization;

import org.bson.Document;
import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.mongo.ProtobufMongoDeserializer;

import wyo.dot.protobuf.Project;

@Component
public class DocumentToProjectConverter implements Converter<Document, Project> {
    @Override
    public Project convert(Document document) {
        if (document == null) {
            return null;
        }

        return new ProtobufMongoDeserializer<>(Project.class).convert(document);
    }
}