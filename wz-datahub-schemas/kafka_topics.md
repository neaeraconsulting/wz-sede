# Kafka Topic Configuration

The naming conventions follow the suggested best practices
from [Confluent](https://www.confluent.io/learn/kafka-topic-naming-convention/) for the Hierarchical Pattern. The
separators we will use are `.` and `_`. The `.` indicates a change hierarchy. The `_` acts as a word separator.

## Structure of a name:

`[data source].[data type]`

### Data Source / Domain

This identifies the system or domain where the data originates. In our case, either `conadmin` or `datahub`.

### Data Type

This identifies the type of data. In our case, something like `project` or `work_zone`.

### Examples

- `conadmin.project`
- `datahub.work_zone`

## ConAdmin

- topic.conadmin.field_device
  - schema: datahub.v1.conadmin.ConAdminFieldDeviceUpdate
  - description: field device changes coming from ConAdmin
- topic.conadmin.project
  - schema: datahub.v1.conadmin.ConAdminProjectUpdate
  - description: project changes coming from ConAdmin
- topic.conadmin.road_event_update
  - schema: datahub.v1.conadmin.ConAdminRoadEventUpdate
  - description: work zone changes coming from ConAdmin
- topic.conadmin.road_event_approval
  - schema: datahub.v1.conadmin.ConAdminRoadEventApproval
  - description: work zone changes coming from ConAdmin

## Data Hub

- topic.datahub.field_device
  - schema: datahub.v1.datahub.DataHubFieldDeviceUpdate
  - description: Requested field device changes coming from DataHub
- topic.datahub.work_zone
  - schema: datahub.v1.datahub.DataHubRoadEventUpdate
  - description: Requested work zone changes coming from DataHub
- topic.datahub.raw_vehicle_location
  - schema: WYDOT avl (automated vehicle location) message
  - description: AVL vehicle data coming from a forwarder ingested by the DataHub
- topic.datahub.message_generator_sync
  - schema: datahub.v1.datahub.CreateRoadEvent
  - description: Sharing road event data with the message generator for syncing updates
