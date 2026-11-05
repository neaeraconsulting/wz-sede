package com.wydot.message_generator.models.keycloak;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Data;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class TokenPostRequest {
    @JsonProperty("username")
    private String username;
    @JsonProperty("password")
    private String password;
}
