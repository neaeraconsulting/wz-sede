package com.wydot.message_generator.sdx;

import org.springframework.context.annotation.Configuration;

/**
 * Configuration class for SDX API services.
 * 
 * This configuration uses Spring's @ConditionalOnProperty to automatically
 * create either the active SdxApi implementation (when sdx.enabled=true)
 * or the no-op SdxApiNoOpImpl implementation (when sdx.enabled=false or
 * missing).
 * 
 * Usage in application.yaml:
 * 
 * # To enable SDX API
 * sdx:
 * enabled: true
 * endpoint: "https://your-sdx-endpoint.com"
 * access-token: "your-access-token"
 * 
 * # To disable SDX API (uses no-op implementation)
 * sdx:
 * enabled: false
 */
@Configuration
public class SdxApiConfiguration {
    // Bean creation is handled automatically by @ConditionalOnProperty annotations
    // in SdxApi and SdxApiNoOpImpl classes
}