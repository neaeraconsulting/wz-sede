package com.wydot.message_generator.models.pi_lit;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data

public class PiLitTokenAccount {
    private long id;
    private String namespace;
    private List<String> image_urls;
    private List<String> account_types;
    private String timezone;
}
