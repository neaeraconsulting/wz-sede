package com.wydot.wz_datahub.api.models.wanco.sabp;

import com.fasterxml.jackson.annotation.JsonProperty;

public enum DisplayPattern {
    @JsonProperty("Off")
    OFF,

    @JsonProperty("Caution, Four Corner, flashing")
    CAUTION_FOUR_CORNER_FLASHING,

    @JsonProperty("Double Arrow, flashing")
    DOUBLE_ARROW_FLASHING,

    @JsonProperty("Caution, Bar, flashing")
    CAUTION_BAR_FLASHING,

    @JsonProperty("Right Arrow, flashing")
    RIGHT_ARROW_FLASHING,

    @JsonProperty("Left Arrow, flashing")
    LEFT_ARROW_FLASHING,

    @JsonProperty("Right Arrow, sequential")
    RIGHT_ARROW_SEQUENTIAL,

    @JsonProperty("Left Arrow, sequential")
    LEFT_ARROW_SEQUENTIAL,

    @JsonProperty("Right Stem Arrow, sequential")
    RIGHT_STEM_ARROW_SEQUENTIAL,

    @JsonProperty("Left Stem Arrow, sequential")
    LEFT_STEM_ARROW_SEQUENTIAL,

    @JsonProperty("Right Chevron, sequential")
    RIGHT_CHEVRON_SEQUENTIAL,

    @JsonProperty("Left Chevron, sequential")
    LEFT_CHEVRON_SEQUENTIAL,

    @JsonProperty("Caution, Alternating Diamonds, sequential")
    CAUTION_ALTERNATING_DIAMONDS_SEQUENTIAL,

    @JsonProperty("Test")
    TEST;
}