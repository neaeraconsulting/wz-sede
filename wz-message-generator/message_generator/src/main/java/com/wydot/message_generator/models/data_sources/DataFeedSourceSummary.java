package com.wydot.message_generator.models.data_sources;

import java.time.Instant;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.wydot.message_generator.models.serialization.instant.InstantFromMillisDeserializer;
import com.wydot.message_generator.models.serialization.instant.InstantToMillisSerializer;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class DataFeedSourceSummary {
    private DataFeedSourceType dataSourceType;
    @JsonSerialize(using = InstantToMillisSerializer.class)
    @JsonDeserialize(using = InstantFromMillisDeserializer.class)
    private Instant updateDate;
}
