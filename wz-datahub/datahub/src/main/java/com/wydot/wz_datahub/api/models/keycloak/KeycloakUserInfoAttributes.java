package com.wydot.wz_datahub.api.models.keycloak;

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

    @JsonProperty("localPhoneNumber")
    private List<String> localPhoneNumber;

    @JsonProperty("platform")
    private List<String> platform;

    @JsonProperty("authSource")
    private List<String> authSource;

    public PhoneNumber toProto() {
        // Return first non-null phone number, starting with phoneNumber then
        // localPhoneNumber
        if (phoneNumber == null || phoneNumber.isEmpty()) {
            if (localPhoneNumber == null || localPhoneNumber.isEmpty()) {
                return null;
            }
            return phoneNumberToProto(localPhoneNumber.get(0));
        }
        return phoneNumberToProto(phoneNumber.get(0));
    }

    private PhoneNumber phoneNumberToProto(String phoneNumber) {
        if (phoneNumber == null || phoneNumber.isEmpty()) {
            return null;
        }
        String phone = phoneNumber;
        Integer countryCode = 1; // Assuming US country code
        Integer areaCode = Integer.parseInt(phone.substring(0, 3));
        String number = phone.substring(3, 6) + "-" + phone.substring(6);
        return PhoneNumber.newBuilder().setCountryCode(countryCode).setAreaCode(areaCode).setNumber(number).build();
    }
}