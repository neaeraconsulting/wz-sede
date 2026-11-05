package com.wydot.wz_datahub.api.models.wanco.sabp;

import com.fasterxml.jackson.annotation.JsonProperty;

public enum ErrorCode {
    @JsonProperty("CriticalVoltageLow")
    CRITICAL_VOLTAGE_LOW,

    @JsonProperty("CriticalVoltageLampsDisabled")
    CRITICAL_VOLTAGE_LAMPS_DISABLED,

    @JsonProperty("CriticalVoltageDisconnect")
    CRITICAL_VOLTAGE_DISCONNECT,

    @JsonProperty("CriticalBoardTipped")
    CRITICAL_BOARD_TIPPED,

    @JsonProperty("CriticalMagnetometerError")
    CRITICAL_MAGNETOMETER_ERROR,

    @JsonProperty("CriticalRateLimited")
    CRITICAL_RATE_LIMITED,

    @JsonProperty("WarningVoltageLow")
    WARNING_VOLTAGE_LOW,

    @JsonProperty("WarningRemoteFourCorners")
    WARNING_REMOTE_FOUR_CORNERS,

    @JsonProperty("WarningSoftwareChecksumError")
    WARNING_SOFTWARE_CHECKSUM_ERROR,

    @JsonProperty("StatusStowedPosition")
    STATUS_STOWED_POSITION;
}