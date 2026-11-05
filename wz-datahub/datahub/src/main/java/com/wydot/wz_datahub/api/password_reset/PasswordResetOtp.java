package com.wydot.wz_datahub.api.password_reset;

import java.util.Date;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@Document(collection = "passwordResetOtp")
public class PasswordResetOtp {
    @Id
    private String id;

    @Indexed(unique = true)
    private String email;

    private String code;

    @Indexed(expireAfter = "15m")
    private Date createdAt;
}
