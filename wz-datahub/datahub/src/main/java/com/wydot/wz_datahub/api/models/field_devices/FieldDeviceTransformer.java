package com.wydot.wz_datahub.api.models.field_devices;

import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Component;

import com.google.protobuf.Timestamp;
import com.google.type.LatLng;
import com.wydot.wz_datahub.api.ProtobufUtils;
import com.wydot.wz_datahub.api.models.raw_data.RawDataType;
import com.wydot.wz_datahub.api.models.wz.device_feed.FieldDeviceFeature;
import com.wydot.wz_datahub.api.models.wz.device_feed.properties.FieldDeviceProperties;
import com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoard;
import com.wydot.wz_datahub.api.models.wz.device_feed.properties.camera.Camera;
import com.wydot.wz_datahub.api.models.wz.device_feed.properties.dynamic_message_sign.DynamicMessageSign;
import com.wydot.wz_datahub.api.models.wz.device_feed.properties.flashing_beacon.FlashingBeacon;
import com.wydot.wz_datahub.api.models.wz.device_feed.properties.hybrid_sign.HybridSign;
import com.wydot.wz_datahub.api.models.wz.device_feed.properties.marked_location.LocationMarker;
import com.wydot.wz_datahub.api.models.wz.device_feed.properties.traffic_sensor.TrafficSensor;
import com.wydot.wz_datahub.api.models.wz.device_feed.properties.traffic_signal.TrafficSignal;
import com.wydot.wz_datahub.api.models.wz.wzdx.geometry.GeoJsonPoint;
import com.wydot.wz_datahub.api.update_processors.UpdateProcessorUtils;
import com.wydot.wz_datahub.api.utilities.gis_service.GisService;

import lombok.RequiredArgsConstructor;
import reactor.core.publisher.Mono;
import wyo.dot.protobuf.FieldDevice;
import wyo.dot.protobuf.FieldDevice.ArrowBoard.ArrowBoardPattern;
import wyo.dot.protobuf.FieldDevice.ArrowBoard.ArrowBoardTransportPosition;
import wyo.dot.protobuf.FieldDevice.FlashingBeacon.FlashingBeaconFunction;
import wyo.dot.protobuf.FieldDevice.HybridSign.HybridSignDynamicMessageFunction;
import wyo.dot.protobuf.FieldDevice.TrafficSignal.TrafficSignalMode;
import wyo.dot.protobuf.FieldDevice.FieldDeviceCoreDetails;
import wyo.dot.protobuf.FieldDevice.FieldDeviceStatus;
import wyo.dot.protobuf.MarkedLocationType;
import wyo.dot.protobuf.PointGeometry;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@RequiredArgsConstructor
public class FieldDeviceTransformer {
    public Mono<FieldDeviceReading> transformToFieldDevice(FieldDeviceFeature feature, RawDataType dataType,
            GisService gisService) {
        FieldDeviceProperties properties = feature.getProperties();
        com.wydot.wz_datahub.api.models.wz.device_feed.FieldDeviceCoreDetails coreDetails = properties.getCoreDetails();

        FieldDeviceCoreDetails.Builder transformedCoreDetails = FieldDeviceCoreDetails.newBuilder();
        transformedCoreDetails = applyCoreDetails(transformedCoreDetails, dataType, coreDetails);

        FieldDevice.Builder builder = FieldDevice.newBuilder();
        builder.setLocationType(MarkedLocationType.MARKED_LOCATION_TYPE_GENERIC); // will be overridden later
        builder = applyFieldDevice(builder, feature);
        UUID deviceId = getDeterministicDeviceId(coreDetails.getSerialNumber(), dataType);
        if (((GeoJsonPoint) feature.getGeometry()).getCoordinates() == null
                || ((GeoJsonPoint) feature.getGeometry()).getCoordinates().size() < 2) {
            log.error("Invalid geometry for device with serial number: {}", coreDetails.getSerialNumber());
            return Mono.empty();
        }
        builder = builder
                .setId(deviceId.toString())
                // .setProjectId(0L) // TODO: try to automatically link?!
                // .setRoadEventId(0L) // TODO: try to automatically link?!
                .setGeometry(PointGeometry.newBuilder().setCoordinates( // TODO: map more geometry types?
                        LatLng.newBuilder()
                                .setLatitude(((GeoJsonPoint) feature.getGeometry()).getCoordinates().getLast())
                                .setLongitude(((GeoJsonPoint) feature.getGeometry()).getCoordinates().getFirst())))
                // .setBbox(null)
                .setCoreDetails(transformedCoreDetails);
        return FieldDeviceReading.fromDevice(builder.build(), coreDetails.getUpdateDate(), gisService);
    }

