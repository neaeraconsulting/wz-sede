package com.wydot.message_generator.models.wz.cwz;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Builder;
import lombok.Data;

/**
 * Class representing WZDx feed info metadata.
 * 
 * @see <a
 *      href="https://github.com/usdot-jpo-ode/wzdx/blob/develop/spec-content/objects/FeedInfo.md>FeedInfo</a>
 */
@Data
@Builder
public class FeedInfo {
    @JsonProperty("publisher")
    private String publisher;
    @JsonProperty("version")
    private String version;
    @JsonProperty("license")
    private String license;
    @JsonProperty("data_sources")
    private List<FeedDataSource> dataSources;
    @JsonProperty("update_date")
    private String updateDate;
    @JsonProperty("update_frequency")
    private Integer updateFrequency;
    @JsonProperty("contact_name")
    private String contactName;
    @JsonProperty("contact_email")
    private String contactEmail;
}
