package com.wydot.wz_datahub.api.utilities.gis_service.colorado;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@ConfigurationProperties(prefix = "gis-service-colorado")
@Data
public class GisServicePropertiesColorado {
    private String endpoint;
}
