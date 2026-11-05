package com.wydot.wz_datahub.api.models.serialization;

import org.bson.Document;
import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.mongo.ProtobufMongoDeserializer;

import wyo.dot.protobuf.FieldDevice;

@Component
public class DocumentToFieldDeviceConverter implements Converter<Document, FieldDevice> {
    @Override
    public FieldDevice convert(Document document) {
        if (document == null) {
            return null;
        }

        return new ProtobufMongoDeserializer<>(FieldDevice.class).convert(document);
    }
}