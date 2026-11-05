package com.wydot.wz_datahub.api.models.icone;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

// This class is used to deserialize a polyline string into a list of doubles.
// Example: 42.1238782,-76.2710492,42.1238782,-76.2710492
public class PolylineDeserializer extends JsonDeserializer<List<Double>> {
    @Override
    public List<Double> deserialize(JsonParser p, DeserializationContext context)
            throws IOException, JsonProcessingException {
        String polyline = p.getText();
        return Arrays.stream(polyline.split(","))
                .map(Double::parseDouble)
                .collect(Collectors.toList());
    }
}