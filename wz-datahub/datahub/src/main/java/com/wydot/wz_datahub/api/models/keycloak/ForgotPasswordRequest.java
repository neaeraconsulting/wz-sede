package com.wydot.wz_datahub.api.models.keycloak;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ForgotPasswordRequest {
    @JsonProperty("email")
    private String email;
}
