#!/bin/bash
cd "$(dirname "$0")/../wz-datahub-schemas"
protoc --dart_out=../wz-activity-monitor/lib/models/generated ./*.proto
protoc --dart_out=../wz-activity-monitor/lib/models/generated ./google/type/*.proto
protoc --dart_out=../wz-activity-monitor/lib/models/generated ./google/protobuf/*.proto