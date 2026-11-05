package com.wydot.wz_datahub.api.models.pi_lit;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class PiLitTokenResponse {
    private String status;
    private String first_name;
    private String last_name;
    private String email;
    private String token;
    private List<PiLitTokenAccount> accounts;
    private String default_account_type;
    private List<String> account_types;
    private boolean is_pivar_admin;
    private boolean is_account_admin;
    private String namespace;
    private String account_timezone;
    private boolean has_api_doc_access;
}