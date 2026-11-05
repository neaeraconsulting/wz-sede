package com.wydot.message_generator.models.wz.device_feed.properties.arrow_board;

import com.fasterxml.jackson.annotation.JsonProperty;

public enum ArrowBoardPattern {
    @JsonProperty("blank")
    BLANK,
    @JsonProperty("right-arrow-static")
    RIGHT_ARROW_STATIC,
    @JsonProperty("right-arrow-flashing")
    RIGHT_ARROW_FLASHING,
    @JsonProperty("right-arrow-sequential")
    RIGHT_ARROW_SEQUENTIAL,
    @JsonProperty("right-chevron-static")
    RIGHT_CHEVRON_STATIC,
    @JsonProperty("right-chevron-flashing")
    RIGHT_CHEVRON_FLASHING,
    @JsonProperty("right-chevron-sequential")
    RIGHT_CHEVRON_SEQUENTIAL,
    @JsonProperty("left-arrow-static")
    LEFT_ARROW_STATIC,
    @JsonProperty("left-arrow-flashing")
    LEFT_ARROW_FLASHING,
    @JsonProperty("left-arrow-sequential")
    LEFT_ARROW_SEQUENTIAL,
    @JsonProperty("left-chevron-static")
    LEFT_CHEVRON_STATIC,
    @JsonProperty("left-chevron-flashing")
    LEFT_CHEVRON_FLASHING,
    @JsonProperty("left-chevron-sequential")
    LEFT_CHEVRON_SEQUENTIAL,
    @JsonProperty("bidirectional-arrow-static")
    BIDIRECTIONAL_ARROW_STATIC,
    @JsonProperty("bidirectional-arrow-flashing")
    BIDIRECTIONAL_ARROW_FLASHING,
    @JsonProperty("line-flashing")
    LINE_FLASHING,
    @JsonProperty("diamonds-alternating")
    DIAMONDS_ALTERNATING,
    @JsonProperty("four-corners-flashing")
    FOUR_CORNERS_FLASHING,
    @JsonProperty("unknown")
    UNKNOWN;
}
