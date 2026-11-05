package com.wydot.wz_datahub.api.models.workers;

import com.fasterxml.jackson.annotation.JsonProperty;

public enum WorkerLocationType {
    @JsonProperty("worker")
    WORKER,
    @JsonProperty("flagger")
    FLAGGER,
    @JsonProperty("mobile-operator")
    MOBILE_OPERATOR,
}