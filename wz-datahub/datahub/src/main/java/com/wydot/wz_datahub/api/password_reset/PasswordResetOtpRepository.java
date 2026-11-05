package com.wydot.wz_datahub.api.password_reset;

import java.util.Optional;

import org.springframework.data.mongodb.repository.MongoRepository;

public interface PasswordResetOtpRepository extends MongoRepository<PasswordResetOtp, String> {
    Optional<PasswordResetOtp> findByEmail(String email);

    void deleteByEmail(String email);
}
