package com.wydot.wz_datahub.api.models.update_processing.values;

import java.util.List;

import com.wydot.wz_datahub.api.update_processors.UpdateProcessorUtils;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.Lane;
import wyo.dot.protobuf.VehicleImpact;

@Slf4j
@NoArgsConstructor
@AllArgsConstructor
@Data
public class LaneStatusValue {
    private VehicleImpact vehicleImpact;
    private List<Lane> lanes;

    public static LaneStatusValue fromLanes(List<Lane> lanes) {
        LaneStatusValue laneStatusValue = new LaneStatusValue();
        laneStatusValue.setLanes(lanes);
        laneStatusValue.setVehicleImpact(UpdateProcessorUtils.getVehicleImpactFromLanes(lanes));
        return laneStatusValue;
    }
}