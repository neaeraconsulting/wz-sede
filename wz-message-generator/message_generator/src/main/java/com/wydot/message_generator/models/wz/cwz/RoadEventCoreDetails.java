package com.wydot.message_generator.models.wz.cwz;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Builder;
import lombok.Data;

/**
 * Class representing the core details of a road event.
 * 
 * @see <a href=
 *      "https://github.com/usdot-jpo-ode/wzdx/blob/main/spec-content/objects/RoadEventCoreDetails.md">RoadEventCoreDetails</a>
 */
@Data
@Builder
public class RoadEventCoreDetails {
    @JsonProperty("event_type")
    private EventType eventType;
    @JsonProperty("data_source_id")
    private String dataSourceId;
    @JsonProperty("road_names")
    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    private List<String> roadNames;
    @JsonProperty("direction")
    private RoadwayDirection direction;
    @JsonProperty("related_road_events")
    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    private List<RelatedRoadEvent> relatedRoadEvents;
    @JsonProperty("name")
    private String name;
    @JsonProperty("description")
    private String description;
    @JsonProperty("creation_date")
    private String creationDate;
    @JsonProperty("update_date")
    private String updateDate;
}
