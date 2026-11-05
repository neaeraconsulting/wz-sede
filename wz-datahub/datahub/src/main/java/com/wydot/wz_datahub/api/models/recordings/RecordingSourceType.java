package com.wydot.wz_datahub.api.models.recordings;

import com.fasterxml.jackson.annotation.JsonProperty;

public enum RecordingSourceType {
    @JsonProperty("drive")
    DRIVE,
    @JsonProperty("kml-upload")
    KML_UPLOAD,
}