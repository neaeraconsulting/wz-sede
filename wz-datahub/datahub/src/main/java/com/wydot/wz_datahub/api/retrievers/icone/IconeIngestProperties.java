package com.wydot.wz_datahub.api.retrievers.icone;

import java.time.Duration;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import lombok.Data;

@Component
@ConfigurationProperties(prefix = "ingest.icone")
@Data
public class IconeIngestProperties {
    private boolean enabled;
    private String url;
    private String apiKey;
    private Duration fetchInterval;
    private boolean updatesEnabled;
}
