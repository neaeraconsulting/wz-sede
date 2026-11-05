package com.wydot.wz_datahub.api.retrievers.wzam_worker;

import java.time.Duration;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import lombok.Data;

@Component
@ConfigurationProperties(prefix = "ingest.wzam-worker")
@Data
public class WzamWorkerIngestProperties {
    private boolean enabled;
    private Duration evalInterval;
    private Duration maxAge;
}
