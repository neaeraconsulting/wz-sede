package com.wydot.wz_datahub.api.mongo;

import com.google.protobuf.Message;
import com.google.protobuf.util.JsonFormat;

import org.bson.Document;
import org.springframework.core.convert.converter.Converter;
import org.springframework.data.convert.ReadingConverter;

@ReadingConverter
public class ProtobufMongoDeserializer<T extends Message> implements
        Converter<Document, T> {
    private final Class<T> clazz;

    public ProtobufMongoDeserializer(Class<T> clazz) {
        this.clazz = clazz;
    }

    @Override
    public T convert(Document source) {
        if (source == null) {
            return null;
        }
        try {
            // Remove the `_id` field to avoid deserialization issues
            source.remove("_id");

            // Convert MongoDB Document to JSON string
            String jsonString = source.toJson();

            // Convert JSON string to Protobuf object
            T.Builder builder = (T.Builder) clazz.getMethod("newBuilder").invoke(null);
            JsonFormat.parser().merge(jsonString, builder);
            return (T) builder.build();
        } catch (Exception e) {
            throw new RuntimeException("Failed to deserialize JSON to Protobuf object", e);
        }
    }
}