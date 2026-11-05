package com.wydot.wz_datahub.api.models;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class SupportRequestBody {
    private String username;
    private String subject;
    private String message;
}
