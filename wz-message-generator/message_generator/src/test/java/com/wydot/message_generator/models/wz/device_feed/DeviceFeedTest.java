package com.wydot.message_generator.models.wz.device_feed;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

import org.json.JSONException;
import org.junit.jupiter.api.Test;
import org.skyscreamer.jsonassert.JSONAssert;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

public class DeviceFeedTest {
    @Test
    public void testDeserializeSerializeWithData() throws IOException, JSONException {
        // Load sample JSON data
        String json = new String(
                Files.readAllBytes(
                        Paths.get("src/test/resources/data/device_feed_ver_mac_2025_07_08.json")));
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());

        DeviceFeed object = objectMapper.readValue(json, DeviceFeed.class);

        // Serialize results to JSON and compare with the original JSON
        String resultJson = objectMapper.writeValueAsString(object);

        // Compare JSON with ignored fields
        JSONAssert.assertEquals(json, resultJson, false);
    }
}
