package com.wydot.wz_datahub.api.models.wz.wzam;

import com.wydot.wz_datahub.api.models.wz.wzdx.RoadEventFeature;
import com.wydot.wz_datahub.api.models.wz.wzdx.TypeOfWork;
import com.wydot.wz_datahub.api.models.wz.wzdx.WorkZoneType;
import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
public class WzdxRecording {
    private Integer id;
    private Integer projectId;
    private Integer segmentId;
    private Integer areaId;
    private List<Map<String, RoadEventFeature>> features;
    private List<TypeOfWork> typesOfWork;
    private Long startDate;
    private Long endDate;
    private long creationDate;
    private WorkZoneType areaType;
}
