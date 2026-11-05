package com.wydot.wz_datahub.api.controllers;

import com.wydot.wz_datahub.api.models.keycloak.TokenPostRequest;
import com.wydot.wz_datahub.api.models.keycloak.TokenPostResponse;
import com.wydot.wz_datahub.api.models.keycloak.TokenRefreshRequest;
import com.wydot.wz_datahub.api.notifications.SlackNotificationApi;
import com.wydot.wz_datahub.api.password_reset.PasswordResetService;
import com.wydot.wz_datahub.api.keycloak.KeycloakApi;
import com.wydot.wz_datahub.api.keycloak.KeycloakProperties;
import com.wydot.wz_datahub.api.keycloak.PermissionService;
import com.wydot.wz_datahub.api.models.keycloak.KeycloakLogoutRequest;
import com.wydot.wz_datahub.api.models.keycloak.KeycloakUserRequest;
import com.wydot.wz_datahub.api.models.keycloak.KeycloakUserRequestDto;
import com.wydot.wz_datahub.api.models.keycloak.ForgotPasswordRequest;
import com.wydot.wz_datahub.api.models.keycloak.ResetPasswordWithCodeRequest;
import com.wydot.wz_datahub.api.models.keycloak.ChangePasswordRequest;
import com.wydot.wz_datahub.api.models.keycloak.UserPropertiesRequest;

import lombok.extern.slf4j.Slf4j;
import lombok.RequiredArgsConstructor;

import java.util.List;

import org.springframework.security.core.Authentication;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

@Slf4j
@RestController
@RequestMapping("auth")
@RequiredArgsConstructor
public class AuthController {
    final KeycloakApi keycloakApi;
    final PermissionService permissionService;
    final KeycloakProperties keycloakProps;
    final SlackNotificationApi slackNotificationApi;
    final PasswordResetService passwordResetService;

    @PostMapping(value = "/token", produces = "application/json")
    public Mono<TokenPostResponse> generateToken(@RequestBody TokenPostRequest request) {
        return keycloakApi.generateKeycloakToken(request);
    }

    @PostMapping(value = "/refresh", produces = "application/json")
    public Mono<TokenPostResponse> refreshToken(@RequestBody TokenRefreshRequest request) {
        return keycloakApi.refreshKeycloakToken(request);
    }

    @PostMapping("/registration")
    public Mono<Void> registerNewUser(@RequestBody KeycloakUserRequestDto request) {
        log.info("Registering new user: {}", request);
        return keycloakApi.createUser(new KeycloakUserRequest(request))
                .doOnSuccess((var) -> {
                    slackNotificationApi.sendUserRegistrationNotification(request);
                })
                .doOnError(throwable -> {
                    log.error("Failed to create user", throwable);
                    slackNotificationApi.sendUserRegistrationFailureNotification(request, throwable);
                })
                .then();
    }

    @GetMapping("/access-request-emails")
    public Mono<List<String>> getAccessRequestEmails() {
        return Mono.just(keycloakProps.getAdminRegistrationEmails());
    }

    @PostMapping("/logout")
    public Mono<Void> logoutUser(@RequestBody KeycloakLogoutRequest request) {
        log.info("Logging out user: {}", request);
        return keycloakApi.logoutUser(request);
    }

    @PostMapping("/change-password")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public Mono<Void> changePassword(@RequestBody ChangePasswordRequest request, Authentication authentication) {
        if (!permissionService.isAuthValid(authentication)) {
            return Mono.error(new SecurityException("User is not authenticated"));
        }

        if (request.getNewPassword() == null || request.getNewPassword().isBlank()) {
            return Mono.error(new IllegalArgumentException("New password is required"));
        }

        String userId = PermissionService.getUserId(authentication);

        return keycloakApi.changePassword(userId, request.getNewPassword());
    }

    @PatchMapping("/user-properties")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public Mono<Void> updateUserProperties(@RequestBody UserPropertiesRequest request, Authentication authentication) {
        if (!permissionService.isAuthValid(authentication)) {
            return Mono.error(new SecurityException("User is not authenticated"));
        }

        String userId = PermissionService.getUserId(authentication);
        String userEmail = PermissionService.getUserEmail(authentication);
        Mono<Void> result = keycloakApi.updateLocalPhoneNumber(userId, userEmail, request.getPhoneNumber());
        return result;
    }

    @DeleteMapping("/delete-account/{userId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public Mono<Void> deleteUser(@PathVariable String userId) {
        // Verify that supplied token matches the userId given
        if (userId == null || userId.isEmpty()) {
            log.warn("User ID is null or empty, cannot delete user.");
            return Mono.error(new IllegalArgumentException("User ID must not be null or empty"));
        }
        // Confirm that user token matches userId
        if (!permissionService.isSpecifiedUser(userId)) {
            log.warn("User ID does not match authenticated user, cannot delete user.");
            return Mono.error(new SecurityException("User is not authorized to delete this account"));
        }
        log.info("Deleting user with ID: {}", userId);
        return keycloakApi.deleteUser(userId);
    }

    @PostMapping("/forgot-password")
    @ResponseStatus(HttpStatus.OK)
    public Mono<Void> forgotPassword(@RequestBody ForgotPasswordRequest request) {
        return passwordResetService.sendForgotPasswordCode(request.getEmail());
    }

    @PostMapping("/reset-password")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public Mono<Void> resetPassword(@RequestBody ResetPasswordWithCodeRequest request) {
        return passwordResetService.resetPassword(request.getEmail(), request.getCode(), request.getNewPassword());
    }
}
