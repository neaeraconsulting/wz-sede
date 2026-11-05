package com.wydot.wz_datahub.api.models.keycloak;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class ChangePasswordRequest {
    @JsonProperty("new_password")
    private String newPassword;
}
