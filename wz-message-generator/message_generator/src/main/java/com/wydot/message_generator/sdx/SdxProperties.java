package com.wydot.message_generator.sdx;

import lombok.Data;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConfigurationProperties(prefix = "sdx")
@Data
public class SdxProperties {
    private Boolean enabled;
    private String endpoint;
    private String accessToken;
}
