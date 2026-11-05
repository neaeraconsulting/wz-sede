package com.wydot.wz_datahub.api.models.keycloak;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ResetPasswordWithCodeRequest {
    @JsonProperty("email")
    private String email;

    @JsonProperty("code")
    private String code;

    @JsonProperty("new_password")
    private String newPassword;
}
