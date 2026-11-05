package com.wydot.message_generator.models.wz.cwz;

import lombok.Builder;
import lombok.Data;
import wyo.dot.protobuf.RoadEvent;
import wyo.dot.protobuf.RoadSubEvent;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Instant;
import java.util.List;

@Data
@Builder
@Document(collection = "generated_cwz_messages")
public class CwzFeedWrapper {
    @Id
    private String id;
    private Instant timestamp;
    private CwzFeed cwz;
    private String serializedCwz;
    private RoadEvent roadEvent;
    private List<RoadSubEvent> roadSubEvents;
}