    public UUID getDeterministicDeviceId(String serialNumber, RawDataType dataType) {
        String id = dataType.name() + serialNumber;
        return UUID.nameUUIDFromBytes(id.getBytes());
    }

    public FieldDeviceCoreDetails.Builder applyCoreDetails(FieldDeviceCoreDetails.Builder builder,
            RawDataType dataType,
            com.wydot.wz_datahub.api.models.wz.device_feed.FieldDeviceCoreDetails coreDetails) {
        // Required Fields
        builder.setDeviceStatus(getDeviceStatus(coreDetails.getDeviceStatus())); // Status will be updated for
                                                                                 // offline/inactive by .updateStatus()
                                                                                 // later
        builder.setHasAutomaticLocation(coreDetails.getHasAutomaticLocation());
        builder.setIsMoving(coreDetails.getIsMoving() != null ? coreDetails.getIsMoving() : false);
        builder.setName(coreDetails.getName() != null ? coreDetails.getName() : coreDetails.getDeviceType().name());
        builder.setMake(dataType.getDeviceMake(coreDetails.getMake()));
        builder.setModel(coreDetails.getMake() != null ? coreDetails.getMake() : coreDetails.getDeviceType().name());
        builder.setSerialNumber(coreDetails.getSerialNumber() != null ? coreDetails.getSerialNumber() : "");

        // Optional Fields
        ProtobufUtils.setIfNotNull(UpdateProcessorUtils.getRoadwayDirection(coreDetails.getRoadDirection()),
                builder::setRoadDirection);
        // Do not set road names, we only trust WYDOT's GIS generated road names
        ProtobufUtils.setIfNotNull(coreDetails.getDescription(), builder::setDescription);
        ProtobufUtils.setIfNotNull(coreDetails.getStatusMessages(), builder::addAllStatusMessages);
        ProtobufUtils.setIfNotNull(coreDetails.getMilepost(), builder::setMilepost);
        ProtobufUtils.setIfNotNull(coreDetails.getFirmwareVersion(), builder::setFirmwareVersion);
        ProtobufUtils.setIfNotNull(coreDetails.getVelocityKph(), builder::setVelocityKph);
        return builder;
    }

    public static FieldDevice.Builder applyFieldDevice(
            FieldDevice.Builder builder, FieldDeviceFeature fieldDevice) {

        FieldDeviceProperties properties = fieldDevice.getProperties();
        com.wydot.wz_datahub.api.models.wz.device_feed.FieldDeviceCoreDetails coreDetails = properties.getCoreDetails();
        switch (coreDetails.getDeviceType()) {
            case com.wydot.wz_datahub.api.models.wz.device_feed.FieldDeviceType.ARROW_BOARD:
                return applyDeviceArrowBoard(builder, (ArrowBoard) properties);
            case com.wydot.wz_datahub.api.models.wz.device_feed.FieldDeviceType.CAMERA:
                return applyDeviceCamera(builder, (Camera) properties);
            case com.wydot.wz_datahub.api.models.wz.device_feed.FieldDeviceType.DYNAMIC_MESSAGE_SIGN:
                return applyDeviceDynamicMessageSign(builder, (DynamicMessageSign) properties);
            case com.wydot.wz_datahub.api.models.wz.device_feed.FieldDeviceType.FLASHING_BEACON:
                return applyDeviceFlashingBeacon(builder, (FlashingBeacon) properties);
            case com.wydot.wz_datahub.api.models.wz.device_feed.FieldDeviceType.HYBRID_SIGN:
                return applyDeviceHybridSign(builder, (HybridSign) properties);
            case com.wydot.wz_datahub.api.models.wz.device_feed.FieldDeviceType.LOCATION_MARKER:
                return applyDeviceLocationMarker(builder, (LocationMarker) properties);
            case com.wydot.wz_datahub.api.models.wz.device_feed.FieldDeviceType.TRAFFIC_SENSOR:
                return applyDeviceTrafficSensor(builder, (TrafficSensor) properties);
            case com.wydot.wz_datahub.api.models.wz.device_feed.FieldDeviceType.TRAFFIC_SIGNAL:
                return applyDeviceTrafficSignal(builder, (TrafficSignal) properties);
            default:
                throw new IllegalArgumentException("Unable to deserialize Message: Unknown structure");
        }
    }

