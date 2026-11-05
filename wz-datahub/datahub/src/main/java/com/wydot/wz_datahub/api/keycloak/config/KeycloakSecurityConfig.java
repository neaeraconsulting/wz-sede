package com.wydot.wz_datahub.api.keycloak.config;

import com.wydot.wz_datahub.api.keycloak.support.CorsUtil;
import com.wydot.wz_datahub.api.keycloak.support.KeycloakJwtAuthenticationConverter;
import lombok.RequiredArgsConstructor;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.stereotype.Component;

/**
 * Provides keycloak based spring security configuration.
 */
@Component
@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class KeycloakSecurityConfig {

    @Value("${keycloak.client-id}")
    private String clientId;

    @Autowired
    final KeycloakJwtAuthenticationConverter keycloakJwtAuthenticationConverter;

    @Bean
    SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity) throws Exception {

        return httpSecurity
                .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .cors(corsConfigurer -> CorsUtil.configureCors(corsConfigurer, "*"))
                .csrf(AbstractHttpConfigurer::disable)
                .authorizeHttpRequests(request -> request
                        .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll() // Allow CORS preflight
                        .requestMatchers(HttpMethod.GET, "/auth/token").permitAll() // permit token generation
                        .requestMatchers(HttpMethod.GET, "/app/version").permitAll() // permit app version check
                        .requestMatchers(HttpMethod.POST, "/auth/registration").permitAll() // permit user registration
                        .requestMatchers(HttpMethod.POST, "/wzam/support-request").permitAll() // permit support request
                        .requestMatchers(HttpMethod.POST, "/auth/forgot-password").permitAll() // permit password reset request
                        .requestMatchers(HttpMethod.POST, "/auth/reset-password").permitAll() // permit password reset with code
                        .requestMatchers("/**").access(AccessController::checkAccess)
                        .anyRequest().authenticated())
                .oauth2ResourceServer(resourceServerConfigurer -> resourceServerConfigurer.jwt(
                        jwtConfigurer -> jwtConfigurer.jwtAuthenticationConverter(keycloakJwtAuthenticationConverter)

                ))
                .build();
    }

    @Bean
    AccessController accessController() {
        return new AccessController();
    }
}