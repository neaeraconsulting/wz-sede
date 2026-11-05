package com.wydot.wz_datahub.api.models.field_devices;

public enum FieldDeviceUpdateCategory {
    NEW_DEVICE,
    PROPERTY_CHANGE,
    LOCATION_CHANGE,
    PROPERTY_AND_LOCATION_CHANGE;

    public FieldDeviceUpdateCategory addTo(FieldDeviceUpdateCategory category) {
        if (category == null)
            return this;
        if (this == PROPERTY_CHANGE && category == LOCATION_CHANGE)
            return PROPERTY_AND_LOCATION_CHANGE;
        if (this == LOCATION_CHANGE && category == PROPERTY_CHANGE)
            return PROPERTY_AND_LOCATION_CHANGE;
        return this;
    }

    public Boolean hasPropertyChanged() {
        return this == PROPERTY_CHANGE || this == PROPERTY_AND_LOCATION_CHANGE;
    }

    public Boolean hasLocationChanged() {
        return this == LOCATION_CHANGE || this == PROPERTY_AND_LOCATION_CHANGE;
    }
}