    public static FieldDevice.Builder applyDeviceArrowBoard(FieldDevice.Builder builder,
            ArrowBoard props) {
        return builder
                .setArrowBoard(
                        FieldDevice.ArrowBoard.newBuilder()
                                .setPattern(getArrowBoardPattern(props.getPattern()))
                                .setIsInTransportPosition(getArrowBoardTransportPosition(
                                        props.getIsInTransportPosition())))
                .setLocationType(getMarkedLocationFromArrowBoardPattern(props.getPattern()));
    }

    public static FieldDevice.Builder applyDeviceCamera(FieldDevice.Builder builder,
            Camera props) {
        FieldDevice.Camera.Builder cmBuilder = FieldDevice.Camera.newBuilder();
        ProtobufUtils.setIfNotNull(props.getImage_url(), cmBuilder::setImageUrl);
        Timestamp ts = props.getImageTimestamp() != null
                ? ProtobufUtils.timestampFromMillis(props.getImageTimestamp().toEpochMilli())
                : null;
        ProtobufUtils.setIfNotNull(ts, cmBuilder::setImageTimestamp);
        return builder
                .setCamera(cmBuilder);
    }

    public static FieldDevice.Builder applyDeviceDynamicMessageSign(FieldDevice.Builder builder,
            DynamicMessageSign props) {
        return builder
                .setDynamicMessageSign(
                        FieldDevice.DynamicMessageSign.newBuilder()
                                .setMessageMultiString(props.getMessageMultiString()));
    }

    public static FieldDevice.Builder applyDeviceFlashingBeacon(FieldDevice.Builder builder,
            FlashingBeacon props) {
        FieldDevice.FlashingBeacon.Builder fbBuilder = FieldDevice.FlashingBeacon.newBuilder()
                .setFunction(getFlashingBeaconFunction(props.getFunction()));
        ProtobufUtils.setIfNotNull(props.getIsFlashing(), fbBuilder::setIsFlashing);
        ProtobufUtils.setIfNotNull(props.getSignText(), fbBuilder::setSignText);

        return builder.setFlashingBeacon(fbBuilder);
    }

    public static FieldDevice.Builder applyDeviceHybridSign(FieldDevice.Builder builder,
            HybridSign props) {
        FieldDevice.HybridSign.Builder hsBuilder = FieldDevice.HybridSign.newBuilder()
                .setDynamicMessageFunction(
                        getHybridSignDynamicMessageFunction(props.getDynamicMessageFunction()));
        ProtobufUtils.setIfNotNull(props.getDynamicMessageText(), hsBuilder::setDynamicMessageText);
        ProtobufUtils.setIfNotNull(props.getStaticSignText(), hsBuilder::setStaticSignText);
        return builder.setHybridSign(hsBuilder);
    }

