package com.wydot.wz_datahub.api.models.wrappers;

import java.time.Instant;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import wyo.dot.protobuf.Project;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class ProjectWrapper {
    private Project project;
    private Instant updateDate;
}
