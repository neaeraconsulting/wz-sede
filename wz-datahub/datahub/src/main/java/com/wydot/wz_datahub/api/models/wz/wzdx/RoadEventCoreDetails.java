package com.wydot.wz_datahub.api.models.wz.wzdx;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

/**
 * Class representing the core details of a road event.
 * 
 * @see <a href=
 *      "https://github.com/usdot-jpo-ode/wzdx/blob/main/spec-content/objects/RoadEventCoreDetails.md">RoadEventCoreDetails</a>
 */
@Data
public class RoadEventCoreDetails {
    @JsonProperty("event_type")
    private EventType eventType;
    @JsonProperty("data_source_id")
    private String dataSourceId;
    @JsonProperty("road_names")
    private List<String> roadNames;
    @JsonProperty("direction")
    private RoadwayDirection direction;
    @JsonProperty("related_road_events")
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