    public static FieldDevice.Builder applyDeviceLocationMarker(FieldDevice.Builder builder,
            LocationMarker props) {
        if (props.getMarkedLocations() != null && props.getMarkedLocations().size() > 0) {
            // If there are marked locations, set the location marker type based on the
            // first one
            builder.setLocationType(getMarkedLocationType(props.getMarkedLocations().getFirst().getLocationType()));
        }
        return builder
                .setLocationMarker(
                        FieldDevice.LocationMarker.newBuilder());
    }

    public static FieldDevice.Builder applyDeviceTrafficSensor(FieldDevice.Builder builder,
            TrafficSensor props) {
        FieldDevice.TrafficSensor.Builder tsBuilder = FieldDevice.TrafficSensor.newBuilder()
                .setCollectionIntervalStartDate(
                        ProtobufUtils.timestampFromMillis(
                                props.getCollectionIntervalStartDate().toEpochMilli()))
                .setCollectionIntervalEndDate(
                        ProtobufUtils.timestampFromMillis(
                                props.getCollectionIntervalEndDate().toEpochMilli()))
                .addAllLaneData(List.of());
        ProtobufUtils.setIfNotNull(props.getAverageSpeedKph(), tsBuilder::setAverageSpeedKph);
        ProtobufUtils.setIfNotNull(props.getVolumeVph(), tsBuilder::setVolumeKph);
        ProtobufUtils.setIfNotNull(props.getOccupancyPercent(), tsBuilder::setOccupancyPercent);
        return builder.setTrafficSensor(tsBuilder);
    }

    public static FieldDevice.Builder applyDeviceTrafficSignal(FieldDevice.Builder builder,
            TrafficSignal props) {
        return builder
                .setTrafficSignal(
                        FieldDevice.TrafficSignal.newBuilder()
                                .setMode(
                                        getTrafficSignalMode(props.getMode())));
    }

    public static ArrowBoardTransportPosition getArrowBoardTransportPosition(Boolean bool) {
        if (bool == null) {
            return ArrowBoardTransportPosition.ARROW_BOARD_TRANSPORT_POSITION_UNKNOWN;
        }
        return bool ? ArrowBoardTransportPosition.ARROW_BOARD_TRANSPORT_POSITION_STOWED
                : ArrowBoardTransportPosition.ARROW_BOARD_TRANSPORT_POSITION_DEPLOYED;
    }

    public static ArrowBoardPattern getArrowBoardPattern(
            com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern pattern) {
        if (pattern == null) {
            return ArrowBoardPattern.ARROW_BOARD_PATTERN_UNKNOWN;
        }
        switch (pattern) {
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.BLANK:
                return ArrowBoardPattern.ARROW_BOARD_PATTERN_BLANK;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.RIGHT_ARROW_STATIC:
                return ArrowBoardPattern.ARROW_BOARD_PATTERN_RIGHT_ARROW_STATIC;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.RIGHT_ARROW_FLASHING:
                return ArrowBoardPattern.ARROW_BOARD_PATTERN_RIGHT_ARROW_FLASHING;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.RIGHT_ARROW_SEQUENTIAL:
                return ArrowBoardPattern.ARROW_BOARD_PATTERN_RIGHT_ARROW_SEQUENTIAL;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.RIGHT_CHEVRON_STATIC:
                return ArrowBoardPattern.ARROW_BOARD_PATTERN_RIGHT_CHEVRON_STATIC;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.RIGHT_CHEVRON_FLASHING:
                return ArrowBoardPattern.ARROW_BOARD_PATTERN_RIGHT_CHEVRON_FLASHING;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.RIGHT_CHEVRON_SEQUENTIAL:
                return ArrowBoardPattern.ARROW_BOARD_PATTERN_RIGHT_CHEVRON_SEQUENTIAL;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.LEFT_ARROW_STATIC:
                return ArrowBoardPattern.ARROW_BOARD_PATTERN_LEFT_ARROW_STATIC;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.LEFT_ARROW_FLASHING:
                return ArrowBoardPattern.ARROW_BOARD_PATTERN_LEFT_ARROW_FLASHING;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.LEFT_ARROW_SEQUENTIAL:
                return ArrowBoardPattern.ARROW_BOARD_PATTERN_LEFT_ARROW_SEQUENTIAL;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.LEFT_CHEVRON_STATIC:
                return ArrowBoardPattern.ARROW_BOARD_PATTERN_LEFT_CHEVRON_STATIC;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.LEFT_CHEVRON_FLASHING:
                return ArrowBoardPattern.ARROW_BOARD_PATTERN_LEFT_CHEVRON_FLASHING;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.LEFT_CHEVRON_SEQUENTIAL:
                return ArrowBoardPattern.ARROW_BOARD_PATTERN_LEFT_CHEVRON_SEQUENTIAL;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.BIDIRECTIONAL_ARROW_STATIC:
                return ArrowBoardPattern.ARROW_BOARD_PATTERN_BIDIRECTIONAL_ARROW_STATIC;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.BIDIRECTIONAL_ARROW_FLASHING:
                return ArrowBoardPattern.ARROW_BOARD_PATTERN_BIDIRECTIONAL_ARROW_FLASHING;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.LINE_FLASHING:
                return ArrowBoardPattern.ARROW_BOARD_PATTERN_LINE_FLASHING;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.DIAMONDS_ALTERNATING:
                return ArrowBoardPattern.ARROW_BOARD_PATTERN_DIAMONDS_ALTERNATING;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.FOUR_CORNERS_FLASHING:
                return ArrowBoardPattern.ARROW_BOARD_PATTERN_FOUR_CORNERS_FLASHING;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.UNKNOWN:
                return ArrowBoardPattern.ARROW_BOARD_PATTERN_UNKNOWN;
            default:
                return ArrowBoardPattern.ARROW_BOARD_PATTERN_UNKNOWN;
        }
    }

