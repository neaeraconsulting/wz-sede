package com.wydot.wz_datahub.api.retrievers.pi_lit;

import java.time.Duration;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import lombok.Data;

@Component
@ConfigurationProperties(prefix = "ingest.pi-lit")
@Data
public class PiLitIngestProperties {
    private boolean enabled;
    private String url;
    private Duration tokenLifespan;
    private String username;
    private String password;
    private Duration fetchInterval;
    private boolean updatesEnabled;
}
