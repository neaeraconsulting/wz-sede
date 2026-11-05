package com.wydot.message_generator.models.sdx;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class SdxTokenResponse {
    private String status;
    private String first_name;
    private String last_name;
    private String email;
    private String token;
}