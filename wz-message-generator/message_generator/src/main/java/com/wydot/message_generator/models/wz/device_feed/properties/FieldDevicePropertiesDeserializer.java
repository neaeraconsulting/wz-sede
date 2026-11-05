package com.wydot.message_generator.models.wz.device_feed.properties;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.JsonNode;
import com.wydot.message_generator.models.wz.device_feed.properties.arrow_board.ArrowBoard;
import com.wydot.message_generator.models.wz.device_feed.properties.camera.Camera;
import com.wydot.message_generator.models.wz.device_feed.properties.dynamic_message_sign.DynamicMessageSign;
import com.wydot.message_generator.models.wz.device_feed.properties.flashing_beacon.FlashingBeacon;
import com.wydot.message_generator.models.wz.device_feed.properties.hybrid_sign.HybridSign;
import com.wydot.message_generator.models.wz.device_feed.properties.marked_location.LocationMarker;
import com.wydot.message_generator.models.wz.device_feed.properties.traffic_sensor.TrafficSensor;
import com.wydot.message_generator.models.wz.device_feed.properties.traffic_signal.TrafficSignal;

import java.io.IOException;

public class FieldDevicePropertiesDeserializer extends JsonDeserializer<FieldDeviceProperties> {

    @Override
    public FieldDeviceProperties deserialize(JsonParser p, DeserializationContext ctxt) throws IOException {
        JsonNode node = p.getCodec().readTree(p);
        switch (node.get("core_details").get("device_type").asText()) {
            case "arrow-board":
                return p.getCodec().treeToValue(node, ArrowBoard.class);
            case "camera":
                return p.getCodec().treeToValue(node, Camera.class);
            case "dynamic-message-sign":
                return p.getCodec().treeToValue(node, DynamicMessageSign.class);
            case "flashing-beacon":
                return p.getCodec().treeToValue(node, FlashingBeacon.class);
            case "hybrid-sign":
                return p.getCodec().treeToValue(node, HybridSign.class);
            case "location-marker":
                return p.getCodec().treeToValue(node, LocationMarker.class);
            case "traffic-sensor":
                return p.getCodec().treeToValue(node, TrafficSensor.class);
            case "traffic-signal":
                return p.getCodec().treeToValue(node, TrafficSignal.class);
            default:
                throw new IllegalArgumentException("Unable to deserialize Message: Unknown structure");
        }
    }
}