package com.wydot.message_generator.models.keycloak;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class TokenPostRequestKeycloak {
    @JsonProperty("client_id")
    private String clientId;
    @JsonProperty("client_secret")
    private String clientSecret;
    @JsonProperty("grant_type")
    private String grantType;

    public TokenPostRequestKeycloak(String clientId, String clientSecret) {
        this.clientId = clientId;
        this.clientSecret = clientSecret;
        this.grantType = "client_credentials";
    }

    public MultiValueMap<String, String> getFormData() {
        MultiValueMap<String, String> formData = new LinkedMultiValueMap<>();
        formData.add("client_id", clientId);
        formData.add("client_secret", clientSecret);
        formData.add("grant_type", grantType);
        return formData;
    }
}
