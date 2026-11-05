package com.wydot.message_generator.models.keycloak;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import wyo.dot.protobuf.PhoneNumber;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class KeycloakUserInfoAttributes {
    @JsonProperty("phoneNumber")
    private List<String> phoneNumber;

    public PhoneNumber toProto() {
        if (phoneNumber == null || phoneNumber.isEmpty()) {
            return null;
        }
        String phone = phoneNumber.getFirst();
        Integer countryCode = 1; // Assuming US country code
        Integer areaCode = Integer.parseInt(phone.substring(0, 3));
        String number = phone.substring(3, 6) + "-" + phone.substring(6);
        return PhoneNumber.newBuilder().setCountryCode(countryCode).setAreaCode(areaCode).setNumber(number).build();
    }
}