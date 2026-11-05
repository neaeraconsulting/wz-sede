package com.wydot.wz_datahub.api.password_reset;

import com.wydot.wz_datahub.api.keycloak.KeycloakApi;

import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.HttpStatus;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import reactor.core.publisher.Mono;
import reactor.core.scheduler.Schedulers;

import java.security.SecureRandom;
import java.util.Date;

@Slf4j
@Service
@RequiredArgsConstructor
public class PasswordResetService {

    private static final int OTP_EXPIRY_MINUTES = 15;
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    private final KeycloakApi keycloakApi;
    private final PasswordResetOtpRepository otpRepository;
    private final JavaMailSender mailSender;
    private final TemplateEngine templateEngine;

    @Value("${mail.from-address}")
    private String mailFromAddress;

    public Mono<Void> sendForgotPasswordCode(String email) {
        String normalizedEmail = email.toLowerCase();
        return keycloakApi.getUserByEmail(normalizedEmail)
                .flatMap(users -> {
                    if (users.isEmpty()) {
                        // Always return success — do not reveal whether the email exists
                        return Mono.empty();
                    }
                    String code = generateCode();
                    return Mono.fromCallable(() -> {
                        otpRepository.deleteByEmail(normalizedEmail);
                        PasswordResetOtp otp = new PasswordResetOtp();
                        otp.setEmail(normalizedEmail);
                        otp.setCode(code);
                        otp.setCreatedAt(new Date());
                        otpRepository.save(otp);
                        return otp;
                    })
                            .subscribeOn(Schedulers.boundedElastic())
                            .flatMap(otp -> sendEmail(normalizedEmail, code));
                })
                .doOnError(e -> log.error("Error in forgot-password flow for {}: {}", normalizedEmail, e.getMessage()))
                .then();
    }

    public Mono<Void> resetPassword(String email, String code, String newPassword) {
        String normalizedEmail = email.toLowerCase();
        return Mono.fromCallable(() -> otpRepository.findByEmail(normalizedEmail))
                .subscribeOn(Schedulers.boundedElastic())
                .flatMap(optOtp -> {
                    if (optOtp.isEmpty() || !optOtp.get().getCode().equals(code)) {
                        return Mono.error(new ResponseStatusException(HttpStatus.BAD_REQUEST,
                                "Invalid or expired reset code"));
                    }
                    PasswordResetOtp otp = optOtp.get();
                    return Mono.fromCallable(() -> {
                        otpRepository.delete(otp);
                        return true;
                    }).subscribeOn(Schedulers.boundedElastic());
                })
                .flatMap(ignored -> keycloakApi.getUserByEmail(normalizedEmail))
                .flatMap(users -> {
                    if (users.isEmpty()) {
                        return Mono.error(new ResponseStatusException(HttpStatus.BAD_REQUEST,
                                "Invalid or expired reset code"));
                    }
                    return keycloakApi.resetPasswordAsAdmin(users.get(0).getId(), newPassword);
                });
    }

    private String generateCode() {
        return String.format("%06d", SECURE_RANDOM.nextInt(1_000_000));
    }

    private Mono<Void> sendEmail(String to, String code) {
        return Mono.fromCallable(() -> {
            Context context = new Context();
            context.setVariable("code", code);
            context.setVariable("expiryMinutes", OTP_EXPIRY_MINUTES);
            String htmlBody = templateEngine.process("email/password-reset", context);

            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            helper.setTo(to);
            helper.setFrom(mailFromAddress);
            helper.setSubject("Your WZAM password reset code");
            helper.setText(htmlBody, true);
            helper.addInline("wzam-logo", new ClassPathResource("templates/WZAM_Logo.png"));
            mailSender.send(message);
            return null;
        })
                .subscribeOn(Schedulers.boundedElastic())
                .then();
    }
}
