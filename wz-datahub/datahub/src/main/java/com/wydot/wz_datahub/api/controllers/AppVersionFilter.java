package com.wydot.wz_datahub.api.controllers;

import java.io.IOException;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import com.wydot.wz_datahub.api.appversion.AppVersionProperties;

@Slf4j
@Component
@RequiredArgsConstructor
public class AppVersionFilter extends OncePerRequestFilter {
    static final String VERSION_HEADER = "X-App-Version";

    private final AppVersionProperties appVersionProperties;

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain) throws ServletException, IOException {

        // Always pass OPTIONS (CORS preflight) and the version endpoint itself
        if (HttpMethod.OPTIONS.name().equalsIgnoreCase(request.getMethod())
                || request.getRequestURI().endsWith("/app/version")) {
            filterChain.doFilter(request, response);
            return;
        }

        String clientVersion = request.getHeader(VERSION_HEADER);

        // No header — allow through for backwards compatibility
        if (clientVersion == null || clientVersion.isBlank()) {
            filterChain.doFilter(request, response);
            return;
        }

        if (compareSemver(clientVersion, appVersionProperties.getMinimumVersion()) < 0) {
            log.info("Blocking outdated client version {} (minimum: {})", clientVersion,
                    appVersionProperties.getMinimumVersion());
            writeUpgradeRequiredResponse(response);
            return;
        }

        filterChain.doFilter(request, response);
    }

    /**
     * Compares two semver strings (major.minor.patch).
     * Returns -1 if left < right, 0 if equal, 1 if left > right.
     */
    private int compareSemver(String left, String right) {
        int[] leftParts = parseParts(left);
        int[] rightParts = parseParts(right);

        for (int i = 0; i < 3; i++) {
            if (leftParts[i] < rightParts[i]) return -1;
            if (leftParts[i] > rightParts[i]) return 1;
        }

        return 0;
    }

    private int[] parseParts(String version) {
        int[] parts = new int[3];
        String[] segments = version.split("\\.");
        for (int i = 0; i < 3; i++) {
            try {
                parts[i] = i < segments.length ? Integer.parseInt(segments[i]) : 0;
            } catch (NumberFormatException e) {
                log.warn("Could not parse version segment {} from '{}', treating as 0", i, version);
                parts[i] = 0;
            }
        }
        return parts;
    }

    private void writeUpgradeRequiredResponse(HttpServletResponse response) throws IOException {
        String body = String.format(
                "{\"force_update\":true,\"minimum_version\":\"%s\",\"latest_version\":\"%s\",\"message\":\"Please update your app to continue\"}",
                appVersionProperties.getMinimumVersion(),
                appVersionProperties.getLatestVersion());

        response.setStatus(HttpStatus.UPGRADE_REQUIRED.value());
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.getWriter().write(body);
    }
}
