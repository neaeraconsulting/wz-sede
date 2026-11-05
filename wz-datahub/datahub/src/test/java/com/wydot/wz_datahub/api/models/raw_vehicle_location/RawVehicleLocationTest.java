package com.wydot.wz_datahub.api.models.raw_vehicle_location;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

import org.json.JSONException;
import org.junit.jupiter.api.Test;
import org.skyscreamer.jsonassert.JSONAssert;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

public class RawVehicleLocationTest {
    @Test
    public void testDeserializeSerializeWithData1() throws IOException, JSONException {
        // Load sample JSON data
        String json = new String(
                Files.readAllBytes(
                        Paths.get("src/test/resources/data/raw_vehicle_location/1234567890.json")));
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());

        RawVehicleLocation object = objectMapper.readValue(json, RawVehicleLocation.class);

        // Serialize results to JSON and compare with the original JSON
        String resultJson = objectMapper.writeValueAsString(object);

        // Compare JSON with ignored fields
        JSONAssert.assertEquals(json, resultJson, false);
    }

    @Test
    public void testDeserializeSerializeWithData2() throws IOException, JSONException {
        // Load sample JSON data
        String json = new String(
                Files.readAllBytes(
                        Paths.get("src/test/resources/data/raw_vehicle_location/4151001789.json")));
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());

        RawVehicleLocation object = objectMapper.readValue(json, RawVehicleLocation.class);

        // Serialize results to JSON and compare with the original JSON
        String resultJson = objectMapper.writeValueAsString(object);

        // Compare JSON with ignored fields
        JSONAssert.assertEquals(json, resultJson, false);
    }
}
