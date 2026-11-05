#!/bin/bash
cd ./wz-datahub-schemas
protoc --dart_out=../lib/models/generated ./*.proto
protoc --dart_out=../lib/models/generated ./google/type/*.proto
protoc --dart_out=../lib/models/generated ./google/protobuf/*.proto