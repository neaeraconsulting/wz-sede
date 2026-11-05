package com.wydot.wz_datahub.api.models.keycloak;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class KeycloakLogoutRequest {
    @JsonProperty("refresh_token")
    private String refreshToken;
}
