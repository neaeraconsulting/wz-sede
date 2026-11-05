package com.wydot.wz_datahub.api.models.wz.con_admin;

import lombok.Data;

import java.util.List;

@Data
public class Project {
    private Integer id;
    private String name;
    private String description;
    private String tmcNotes;
    private ProjectStatus activeStatus;
    private String hyperlink;
    private long startDate;
    private long endDate;
    private List<String> districts;
    private String wydotContact;
    private String projectUpdateContact;
    private String trafficControlContact;
    private String emergencyContact;
    private String contractor;
    private List<String> selectedTowns;
}