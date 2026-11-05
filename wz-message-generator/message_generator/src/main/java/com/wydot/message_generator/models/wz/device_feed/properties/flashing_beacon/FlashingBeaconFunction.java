package com.wydot.message_generator.models.wz.device_feed.properties.flashing_beacon;

import com.fasterxml.jackson.annotation.JsonProperty;

public enum FlashingBeaconFunction {
    @JsonProperty("vehicle-entering")
    VEHICLE_ENTERING,
    @JsonProperty("queue-warning")
    QUEUE_WARNING,
    @JsonProperty("reduced-speed")
    REDUCED_SPEED,
    @JsonProperty("workers-present")
    WORKERS_PRESENT;
}
