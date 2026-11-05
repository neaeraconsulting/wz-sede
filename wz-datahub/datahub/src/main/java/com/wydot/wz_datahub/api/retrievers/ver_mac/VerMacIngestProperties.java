package com.wydot.wz_datahub.api.retrievers.ver_mac;

import java.time.Duration;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import lombok.Data;

@Component
@ConfigurationProperties(prefix = "ingest.ver-mac")
@Data
public class VerMacIngestProperties {
    private boolean enabled;
    private String url;
    private String apiKey;
    private Duration fetchInterval;
    private boolean updatesEnabled;
}
