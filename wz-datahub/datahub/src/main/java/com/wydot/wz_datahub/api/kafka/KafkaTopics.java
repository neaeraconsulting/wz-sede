package com.wydot.wz_datahub.api.kafka;

import java.util.List;

public class KafkaTopics {
    public final static String CON_ADMIN_PROJECT = "topic.conadmin.project";
    public final static String CON_ADMIN_ROAD_EVENT_UPDATE = "topic.conadmin.road_event_update";
    public final static String CON_ADMIN_ROAD_EVENT_APPROVAL = "topic.conadmin.road_event_approval";
    public final static String CON_ADMIN_FIELD_DEVICE = "topic.conadmin.field_device";
    public final static String DATAHUB_ROAD_EVENT = "topic.datahub.work_zone";
    public final static String DATAHUB_FIELD_DEVICE = "topic.datahub.field_device";
    public final static String RAW_VEHICLE_LOCATION = "topic.datahub.raw_vehicle_location";
    public final static String MESSAGE_GENERATOR_SYNC = "topic.datahub.message_generator_sync";

    public final static List<String> topics = List.of(
            CON_ADMIN_PROJECT,
            CON_ADMIN_ROAD_EVENT_UPDATE,
            CON_ADMIN_ROAD_EVENT_APPROVAL,
            CON_ADMIN_FIELD_DEVICE,
            DATAHUB_ROAD_EVENT,
            DATAHUB_FIELD_DEVICE,
            RAW_VEHICLE_LOCATION,
            MESSAGE_GENERATOR_SYNC);

}
