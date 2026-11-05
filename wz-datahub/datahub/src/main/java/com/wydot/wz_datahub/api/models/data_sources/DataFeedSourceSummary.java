package com.wydot.wz_datahub.api.models.data_sources;

import java.time.Instant;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.wydot.wz_datahub.api.models.serialization.instant.InstantFromMillisDeserializer;
import com.wydot.wz_datahub.api.models.serialization.instant.InstantToMillisSerializer;

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

    public static DataFeedSourceSummary Icone() {
        return new DataFeedSourceSummary(DataFeedSourceType.ICONE, Instant.now());
    }

    public static DataFeedSourceSummary PiLit() {
        return new DataFeedSourceSummary(DataFeedSourceType.PI_LIT, Instant.now());
    }

    public static DataFeedSourceSummary VerMac() {
        return new DataFeedSourceSummary(DataFeedSourceType.VER_MAC, Instant.now());
    }

    public static DataFeedSourceSummary Wanco() {
        return new DataFeedSourceSummary(DataFeedSourceType.WANCO, Instant.now());
    }

    public static DataFeedSourceSummary Avl() {
        return new DataFeedSourceSummary(DataFeedSourceType.AVL, Instant.now());
    }

    public static DataFeedSourceSummary Wzam() {
        return new DataFeedSourceSummary(DataFeedSourceType.WZAM, Instant.now());
    }

    public static DataFeedSourceSummary ConAdmin() {
        return new DataFeedSourceSummary(DataFeedSourceType.CON_ADMIN, Instant.now());
    }
}
