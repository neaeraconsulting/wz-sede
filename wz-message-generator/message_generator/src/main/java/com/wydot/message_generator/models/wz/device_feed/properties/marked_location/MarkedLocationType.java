package com.wydot.message_generator.models.wz.device_feed.properties.marked_location;

import com.fasterxml.jackson.annotation.JsonProperty;

public enum MarkedLocationType {
    @JsonProperty("afad")
    AUTOMATIC_FLAGGER_ASSISTANCE_DEVICE,
    @JsonProperty("delineator")
    DELINEATOR,
    @JsonProperty("flagger")
    FLAGGER,
    @JsonProperty("lane-shift")
    LANE_SHIFT,
    @JsonProperty("lane-closure")
    LANE_CLOSURE,
    @JsonProperty("personal-device")
    PERSONAL_DEVICE,
    @JsonProperty("ramp-closure")
    RAMP_CLOSURE,
    @JsonProperty("road-closure")
    ROAD_CLOSURE,
    @JsonProperty("road-event-start")
    ROAD_EVENT_START,
    @JsonProperty("road-event-end")
    ROAD_EVENT_END,
    @JsonProperty("work-truck-with-lights-flashing")
    WORK_TRUCK_WITH_LIGHTS_FLASHING,
    @JsonProperty("work-zone-start")
    WORK_ZONE_START,
    @JsonProperty("work-zone-end")
    WORK_ZONE_END;
}
