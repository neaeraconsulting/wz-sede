package com.wydot.wz_datahub.api.controllers;

import java.io.IOException;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.web.util.ContentCachingRequestWrapper;

import com.wydot.wz_datahub.api.accessors.raw.RawDataRepository;
import com.wydot.wz_datahub.api.models.raw_data.RawDataType;
import com.wydot.wz_datahub.api.models.raw_data.RawDataWrapper;


@Slf4j
@Component
@RequiredArgsConstructor
public class RequestBodyLoggingFilter extends OncePerRequestFilter {
    private final RawDataRepository rawDataRepository;

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain
    ) throws ServletException, IOException {

        ContentCachingRequestWrapper wrappedRequest =
                new ContentCachingRequestWrapper(request);

        filterChain.doFilter(wrappedRequest, response);

        byte[] body = wrappedRequest.getContentAsByteArray();
        if (body.length > 0) {
            String rawBody = new String(body, wrappedRequest.getCharacterEncoding());
            switch(request.getRequestURI()) {
                case "/datahub/wzam/reports":
                    if (request.getMethod().equalsIgnoreCase("POST") || request.getMethod().equalsIgnoreCase("PATCH")) {
                        rawDataRepository.insert(
                                new RawDataWrapper(System.currentTimeMillis(), RawDataType.WZAM_REPORT, rawBody));
                    }
                    break;
                case "/datahub/wzam/reports/live_position":
                    if (request.getMethod().equalsIgnoreCase("POST")) {
                        rawDataRepository.insert(
                                new RawDataWrapper(System.currentTimeMillis(), RawDataType.WZAM_WORKER, rawBody));
                    }
                    break;
                case "/datahub/wzam/reports/mobile-vehicle":
                    if (request.getMethod().equalsIgnoreCase("POST")) {
                        rawDataRepository.insert(
                                new RawDataWrapper(System.currentTimeMillis(), RawDataType.WZAM_VEHICLE, rawBody));
                    }
                    break;
                case "/datahub/wzam/recordings":
                    if (request.getMethod().equalsIgnoreCase("POST") || request.getMethod().equalsIgnoreCase("PUT")) {
                        rawDataRepository.insert(
                                new RawDataWrapper(System.currentTimeMillis(), RawDataType.WZAM_RECORDING, rawBody));
                    }
                    break;
                case "/datahub/wzam/worker-presence-report":
                    if (request.getMethod().equalsIgnoreCase("POST")) {
                        rawDataRepository.insert(
                                new RawDataWrapper(System.currentTimeMillis(), RawDataType.WZAM_MINI_REPORT, rawBody));
                    }
                    break;
                default:
                    // Do nothing
            }
        }
    }
}