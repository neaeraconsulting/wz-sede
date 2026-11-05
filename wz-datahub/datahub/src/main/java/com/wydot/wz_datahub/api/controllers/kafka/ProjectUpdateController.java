package com.wydot.wz_datahub.api.controllers.kafka;

import org.springframework.stereotype.Controller;

import com.wydot.wz_datahub.api.ProtobufUtils;
import com.wydot.wz_datahub.api.accessors.projects.ProjectRepository;
import com.wydot.wz_datahub.api.models.wrappers.ProjectWrapper;

import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.Project;
import wyo.dot.protobuf.conadmin.ConAdminProjectUpdate;

@Controller
@Slf4j
public class ProjectUpdateController {
    private final ProjectRepository projectRepository;

    public ProjectUpdateController(
            ProjectRepository projectRepository) {
        this.projectRepository = projectRepository;
    }

    public void handleProjectUpdate(ConAdminProjectUpdate update) {
        log.info("Received project update: {}", update.getRequestId());

        switch (update.getTypeCase()) {
            case CREATED:
                handleProjectCreated(update);
                break;
            case UPDATED:
                handleProjectUpdated(update);
                break;
            case REMOVED:
                handleProjectRemoved(update);
                break;
            default:
                log.warn("Received unrecognized project update: {}", update.getRequestId());
        }
    }

    private void handleProjectCreated(ConAdminProjectUpdate update) {
        Project project = update.getCreated().getProject();
        ProjectWrapper wrapper = new ProjectWrapper(project, ProtobufUtils.instantFromTimestamp(update.getTimestamp()));
        projectRepository.update(project.getId(), wrapper);
    }

    private void handleProjectUpdated(ConAdminProjectUpdate update) {
        Long projectId = update.getUpdated().getProject().getId();
        Project project = update.getUpdated().getProject();
        ProjectWrapper wrapper = new ProjectWrapper(project, ProtobufUtils.instantFromTimestamp(update.getTimestamp()));
        projectRepository.update(projectId, wrapper);
    }

    private void handleProjectRemoved(ConAdminProjectUpdate update) {
        Long projectId = update.getRemoved().getProjectId();
        projectRepository.delete(projectId);
    }
}
