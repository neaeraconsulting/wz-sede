package com.wydot.message_generator.models.keycloak;

import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class KeycloakLogoutRequest {
    @JsonProperty("client_id")
    private String clientId;
    @JsonProperty("refresh_token")
    private String refreshToken;

    public MultiValueMap<String, String> getFormData() {
        MultiValueMap<String, String> formData = new LinkedMultiValueMap<>();
        formData.add("client_id", clientId);
        formData.add("refresh_token", refreshToken);
        return formData;
    }
}
