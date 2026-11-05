package com.wydot.wz_datahub.api.models.accessors;

import lombok.Getter;
import lombok.Setter;
import org.bson.Document;

import java.util.List;

@Setter
@Getter
public class AggregationResult {
    private List<Document> results;
    private List<AggregationResultCount> metadata;
}