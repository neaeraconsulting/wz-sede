package com.wydot.message_generator.models.project;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ProjectWithId {
    @JsonProperty("id")
    private Long id;
    @JsonProperty("name")
    private String name;
    @JsonProperty("description")
    private String description;
    @JsonProperty("active_status")
    private String active_status;
    @JsonProperty("creation_date")
    private Date creation_date;
    @JsonProperty("start_date")
    private Date start_date;
    @JsonProperty("end_date")
    private Date end_date;
}
