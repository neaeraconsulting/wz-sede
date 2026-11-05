package com.wydot.message_generator.models.pi_lit;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class PiLitTokenRequest {
    @JsonProperty("email")
    private String email;
    @JsonProperty("password")
    private String password;

    public MultiValueMap<String, String> getFormData() {
        MultiValueMap<String, String> formData = new LinkedMultiValueMap<>();
        formData.add("email", email);
        formData.add("password", password);
        return formData;
    }
}
