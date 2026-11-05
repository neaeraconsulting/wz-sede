package com.wydot.wz_datahub.api.mongo;

import com.google.protobuf.Message;
import com.google.protobuf.util.JsonFormat;

import org.bson.Document;
import org.springframework.core.convert.converter.Converter;

public class ProtobufMongoSerializer<T extends Message> implements
        Converter<T, Document> {
    @Override
    public Document convert(T source) {
        if (source == null) {
            return null;
        }
        try {
            // Convert Protobuf object to JSON string
            String jsonString = JsonFormat.printer().print(source);

            // Convert JSON string to MongoDB Document
            return Document.parse(jsonString);
        } catch (Exception e) {
            throw new RuntimeException("Failed to serialize Protobuf object to JSON", e);
        }
    }
}