    public static MarkedLocationType getMarkedLocationFromArrowBoardPattern(
            com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern pattern) {
        if (pattern == null) {
            return MarkedLocationType.MARKED_LOCATION_TYPE_UNKNOWN;
        }
        switch (pattern) {
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.BLANK:
                return MarkedLocationType.MARKED_LOCATION_TYPE_UNKNOWN;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.RIGHT_ARROW_STATIC:
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.RIGHT_ARROW_FLASHING:
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.RIGHT_ARROW_SEQUENTIAL:
                return MarkedLocationType.MARKED_LOCATION_TYPE_LANE_CLOSURE_START;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.RIGHT_CHEVRON_STATIC:
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.RIGHT_CHEVRON_FLASHING:
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.RIGHT_CHEVRON_SEQUENTIAL:
                return MarkedLocationType.MARKED_LOCATION_TYPE_GENERIC;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.LEFT_ARROW_STATIC:
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.LEFT_ARROW_FLASHING:
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.LEFT_ARROW_SEQUENTIAL:
                return MarkedLocationType.MARKED_LOCATION_TYPE_LANE_CLOSURE_START;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.LEFT_CHEVRON_STATIC:
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.LEFT_CHEVRON_FLASHING:
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.LEFT_CHEVRON_SEQUENTIAL:
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.BIDIRECTIONAL_ARROW_STATIC:
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.BIDIRECTIONAL_ARROW_FLASHING:
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.LINE_FLASHING:
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.DIAMONDS_ALTERNATING:
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.FOUR_CORNERS_FLASHING:
                return MarkedLocationType.MARKED_LOCATION_TYPE_GENERIC;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.arrow_board.ArrowBoardPattern.UNKNOWN:
                return MarkedLocationType.MARKED_LOCATION_TYPE_UNKNOWN;
            default:
                return MarkedLocationType.MARKED_LOCATION_TYPE_UNKNOWN;
        }
    }

