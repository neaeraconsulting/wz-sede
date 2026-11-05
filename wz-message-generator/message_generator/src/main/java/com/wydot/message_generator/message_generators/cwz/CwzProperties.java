package com.wydot.message_generator.message_generators.cwz;

import lombok.Data;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;
import org.springframework.lang.Nullable;

import com.wydot.message_generator.models.wz.cwz.FeedDataSource;

@Configuration
@ConfigurationProperties(prefix = "message-generation.cwz")
@Data
public class CwzProperties {
    private String contactName;
    private String contactEmail;
    private String publisher;
    private DataSourceProperties dataSource;

    @Data
    public static class DataSourceProperties {
        private String id;
        private String organizationName;
        private @Nullable Integer updateFrequency;
        private String contactName;
        private String contactEmail;

        public FeedDataSource getFeedDataSource() {
            return FeedDataSource.builder()
                    .dataSourceId(id)
                    .organizationName(organizationName)
                    .updateFrequency(updateFrequency)
                    .contactName(contactName)
                    .contactEmail(contactEmail)
                    .build();
        }
    }
}