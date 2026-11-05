
package com.wydot.wz_datahub.api.accessors.projects;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.wydot.wz_datahub.api.models.wrappers.ProjectWrapper;

public interface ProjectRepository {
    long count(Long id, String userId, Long generatedStartTime, Long generatedEndTime,
            Long activeStartTime,
            Long activeEndTime);

    Page<ProjectWrapper> find(Long id, String userId, Long generatedStartTime, Long generatedEndTime,
            Long activeStartTime, Long activeEndTime, Pageable pageable);

    void update(Long id, ProjectWrapper project);

    void delete(Long id);
}