    public static FlashingBeaconFunction getFlashingBeaconFunction(
            com.wydot.wz_datahub.api.models.wz.device_feed.properties.flashing_beacon.FlashingBeaconFunction function) {
        if (function == null) {
            return FlashingBeaconFunction.FLASHING_BEACON_FUNCTION_UNKNOWN;
        }
        return switch (function) {
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.flashing_beacon.FlashingBeaconFunction.VEHICLE_ENTERING ->
                FlashingBeaconFunction.FLASHING_BEACON_FUNCTION_VEHICLE_ENTERING;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.flashing_beacon.FlashingBeaconFunction.QUEUE_WARNING ->
                FlashingBeaconFunction.FLASHING_BEACON_FUNCTION_QUEUE_WARNING;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.flashing_beacon.FlashingBeaconFunction.REDUCED_SPEED ->
                FlashingBeaconFunction.FLASHING_BEACON_FUNCTION_REDUCED_SPEED;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.flashing_beacon.FlashingBeaconFunction.WORKERS_PRESENT ->
                FlashingBeaconFunction.FLASHING_BEACON_FUNCTION_WORKERS_PRESENT;
            default -> FlashingBeaconFunction.FLASHING_BEACON_FUNCTION_UNKNOWN;
        };
    }

    public static HybridSignDynamicMessageFunction getHybridSignDynamicMessageFunction(
            com.wydot.wz_datahub.api.models.wz.device_feed.properties.hybrid_sign.HybridSignDynamicMessageFunction function) {
        if (function == null) {
            return HybridSignDynamicMessageFunction.HYBRID_SIGN_DYNAMIC_MESSAGE_FUNCTION_UNKNOWN;
        }
        return switch (function) {
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.hybrid_sign.HybridSignDynamicMessageFunction.SPEED_LIMIT ->
                HybridSignDynamicMessageFunction.HYBRID_SIGN_DYNAMIC_MESSAGE_FUNCTION_SPEED_LIMIT;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.hybrid_sign.HybridSignDynamicMessageFunction.TRAVEL_TIME ->
                HybridSignDynamicMessageFunction.HYBRID_SIGN_DYNAMIC_MESSAGE_FUNCTION_TRAVEL_TIME;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.hybrid_sign.HybridSignDynamicMessageFunction.OTHER ->
                HybridSignDynamicMessageFunction.HYBRID_SIGN_DYNAMIC_MESSAGE_FUNCTION_OTHER;
            default -> HybridSignDynamicMessageFunction.HYBRID_SIGN_DYNAMIC_MESSAGE_FUNCTION_UNKNOWN;
        };
    }

    public static FieldDeviceStatus getDeviceStatus(
            com.wydot.wz_datahub.api.models.wz.device_feed.FieldDeviceStatus status) {
        if (status == null) {
            return FieldDeviceStatus.FIELD_DEVICE_STATUS_UNKNOWN;
        }
        switch (status) {
            case com.wydot.wz_datahub.api.models.wz.device_feed.FieldDeviceStatus.OK:
                return FieldDeviceStatus.FIELD_DEVICE_STATUS_OK;
            case com.wydot.wz_datahub.api.models.wz.device_feed.FieldDeviceStatus.WARNING:
                return FieldDeviceStatus.FIELD_DEVICE_STATUS_WARNING;
            case com.wydot.wz_datahub.api.models.wz.device_feed.FieldDeviceStatus.ERROR:
                return FieldDeviceStatus.FIELD_DEVICE_STATUS_ERROR;
            case com.wydot.wz_datahub.api.models.wz.device_feed.FieldDeviceStatus.UNKNOWN:
                return FieldDeviceStatus.FIELD_DEVICE_STATUS_UNKNOWN;
            default:
                return FieldDeviceStatus.FIELD_DEVICE_STATUS_UNKNOWN;
        }
    }

