package com.wydot.wz_datahub.api.keycloak;

import com.wydot.wz_datahub.api.models.keycloak.KeycloakLogoutRequest;
import com.wydot.wz_datahub.api.models.keycloak.KeycloakLogoutRequestKeycloak;
import com.wydot.wz_datahub.api.models.keycloak.KeycloakUserInfo;
import com.wydot.wz_datahub.api.models.keycloak.KeycloakUserInfoAttributes;
import com.wydot.wz_datahub.api.models.keycloak.KeycloakUserRequest;
import com.wydot.wz_datahub.api.models.keycloak.TokenPostRequest;
import com.wydot.wz_datahub.api.models.keycloak.TokenPostRequestKeycloak;
import com.wydot.wz_datahub.api.models.keycloak.TokenPostResponse;
import com.wydot.wz_datahub.api.models.keycloak.TokenRefreshRequest;
import com.wydot.wz_datahub.api.models.keycloak.TokenRefreshRequestKeycloak;

import lombok.extern.slf4j.Slf4j;

import java.util.Map;
import java.util.List;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.server.ResponseStatusException;
import reactor.core.publisher.Mono;

@Slf4j
@Component
public class KeycloakApi {
    private final String keycloakRealm;
    private final String keycloakClientId;
    private final String keycloakClientSecret;

    private final WebClient webClient;

    public KeycloakApi(KeycloakProperties keycloakProperties, WebClient.Builder webClientBuilder) {
        this.keycloakRealm = keycloakProperties.getRealm();
        this.keycloakClientId = keycloakProperties.getClientId();
        this.keycloakClientSecret = keycloakProperties.getClientSecret();
        this.webClient = webClientBuilder.baseUrl(keycloakProperties.getEndpoint()).build();
    }

    public Mono<TokenPostResponse> generateKeycloakToken(TokenPostRequest request) {
        TokenPostRequestKeycloak requestBody = new TokenPostRequestKeycloak(request, keycloakClientId,
                keycloakClientSecret);

        return webClient.post()
                .uri(String.format("/realms/%s/protocol/openid-connect/token", keycloakRealm))
                .headers(headers -> {
                    headers.set(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_FORM_URLENCODED_VALUE);
                })
                .body(BodyInserters.fromFormData(requestBody.getFormData()))
                .exchangeToMono(response -> switch (response.statusCode()) {
                    case HttpStatus.OK -> response.bodyToMono(TokenPostResponse.class);
                    default -> {
                        log.warn("Received non-success error code: {}", response.statusCode());
                        yield response.bodyToMono(String.class)
                                .flatMap(body -> Mono.error(new ResponseStatusException(response.statusCode(),
                                        String.format("Keycloak returned error: %s", body))));
                    }
                });
    }

    public Mono<TokenPostResponse> refreshKeycloakToken(TokenRefreshRequest request) {
        TokenRefreshRequestKeycloak requestBody = new TokenRefreshRequestKeycloak(request, keycloakClientId,
                keycloakClientSecret);

        return webClient.post()
                .uri(String.format("/realms/%s/protocol/openid-connect/token", keycloakRealm))
                .headers(headers -> {
                    headers.set(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_FORM_URLENCODED_VALUE);
                })
                .body(BodyInserters.fromFormData(requestBody.getFormData()))
                .exchangeToMono(response -> switch (response.statusCode()) {
                    case HttpStatus.OK -> response.bodyToMono(TokenPostResponse.class);
                    default -> {
                        log.warn("Received non-success error code: {}", response.statusCode());
                        yield response.bodyToMono(String.class)
                                .flatMap(body -> Mono.error(new ResponseStatusException(response.statusCode(),
                                        String.format("Keycloak returned error: %s", body))));
                    }
                });
    }

