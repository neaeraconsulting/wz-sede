package com.wydot.message_generator.models.serialization.instant;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import java.io.IOException;
import java.time.Instant;

public class InstantFromIsoString extends JsonDeserializer<Instant> {
    @Override
    public Instant deserialize(JsonParser p, DeserializationContext ctxt) throws IOException {
        if (p == null) {
            return null;
        }
        String text = p.getText();

        // Check if the string lacks a timezone (e.g., no 'Z', '+' or '-' after the
        // time)
        // regex matches a string like "2023-10-05T14:48:00+02:00"
        if (!text.endsWith("Z") && !text.matches(".*[+-]\\d{2}:?\\d{2}$")) {
            // If no timezone info, assume UTC and add "Z"
            text += "Z";
        }
        return Instant.parse(text);
    }
}
