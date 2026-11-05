package com.wydot.wz_datahub.api.utilities.gis_service.cache;

import java.time.Duration;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import lombok.Data;

@Data
@Component
@ConfigurationProperties(prefix = "gis.cache")
public class GisCacheProperties {
    private boolean enabled = true;
    private int maxSize = 10000;
    private Duration expireAfter = Duration.ofDays(60);
}