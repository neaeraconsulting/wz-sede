package com.wydot.message_generator.models.wz.cwz;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Enum representing the status of a lane.
 * 
 * @see <a href=
 *      "https://github.com/usdot-jpo-ode/wzdx/blob/main/spec-content/enumerated-types/LaneStatus.md">LaneStatus</a>
 */
public enum LaneStatus {
    @JsonProperty("open")
    OPEN,
    @JsonProperty("closed")
    CLOSED,
    @JsonProperty("merge-left")
    MERGE_LEFT,
    @JsonProperty("merge-right")
    MERGE_RIGHT,
    @JsonProperty("shift-left")
    SHIFT_LEFT,
    @JsonProperty("shift-right")
    SHIFT_RIGHT,
    @JsonProperty("alternating-flow")
    ALTERNATING_FLOW;
}
