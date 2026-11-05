
package com.wydot.wz_datahub.api.accessors.data_source;

import java.util.List;

import com.wydot.wz_datahub.api.models.data_sources.DataFeedSourceType;
import com.wydot.wz_datahub.api.models.data_sources.DataFeedSourceSummary;

public interface DataSourceSummaryRepository {
    DataFeedSourceSummary findOne(DataFeedSourceType dataSourceTyped);

    List<DataFeedSourceSummary> findAll();

    void update(DataFeedSourceSummary summary);
}