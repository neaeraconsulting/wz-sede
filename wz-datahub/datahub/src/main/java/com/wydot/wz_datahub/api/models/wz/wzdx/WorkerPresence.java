package com.wydot.wz_datahub.api.models.wz.wzdx;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

/**
 * Class representing the presence of workers in the work zone.
 * 
 * @see <a href=
 *      "https://github.com/usdot-jpo-ode/wzdx/blob/main/spec-content/objects/WorkerPresence.md">WorkerPresence</a>
 */
@Data
public class WorkerPresence {
    @JsonProperty("are_workers_present")
    private boolean areWorkersPresent;
    @JsonProperty("definition")
    private List<WorkerPresenceDefinition> definition;
    @JsonProperty("method")
    private WorkerPresenceMethod method;
    @JsonProperty("worker_presence_last_confirmed_date")
    private String workerPresenceLastConfirmedDate;
    @JsonProperty("confidence")
    private WorkerPresenceConfidence confidence;
}