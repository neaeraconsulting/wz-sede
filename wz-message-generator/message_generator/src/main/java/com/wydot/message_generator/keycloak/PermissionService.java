package com.wydot.message_generator.keycloak;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service("PermissionService")
public class PermissionService {
    public boolean isSpecifiedUser(String specifiedUserId) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (!isAuthValid(auth)) {
            return false;
        }

        String tokenUserId = getUserId(auth);
        return tokenUserId.equals(specifiedUserId);
    }

    // helper method to make sure authentication is valid
    public boolean isAuthValid(Authentication auth) {
        if (!auth.isAuthenticated()) {
            return false;
        }

        return auth instanceof JwtAuthenticationToken;
    }

    public static String getUserId(Authentication auth) {
        JwtAuthenticationToken jwtAuth = (JwtAuthenticationToken) auth;
        return jwtAuth.getToken().getClaimAsString("sub");
    }
}