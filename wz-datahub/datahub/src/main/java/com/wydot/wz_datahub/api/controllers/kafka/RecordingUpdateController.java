package com.wydot.wz_datahub.api.controllers.kafka;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Controller;

import com.wydot.wz_datahub.api.accessors.recordings.RecordingRepository;
import com.wydot.wz_datahub.api.accessors.road_event.RoadEventRepository;
import com.wydot.wz_datahub.api.kafka.KafkaTopics;
import com.wydot.wz_datahub.api.models.recordings.RecordingWithId;
import com.wydot.wz_datahub.api.models.wrappers.RoadEventWrapper;
import com.wydot.wz_datahub.api.update_processors.RecordingUpdateProcessor;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.DataHubRoadEventUpdate;

@Controller
@Slf4j
@RequiredArgsConstructor
public class RecordingUpdateController {
    private final RecordingRepository recordingRepository;
    private final RecordingUpdateProcessor recordingUpdateProcessor;
    private final RoadEventRepository roadEventRepository;

    @Autowired
    private KafkaTemplate<String, DataHubRoadEventUpdate> template;

    public Long createNewRoadEvent(RecordingWithId recording) {
        DataHubRoadEventUpdate updateMessage = recordingUpdateProcessor.createDataHubRoadEventFromRecording(recording);
        Long roadEventId = null;
        if (updateMessage != null) {
            this.template.send(KafkaTopics.DATAHUB_ROAD_EVENT, String.valueOf(updateMessage.getRequestId()),
                    updateMessage);
            roadEventId = updateMessage.getCreated().getRoadEvent().getId();
        } else {
            log.warn("Failed to create DataHubRoadEventUpdate from recording: {}", recording);
        }
        return roadEventId;
    }

    public Long updateRoadEvent(RecordingWithId recording) {
        // If the recording does not have a road event ID, try to find it from the
        // repository
        if (recording.getRoadEventId() == null) {
            List<RecordingWithId> recordings = recordingRepository.find(recording.getId(), null, null, null, null, null,
                    PageRequest.of(0, 1)).getContent();
            if (!recordings.isEmpty()) {
                Long prevRoadEventId = recordings.getFirst().getRoadEventId();
                if (prevRoadEventId != null && recording.getRoadEventId() == null) {
                    recording.setRoadEventId(prevRoadEventId);
                } else if (prevRoadEventId != null && recording.getRoadEventId() != null
                        && !prevRoadEventId.equals(recording.getRoadEventId())) {
                    log.warn(
                            "Recording with ID {} has a road event ID of {} but the recording update has a different road event ID of {}. Using the previous recording's road event ID.",
                            recording.getId(), prevRoadEventId, recording.getRoadEventId());
                    // TODO: Remove road event matching recording.getRoadEventId()? Don't want to
                    // leave orphaned if was created by recording
                } else {
                    log.warn("No linked road event found for ID {}. Cannot update road event. Creating new road event",
                            recording.getId());
                    return createNewRoadEvent(recording);
                }
            } else {
                log.warn("No linked road event found for ID {}. Cannot update road event. Creating new road event",
                        recording.getId());
                return createNewRoadEvent(recording);
            }
        }

        // If the recording has a road event ID, try to find it from the repository
        RoadEventWrapper roadEventWrapper = roadEventRepository
                .findOne(recording.getRoadEventId(), null, null, null, null, null, null, null);
        if (roadEventWrapper == null) {
            log.warn("No road event found for ID {}. Cannot update road event. Creating new road event",
                    recording.getRoadEventId());
            recording.setRoadEventId(null); // Reset road event ID if not found
            return createNewRoadEvent(recording);
        }

        // Create the update message
        DataHubRoadEventUpdate updateMessage = recordingUpdateProcessor
                .updateDataHubRoadEventFromRecording(recording, roadEventWrapper);
        if (updateMessage != null) {
            this.template.send(KafkaTopics.DATAHUB_ROAD_EVENT, String.valueOf(updateMessage.getRequestId()),
                    updateMessage);
        } else {
            log.warn("Failed to create DataHubRoadEventUpdate from recording: {}", recording);
        }
        return roadEventWrapper.getRoadEvent().getId();
    }
}
