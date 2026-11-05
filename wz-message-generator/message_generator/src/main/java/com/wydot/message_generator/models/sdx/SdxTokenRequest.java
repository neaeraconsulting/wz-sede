package com.wydot.message_generator.models.sdx;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class SdxTokenRequest {
    @JsonProperty("username")
    private String username;
    @JsonProperty("password")
    private String password;

    public MultiValueMap<String, String> getFormData() {
        MultiValueMap<String, String> formData = new LinkedMultiValueMap<>();
        formData.add("username", username);
        formData.add("password", password);
        return formData;
    }
}
