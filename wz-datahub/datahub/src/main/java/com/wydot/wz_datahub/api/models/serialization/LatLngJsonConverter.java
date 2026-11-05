package com.wydot.wz_datahub.api.models.serialization;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.google.type.LatLng;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

// Assuming LatLng is com.google.type.LatLng or similar
public class LatLngJsonConverter {

    public static LatLng fromJson(List<?> json) {
        // Dart: LatLng(json[1] as double, json[0] as double);
        return LatLng.newBuilder()
                .setLatitude(((Number) json.get(1)).doubleValue())
                .setLongitude(((Number) json.get(0)).doubleValue())
                .build();
    }

    public static List<Object> toJson(LatLng latLng) {
        // Dart: [latLng.longitude, latLng.latitude]
        List<Object> list = new ArrayList<>();
        list.add(latLng.getLongitude());
        list.add(latLng.getLatitude());
        return list;
    }

    public static List<LatLng> fromJsonList(List<?> json) {
        List<LatLng> result = new ArrayList<>();
        for (Object item : json) {
            result.add(fromJson((List<?>) item));
        }
        return result;
    }

    public static List<List<Object>> toJsonList(List<LatLng> geometry) {
        List<List<Object>> result = new ArrayList<>();
        for (LatLng latLng : geometry) {
            result.add(toJson(latLng));
        }
        return result;
    }

    public static class LatLngSerializer extends JsonSerializer<LatLng> {
        @Override
        public void serialize(LatLng value, JsonGenerator gen, SerializerProvider serializers) throws IOException {
            gen.writeStartArray();
            gen.writeNumber(value.getLongitude());
            gen.writeNumber(value.getLatitude());
            gen.writeEndArray();
        }
    }

    public static class LatLngDeserializer extends JsonDeserializer<LatLng> {
        @Override
        public LatLng deserialize(JsonParser p, DeserializationContext ctxt)
                throws IOException, JsonProcessingException {
            List<?> coords = p.readValueAs(List.class);
            return fromJson(coords);
        }
    }

    public static class LatLngListSerializer extends JsonSerializer<List<LatLng>> {
        @Override
        public void serialize(List<LatLng> value, JsonGenerator gen, SerializerProvider serializers)
                throws IOException {
            gen.writeStartArray();
            for (LatLng latLng : value) {
                gen.writeStartArray();
                gen.writeNumber(latLng.getLongitude());
                gen.writeNumber(latLng.getLatitude());
                gen.writeEndArray();
            }
            gen.writeEndArray();
        }
    }

    public static class LatLngListDeserializer extends JsonDeserializer<List<LatLng>> {
        @Override
        public List<LatLng> deserialize(JsonParser p, DeserializationContext ctxt)
                throws IOException, JsonProcessingException {
            List<?> raw = p.readValueAs(List.class);
            List<LatLng> result = new ArrayList<>();
            for (Object item : raw) {
                List<?> coords = (List<?>) item;
                result.add(fromJson(coords));
            }
            return result;
        }
    }
}