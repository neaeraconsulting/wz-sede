package com.wydot.message_generator.models.wz.cwz;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Builder;
import lombok.Data;

/**
 * Class representing the presence of workers in the work zone.
 * 
 * @see <a href=
 *      "https://github.com/usdot-jpo-ode/wzdx/blob/main/spec-content/objects/WorkerPresence.md">WorkerPresence</a>
 */
@Data
@Builder
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