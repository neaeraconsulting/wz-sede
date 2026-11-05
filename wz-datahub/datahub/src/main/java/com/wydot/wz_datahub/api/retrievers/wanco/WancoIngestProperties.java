package com.wydot.wz_datahub.api.retrievers.wanco;

import java.time.Duration;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import lombok.Data;

@Component
@ConfigurationProperties(prefix = "ingest.wanco")
@Data
public class WancoIngestProperties {
    private boolean enabled;
    private boolean sabpEnabled;
    private String url;
    private String apiKey;
    private Duration tokenLifespan = Duration.ofMinutes(15);
    private Duration fetchInterval;
    private boolean updatesEnabled;
}
