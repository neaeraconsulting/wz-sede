package com.wydot.wz_datahub.api.models.serialization;

import org.bson.Document;
import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Component;

import com.google.type.LatLng;

@Component
public class DocumentToLatLngConverter implements Converter<Document, LatLng> {

    @Override
    public LatLng convert(Document coordinates) {
        if (coordinates == null) {
            return null;
        }

        return LatLng.newBuilder()
                .setLatitude(coordinates.getDouble("latitude"))
                .setLongitude(coordinates.getDouble("longitude"))
                .build();
    }
}