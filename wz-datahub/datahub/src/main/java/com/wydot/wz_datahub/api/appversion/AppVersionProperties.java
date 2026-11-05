package com.wydot.wz_datahub.api.appversion;

import lombok.Data;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConfigurationProperties(prefix = "app-version")
@Data
public class AppVersionProperties {
    private String minimumVersion;
    private String latestVersion;
}
