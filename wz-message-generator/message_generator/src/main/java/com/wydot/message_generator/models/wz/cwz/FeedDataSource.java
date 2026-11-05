package com.wydot.message_generator.models.wz.cwz;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Builder;
import lombok.Data;

/**
 * Class representing WZDx feed data source metadata.
 * 
 * @see <a
 *      href="https://github.com/usdot-jpo-ode/wzdx/blob/develop/spec-content/objects/FeedDataSource.md>FeedDataSource</a>
 */
@Data
@Builder
public class FeedDataSource {
    @JsonProperty("data_source_id")
    private String dataSourceId;
    @JsonProperty("organization_name")
    private String organizationName;
    @JsonProperty("update_date")
    private String updateDate;
    @JsonProperty("update_frequency")
    private Integer updateFrequency;
    @JsonProperty("contact_name")
    private String contactName;
    @JsonProperty("contact_email")
    private String contactEmail;
}
