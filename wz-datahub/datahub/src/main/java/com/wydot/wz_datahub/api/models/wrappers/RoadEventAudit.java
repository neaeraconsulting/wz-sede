package com.wydot.wz_datahub.api.models.wrappers;

import java.util.List;

import com.wydot.wz_datahub.api.models.audit.AuditLogEntry;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import wyo.dot.protobuf.DataHubRoadEventUpdate;
import wyo.dot.protobuf.conadmin.ConAdminRoadEventApproval;
import wyo.dot.protobuf.conadmin.ConAdminRoadEventUpdate;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class RoadEventAudit {
    Long roadEventId;
    RoadEventWithContext updatedRoadEventContext;
    RoadEventWithContext previousRoadEventContext;
    DataHubRoadEventUpdate roadEventUpdateMessage;
    ConAdminRoadEventUpdate conAdminUpdateMessage;
    ConAdminRoadEventApproval conAdminApprovalMessage;
    List<AuditLogEntry> logs;
    List<String> changes;
    Long requestId;
    Long timestamp;
}
