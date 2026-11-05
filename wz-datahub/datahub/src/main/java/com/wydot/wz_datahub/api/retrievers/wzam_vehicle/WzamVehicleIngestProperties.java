package com.wydot.wz_datahub.api.retrievers.wzam_vehicle;

import java.time.Duration;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import lombok.Data;

@Component
@ConfigurationProperties(prefix = "ingest.wzam-vehicle")
@Data
public class WzamVehicleIngestProperties {
    private boolean enabled;
    private Duration evalInterval;
    private Duration maxAge;
}
