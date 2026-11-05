package com.wydot.wz_datahub.api.models.wz.con_admin;

import lombok.Data;

import java.util.List;

@Data
public class RoadSection {
    private Integer id;
    private int projectId;
    private String segmentName;
    private RoadSectionType referenceType;
    private String startMm;
    private String endMm;
    private RoadSegmentDirection direction;
    private RoadSurfaceType surfaceType;
    private Long startDate;
    private Long endDate;
    private RoadSegmentArmedStatus armedStatus;
    private List<List<Float>> geometry;
    private List<List<Float>> bbox;
}