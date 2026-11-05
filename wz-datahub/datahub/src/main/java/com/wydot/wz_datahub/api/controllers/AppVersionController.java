package com.wydot.wz_datahub.api.controllers;

import com.wydot.wz_datahub.api.appversion.AppVersionProperties;
import com.wydot.wz_datahub.api.models.appversion.AppVersionResponse;

import lombok.RequiredArgsConstructor;

import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("app")
@RequiredArgsConstructor
public class AppVersionController {
    private final AppVersionProperties appVersionProperties;

    @GetMapping("/version")
    public Mono<AppVersionResponse> getVersion() {
        return Mono.just(new AppVersionResponse(
                appVersionProperties.getMinimumVersion(),
                appVersionProperties.getLatestVersion()));
    }
}
