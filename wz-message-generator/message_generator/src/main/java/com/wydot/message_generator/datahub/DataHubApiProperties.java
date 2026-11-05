package com.wydot.message_generator.datahub;

import lombok.Data;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConfigurationProperties(prefix = "datahub-api")
@Data
public class DataHubApiProperties {
    private String endpoint;
}