    public static MarkedLocationType getMarkedLocationType(
            com.wydot.wz_datahub.api.models.wz.device_feed.properties.marked_location.MarkedLocationType type) {
        if (type == null) {
            return MarkedLocationType.MARKED_LOCATION_TYPE_UNKNOWN;
        }
        return switch (type) {
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.marked_location.MarkedLocationType.AUTOMATIC_FLAGGER_ASSISTANCE_DEVICE ->
                MarkedLocationType.MARKED_LOCATION_TYPE_FLAGGER;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.marked_location.MarkedLocationType.DELINEATOR ->
                MarkedLocationType.MARKED_LOCATION_TYPE_GENERIC;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.marked_location.MarkedLocationType.FLAGGER ->
                MarkedLocationType.MARKED_LOCATION_TYPE_FLAGGER;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.marked_location.MarkedLocationType.LANE_SHIFT ->
                MarkedLocationType.MARKED_LOCATION_TYPE_GENERIC;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.marked_location.MarkedLocationType.LANE_CLOSURE ->
                MarkedLocationType.MARKED_LOCATION_TYPE_LANE_CLOSURE_START;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.marked_location.MarkedLocationType.PERSONAL_DEVICE ->
                MarkedLocationType.MARKED_LOCATION_TYPE_WORKER_POSITION;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.marked_location.MarkedLocationType.RAMP_CLOSURE ->
                MarkedLocationType.MARKED_LOCATION_TYPE_GENERIC;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.marked_location.MarkedLocationType.ROAD_CLOSURE ->
                MarkedLocationType.MARKED_LOCATION_TYPE_GENERIC;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.marked_location.MarkedLocationType.ROAD_EVENT_START ->
                MarkedLocationType.MARKED_LOCATION_TYPE_ROAD_EVENT_START;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.marked_location.MarkedLocationType.ROAD_EVENT_END ->
                MarkedLocationType.MARKED_LOCATION_TYPE_ROAD_EVENT_END;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.marked_location.MarkedLocationType.WORK_TRUCK_WITH_LIGHTS_FLASHING ->
                MarkedLocationType.MARKED_LOCATION_TYPE_GENERIC;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.marked_location.MarkedLocationType.WORK_ZONE_START ->
                MarkedLocationType.MARKED_LOCATION_TYPE_ROAD_EVENT_START;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.marked_location.MarkedLocationType.WORK_ZONE_END ->
                MarkedLocationType.MARKED_LOCATION_TYPE_ROAD_EVENT_END;
            default -> MarkedLocationType.MARKED_LOCATION_TYPE_UNKNOWN;
        };
    }

    public static TrafficSignalMode getTrafficSignalMode(
            com.wydot.wz_datahub.api.models.wz.device_feed.properties.traffic_signal.TrafficSignalMode type) {
        if (type == null) {
            return TrafficSignalMode.TRAFFIC_SIGNAL_MODE_UNKNOWN;
        }
        return switch (type) {
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.traffic_signal.TrafficSignalMode.BLANK ->
                TrafficSignalMode.TRAFFIC_SIGNAL_MODE_BLANK;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.traffic_signal.TrafficSignalMode.FLASHING_RED ->
                TrafficSignalMode.TRAFFIC_SIGNAL_MODE_FLASHING_RED;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.traffic_signal.TrafficSignalMode.FLASHING_YELLOW ->
                TrafficSignalMode.TRAFFIC_SIGNAL_MODE_FLASHING_YELLOW;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.traffic_signal.TrafficSignalMode.FULLY_ACTUATED ->
                TrafficSignalMode.TRAFFIC_SIGNAL_MODE_FULLY_ACTUATED;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.traffic_signal.TrafficSignalMode.MANUAL ->
                TrafficSignalMode.TRAFFIC_SIGNAL_MODE_MANUAL;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.traffic_signal.TrafficSignalMode.PRE_TIMED ->
                TrafficSignalMode.TRAFFIC_SIGNAL_MODE_PRE_TIMED;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.traffic_signal.TrafficSignalMode.SEMI_ACTUATED ->
                TrafficSignalMode.TRAFFIC_SIGNAL_MODE_SEMI_ACTUATED;
            case com.wydot.wz_datahub.api.models.wz.device_feed.properties.traffic_signal.TrafficSignalMode.UNKNOWN ->
                TrafficSignalMode.TRAFFIC_SIGNAL_MODE_UNKNOWN;
            default -> TrafficSignalMode.TRAFFIC_SIGNAL_MODE_UNKNOWN;
        };
    }
}
