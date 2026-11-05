package com.wydot.wz_datahub.api.models.recordings;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.wydot.wz_datahub.api.models.wz.wzdx.Lane;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class RecordingMarking {
    @JsonProperty("ref_pt")
    private Boolean refPt;
    @JsonProperty("lanes")
    private List<Lane> lanes;
    @JsonProperty("workers_present")
    private Boolean workersPresent;
    @JsonProperty("speed_limit_mph")
    private Integer speedLimitMph;

    public RecordingMarking clone() {
        List<Lane> clonedLanes = new ArrayList<>(lanes); // Deep copy points
        return new RecordingMarking(refPt, clonedLanes, workersPresent, speedLimitMph);
    }
}
