package com.wydot.message_generator.kafka;

import java.util.List;

public class KafkaTopics {
    public final static String CON_ADMIN_ROAD_EVENT_UPDATE = "topic.conadmin.road_event_update";
    public final static String CON_ADMIN_FIELD_DEVICE = "topic.conadmin.field_device";
    public final static String DATAHUB_FIELD_DEVICE = "topic.datahub.field_device";
    public final static String MESSAGE_GENERATOR_SYNC = "topic.datahub.message_generator_sync";

    public final static List<String> topics = List.of(
            CON_ADMIN_ROAD_EVENT_UPDATE,
            CON_ADMIN_FIELD_DEVICE,
            DATAHUB_FIELD_DEVICE,
            MESSAGE_GENERATOR_SYNC);

}