    public Mono<String> generateAccessToken() {
        MultiValueMap<String, String> formData = new LinkedMultiValueMap<>();
        formData.add("grant_type", "client_credentials");
        formData.add("client_id", keycloakClientId);
        formData.add("client_secret", keycloakClientSecret);
        return webClient.post()
                .uri(String.format("/realms/%s/protocol/openid-connect/token", keycloakRealm))
                .headers(headers -> {
                    headers.set(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_FORM_URLENCODED_VALUE);
                })
                .body(BodyInserters.fromFormData(formData))
                .exchangeToMono(response -> {
                    if (response.statusCode().is2xxSuccessful()) {
                        return response.bodyToMono(TokenPostResponse.class)
                                .map(TokenPostResponse::getAccessToken);
                    } else {
                        return response.bodyToMono(String.class)
                                .flatMap(body -> Mono.error(new ResponseStatusException(response.statusCode(),
                                        String.format("Failed to get admin access token: %s", body))));
                    }
                });
    }

    public Mono<Void> createUser(KeycloakUserRequest userRequest) {
        return generateAccessToken()
                .flatMap(accessToken -> webClient.post()
                        .uri(String.format("/admin/realms/%s/users", keycloakRealm))
                        .headers(headers -> {
                            headers.setBearerAuth(accessToken);
                            headers.set(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE);
                        })
                        .bodyValue(userRequest)
                        .exchangeToMono(response -> {
                            if (response.statusCode().is2xxSuccessful()) {
                                return Mono.empty();
                            } else {
                                return response.bodyToMono(String.class)
                                        .flatMap(body -> Mono.error(new ResponseStatusException(response.statusCode(),
                                                String.format("Failed to create user: %s", body))));
                            }
                        }));
    }

    public Mono<Void> logoutUser(KeycloakLogoutRequest request) {
        KeycloakLogoutRequestKeycloak requestBody = new KeycloakLogoutRequestKeycloak(request.getRefreshToken(),
                keycloakClientId);
        return webClient.post()
                .uri(String.format("/realms/%s/protocol/openid-connect/logout", keycloakRealm))
                .headers(headers -> {
                    headers.set(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE);
                })
                .bodyValue(requestBody)
                .exchangeToMono(response -> {
                    if (response.statusCode().is2xxSuccessful()) {
                        return Mono.empty();
                    } else {
                        return response.bodyToMono(String.class)
                                .flatMap(body -> Mono.error(new ResponseStatusException(response.statusCode(),
                                        String.format("Failed to logout user: %s", body))));
                    }
                });
    }

    public Mono<Void> deleteUser(String userId) {
        return generateAccessToken()
                .flatMap(accessToken -> webClient.delete()
                        .uri(String.format("/admin/realms/%s/users/%s", keycloakRealm, userId))
                        .headers(headers -> {
                            headers.setBearerAuth(accessToken);
                            headers.set(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE);
                        })
                        .exchangeToMono(response -> {
                            if (response.statusCode().is2xxSuccessful()) {
                                return Mono.empty();
                            } else {
                                return response.bodyToMono(String.class)
                                        .flatMap(body -> Mono.error(new ResponseStatusException(response.statusCode(),
                                                String.format("Failed to create user: %s", body))));
                            }
                        }));
    }

    public Mono<Void> changePassword(String userId, String newPassword) {
        Map<String, Object> resetBody = Map.of(
                "type", "password",
                "value", newPassword,
                "temporary", false);

        return generateAccessToken()
                .flatMap(accessToken -> webClient.put()
                .uri(String.format("/admin/realms/%s/users/%s/reset-password", keycloakRealm, userId))
                .headers(headers -> {
                    headers.setBearerAuth(accessToken);
                    headers.set(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE);
                })
                .bodyValue(resetBody)
                .exchangeToMono(response -> {
                    if (response.statusCode().is2xxSuccessful()) {
                        return Mono.empty();
                    }
                    return response.bodyToMono(String.class)
                            .flatMap(body -> Mono.error(new ResponseStatusException(response.statusCode(),
                                    String.format("Failed to change user password: %s", body))));
                }));
    }

