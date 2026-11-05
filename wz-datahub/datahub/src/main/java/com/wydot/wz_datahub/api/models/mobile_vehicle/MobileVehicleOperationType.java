package com.wydot.wz_datahub.api.models.mobile_vehicle;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

import wyo.dot.protobuf.TypeOfWork;
import wyo.dot.protobuf.WorkTypeName;

public enum MobileVehicleOperationType {
    @JsonProperty("striping")
    STRIPING,
    @JsonProperty("plowing")
    PLOWING,
    @JsonProperty("mowing")
    MOWING,
    @JsonProperty("general-active")
    GENERAL_ACTIVE,
    @JsonProperty("general-inactive")
    GENERAL_INACTIVE;

    public List<TypeOfWork> getTypesOfWork() {
        TypeOfWork.Builder builder = TypeOfWork.newBuilder().setIsArchitecturalChange(false);
        return switch (this) {
            case STRIPING -> List.of(builder.setTypeName(WorkTypeName.WORK_TYPE_NAME_PAINTING).build());
            case PLOWING -> List.of();
            case MOWING -> List.of();
            case GENERAL_ACTIVE -> List.of();
            case GENERAL_INACTIVE -> List.of();
        };
    }
}