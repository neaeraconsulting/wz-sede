package com.wydot.wz_datahub.api.models.keycloak;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Data;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class TokenRefreshRequest {
    @JsonProperty("refresh_token")
    private String refreshToken;
}