    public Mono<Void> updateLocalPhoneNumber(String userId, String userEmail, String phoneNumber) {
        Map<String, Object> phoneNumberBody = Map.of(
                "email", userEmail,
                "attributes", Map.of("localPhoneNumber", phoneNumber));
        return generateAccessToken()
                .flatMap(accessToken -> webClient.put()
                        .uri(String.format("/admin/realms/%s/users/%s", keycloakRealm, userId))
                        .headers(headers -> {
                            headers.setBearerAuth(accessToken);
                            headers.set(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE);
                        })
                        .bodyValue(phoneNumberBody)
                        .exchangeToMono(response -> {
                            if (response.statusCode().is2xxSuccessful()) {
                                return Mono.<Void>empty();
                            }
                            return response.bodyToMono(String.class)
                                    .defaultIfEmpty("")
                                    .flatMap(body -> Mono.<Void>error(new ResponseStatusException(
                                            response.statusCode(),
                                            String.format("Failed to update phone number for user: %s", body))));
                        }));
    }

    public Mono<KeycloakUserInfo> getUserInfo(String userId) {
        return generateAccessToken()
                .flatMap(accessToken -> webClient.get()
                        .uri(String.format("/admin/realms/%s/users/%s", keycloakRealm, userId))
                        .headers(headers -> {
                            headers.setBearerAuth(accessToken);
                        })
                        .exchangeToMono(response -> {
                            if (response.statusCode().is2xxSuccessful()) {
                                return response.bodyToMono(KeycloakUserInfo.class);
                            } else {
                                return response.bodyToMono(String.class)
                                        .doOnNext((body) -> log.error("Failed to get user info: {}", body))
                                        .flatMap(body -> Mono.just(new KeycloakUserInfo("unknown", "unknown", "unknown",
                                                "unknown",
                                                "unknown",
                                                new KeycloakUserInfoAttributes(List.of("000-000-0000"),
                                                        List.of("000-000-0000"), List.of("unknown"),
                                                        List.of("unknown")))));
                            }
                        }));
    }

    public Mono<List<KeycloakUserInfo>> getUserByEmail(String email) {
        return generateAccessToken()
                .flatMap(accessToken -> webClient.get()
                        .uri(uriBuilder -> uriBuilder
                                .path(String.format("/admin/realms/%s/users", keycloakRealm))
                                .queryParam("email", email)
                                .queryParam("exact", "true")
                                .build())
                        .headers(headers -> headers.setBearerAuth(accessToken))
                        .exchangeToMono(response -> {
                            if (response.statusCode().is2xxSuccessful()) {
                                return response.bodyToFlux(KeycloakUserInfo.class).collectList();
                            } else {
                                return response.bodyToMono(String.class)
                                        .flatMap(body -> Mono.error(new ResponseStatusException(
                                                response.statusCode(),
                                                String.format("Failed to get user by email: %s", body))));
                            }
                        }));
    }

    public Mono<Void> resetPasswordAsAdmin(String userId, String newPassword) {
        Map<String, Object> resetBody = Map.of(
                "type", "password",
                "value", newPassword,
                "temporary", false);

        return generateAccessToken()
                .flatMap(accessToken -> webClient.put()
                        .uri(String.format("/admin/realms/%s/users/%s/reset-password", keycloakRealm, userId))
                        .headers(headers -> {
                            headers.setBearerAuth(accessToken);
                            headers.set(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE);
                        })
                        .bodyValue(resetBody)
                        .exchangeToMono(response -> {
                            if (response.statusCode().is2xxSuccessful()) {
                                return Mono.empty();
                            }
                            return response.bodyToMono(String.class)
                                    .flatMap(body -> Mono.error(new ResponseStatusException(
                                            response.statusCode(),
                                            String.format("Failed to reset user password: %s", body))));
                        }));
    }

}
