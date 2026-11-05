package com.wydot.wz_datahub.api.models.gis_service;

import com.google.type.LatLng;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class LatLngAndMilepost {
    private LatLng latLng;
    private double measure;
}
