package com.wydot.wz_datahub.api.models.keycloak;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class KeycloakUserRequest {
    @JsonProperty("email")
    private String email;
    @JsonProperty("username")
    private String username;
    @JsonProperty("firstName")
    private String firstName;
    @JsonProperty("lastName")
    private String lastName;
    @JsonProperty("enabled")
    private boolean enabled;
    @JsonProperty("attributes")
    private Map<String, String> attributes;
    @JsonProperty("credentials")
    private List<Map<String, Object>> credentials;

    public KeycloakUserRequest(KeycloakUserRequestDto userRequest) {
        this.email = userRequest.getEmail();
        this.username = userRequest.getUsername();
        this.firstName = userRequest.getFirstName();
        this.lastName = userRequest.getLastName();
        this.enabled = true;

        attributes = new HashMap<>();
        attributes.put("phoneNumber", userRequest.getPhoneNumber());
        attributes.put("platform", userRequest.getPlatform());

        Map<String, Object> credential = new HashMap<>();
        credential.put("type", "password");
        credential.put("value", userRequest.getPassword());
        credential.put("temporary", false);
        credentials = List.of(credential);

    }
}
