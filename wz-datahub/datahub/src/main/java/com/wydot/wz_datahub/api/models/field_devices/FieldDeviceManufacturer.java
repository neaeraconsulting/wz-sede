package com.wydot.wz_datahub.api.models.field_devices;

public enum FieldDeviceManufacturer {
    ICONE(0),
    PI_LIT(1),
    VRMAC(2),
    WYDOT_AVL(3),
    WZAM(4);

    private final Integer uniqueId;

    FieldDeviceManufacturer(Integer uniqueId) {
        this.uniqueId = uniqueId;
    }

    public Integer getUniqueId() {
        return uniqueId;
    }
}