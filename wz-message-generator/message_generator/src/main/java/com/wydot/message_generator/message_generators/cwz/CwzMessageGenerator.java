package com.wydot.message_generator.message_generators.cwz;

import java.time.Instant;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.geojson.LineString;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.type.LatLng;
import com.wydot.message_generator.accessors.cwz.CwzRepository;
import com.wydot.message_generator.models.sdx.CosmosIdLink;
import com.wydot.message_generator.models.wz.cwz.CwzFeed;
import com.wydot.message_generator.models.wz.cwz.CwzFeedWrapper;
import com.wydot.message_generator.models.wz.cwz.EventType;
import com.wydot.message_generator.models.wz.cwz.FeedDataSource;
import com.wydot.message_generator.models.wz.cwz.FeedInfo;
import com.wydot.message_generator.models.wz.cwz.LocationMethod;
import com.wydot.message_generator.models.wz.cwz.RelatedRoadEvent;
import com.wydot.message_generator.models.wz.cwz.RelatedRoadEventType;
import com.wydot.message_generator.models.wz.cwz.RoadEventCoreDetails;
import com.wydot.message_generator.models.wz.cwz.RoadEventFeature;
import com.wydot.message_generator.models.wz.cwz.RoadwayDirection;
import com.wydot.message_generator.models.wz.cwz.WorkZoneRoadEvent;
import com.wydot.message_generator.sdx.SdxApiService;
import com.wydot.message_generator.utilities.UpdateProcessorUtils;

import kotlin.Pair;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;
import wyo.dot.protobuf.RoadEvent;
import wyo.dot.protobuf.RoadSubEvent;
import wyo.dot.protobuf.RoadSubEvent.BaseLayer;
import wyo.dot.protobuf.RoadSubEvent.SpeedReductionLayer;
import wyo.dot.protobuf.RoadSubEvent.WorkerPresenceLayer;

@Slf4j
@Component
public class CwzMessageGenerator {
    private static final Pattern INTERSTATE_PATTERN = Pattern.compile("ML(\\d+)I", Pattern.CASE_INSENSITIVE);

    private final SdxApiService sdxApi;
    private final CwzProperties cwzProperties;
    private final CwzRepository cwzRepository;
    private final ObjectMapper objectMapper;
    private final FeedDataSource dataSource;

    public CwzMessageGenerator(SdxApiService sdxApi, CwzProperties cwzProperties,
            CwzRepository cwzRepository, ObjectMapper objectMapper) {
        this.sdxApi = sdxApi;
        this.cwzProperties = cwzProperties;
        this.cwzRepository = cwzRepository;
        this.objectMapper = objectMapper;
        this.dataSource = cwzProperties.getDataSource().getFeedDataSource();
    }

    public Mono<CosmosIdLink> handleRoadEventCreated(RoadEvent roadEvent, List<RoadSubEvent> roadSubEvents) {
        CwzFeed cwz = generateFromRoadEvent(roadEvent, roadSubEvents);
        cwzRepository.insert(CwzFeedWrapper.builder()
                .id("create_" + roadEvent.getId() + "_" + Instant.now().toEpochMilli())
                .timestamp(Instant.now())
                .cwz(cwz)
                .serializedCwz(serializeCwz(cwz))
                .roadEvent(roadEvent)
                .roadSubEvents(roadSubEvents)
                .build());

        return sdxApi.depositWorkZone(cwz).map((String cosmosId) -> {
            return new CosmosIdLink(cosmosId, roadEvent.getId());
        });
    }

    public Mono<Void> handleRoadEventUpdated(CosmosIdLink link, RoadEvent roadEvent, List<RoadSubEvent> roadSubEvents) {
        CwzFeed cwz = generateFromRoadEvent(roadEvent, roadSubEvents);
        cwzRepository.insert(CwzFeedWrapper.builder()
                .id("update_" + roadEvent.getId() + "_" + Instant.now().toEpochMilli())
                .timestamp(Instant.now())
                .cwz(cwz)
                .serializedCwz(serializeCwz(cwz))
                .roadEvent(roadEvent)
                .roadSubEvents(roadSubEvents)
                .build());
        return sdxApi.updateWorkZone(link.getCosmosId(), cwz);
    }

    public Mono<Void> handleRoadEventDeleted(CosmosIdLink link) {
        return sdxApi.deleteWorkZone(link.getCosmosId());
    }

    public CwzFeed generateFromRoadEvent(RoadEvent roadEvent, List<RoadSubEvent> roadSubEvents) {
        dataSource.setUpdateDate(UpdateProcessorUtils.formatDateTime(Instant.now()));
        List<FeedDataSource> updatedDataSources = List.of(dataSource);

        return CwzFeed.builder()
                .feedInfo(generateFeedInfo(updatedDataSources)
                        .updateDate(UpdateProcessorUtils.formatDateTime(Instant.now())).build())
                .features(generateRoadEventFeatureList(roadEvent, roadSubEvents))
                .build();
    }

    public List<RoadEventFeature> generateRoadEventFeatureList(RoadEvent roadEvent,
            List<RoadSubEvent> roadSubEvents) {
        List<RoadEventFeature> features = new ArrayList<>();

        // 1. Collect all unique markers
        Set<Double> markerSet = new HashSet<>();
        Map<Double, Pair<String, LatLng>> crossStreetMap = new HashMap<>();
        for (RoadSubEvent rse : roadSubEvents) {
            markerSet.add(rse.getBeginningMilepost());
            markerSet.add(rse.getEndingMilepost());
            crossStreetMap.put(rse.getBeginningMilepost(), new Pair<>(rse.getBeginningCrossStreet(),
                    rse.getLineString().getCoordinates().getCoordinatesList().getFirst()));
            crossStreetMap.put(rse.getEndingMilepost(), new Pair<>(rse.getEndingCrossStreet(),
                    rse.getLineString().getCoordinates().getCoordinatesList().getLast()));
        }

        List<Double> sortedMeasures = markerSet.stream().sorted().toList();
        boolean isAscending = roadSubEvents.get(0).getEndingMilepost() > roadSubEvents.get(0).getBeginningMilepost();
        if (!isAscending) {
            sortedMeasures = sortedMeasures.reversed();
        }

        // Assumption: RoadEvent LineString contains all points within roadSubEvent
        // LineStrings
        Double previousMilepost = null;
        for (Double milepost : sortedMeasures) {
            if (milepost.equals(sortedMeasures.getFirst())) {
                // This is the first element - skip to next iteration
                previousMilepost = milepost;
                continue;
            }

            String previousCrossStreet = crossStreetMap.get(previousMilepost).getFirst();
            LatLng previousLatLng = crossStreetMap.get(previousMilepost).getSecond();

            String currentCrossStreet = crossStreetMap.get(milepost).getFirst();
            LatLng currentLatLng = crossStreetMap.get(milepost).getSecond();

            // End layers which end at this milepost
            BaseLayer baseLayer = null;
            RoadSubEvent baseRoadSubEvent = null;
            SpeedReductionLayer srzLayer = null;
            WorkerPresenceLayer wpLayer = null;
            for (RoadSubEvent rse : roadSubEvents) {
                if (isMilepostInEndRange(milepost, rse, isAscending)) {
                    switch (rse.getLayerCase()) {
                        case BASE_LAYER:
                            baseLayer = rse.getBaseLayer();
                            baseRoadSubEvent = rse;
                            break;
                        case SPEED_REDUCTION_LAYER:
                            srzLayer = rse.getSpeedReductionLayer();
                            break;
                        case WORKER_PRESENCE_LAYER:
                            wpLayer = rse.getWorkerPresenceLayer();
                            break;
                        default:
                            // No-op
                    }
                }
            }
            if (baseLayer == null || baseRoadSubEvent == null) {
                log.warn(
                        "No base layer found for milepost {} in road event {}, skipping feature generation for this milepost range.",
                        milepost, roadEvent.getId());
                previousMilepost = milepost;
                continue;
            }

            WorkZoneRoadEvent.WorkZoneRoadEventBuilder propertiesBuilder = WorkZoneRoadEvent.builder()
                    .coreDetails(generateRoadEventCoreDetails(roadEvent, baseRoadSubEvent))
                    .startDate(UpdateProcessorUtils.formatProtoTimestamp(roadEvent.getStartDate()))
                    .endDate(UpdateProcessorUtils.formatProtoTimestamp(roadEvent.getEndDate()))
                    .isStartDateVerified(false) // TODO: Map from observations
                    .isEndDateVerified(false) // TODO: Map from observations
                    .isStartPositionVerified(true) // TODO: Map from observations
                    .isEndPositionVerified(true) // TODO: Map from observations
                    .workZoneType(UpdateProcessorUtils.getWorkZoneType(roadEvent.getAreaType()))
                    .locationMethod(LocationMethod.CHANNEL_DEVICE_METHOD) // TODO: Map from observations
                    .vehicleImpact(
                            UpdateProcessorUtils.getVehicleImpact(baseLayer.getVehicleImpact()))
                    .lanes(UpdateProcessorUtils.getLanes(baseLayer.getLanesList()))
                    .beginningCrossStreet(previousCrossStreet)
                    .endingCrossStreet(currentCrossStreet)
                    .beginningMilepost(previousMilepost)
                    .endingMilepost(milepost)
                    .typesOfWork(UpdateProcessorUtils.getTypesOfWork(roadEvent.getTypesOfWorkList()))
                    .restrictions(UpdateProcessorUtils.getRestrictions(baseLayer.getRestrictionsList()));

            if (srzLayer != null) {
                propertiesBuilder = propertiesBuilder
                        .reducedSpeedLimitKph(Double.valueOf(srzLayer.getReducedSpeedLimitKph()));
            }

            if (wpLayer != null) {
                propertiesBuilder = propertiesBuilder
                        .workerPresence(UpdateProcessorUtils.getWorkerPresence(wpLayer.getWorkerPresence()));
            } else {
                propertiesBuilder = propertiesBuilder.workerPresence(UpdateProcessorUtils.getWorkerPresence(null));
            }

            String id = getFeatureId(roadEvent.getId(), milepost).toString();
            // TODO: Update ID based on new sub event, and increment when subEvent is closed
            // an none are new
            LineString geometry = getGeometryBetweenPoints(
                    baseRoadSubEvent.getLineString().getCoordinates().getCoordinatesList(),
                    previousLatLng, currentLatLng);
            WorkZoneRoadEvent properties = propertiesBuilder.build();
            RoadEventCoreDetails coreDetails = properties.getCoreDetails();
            if (coreDetails.getDirection() == null
                    || coreDetails.getDirection() == RoadwayDirection.UNKNOWN
                    || coreDetails.getDirection() == RoadwayDirection.UNDEFINED) {
                List<LatLng> geometryPoints = geometry.getCoordinates().stream()
                        .map(c -> LatLng.newBuilder().setLatitude(c.getLatitude()).setLongitude(c.getLongitude())
                                .build())
                        .toList();
                coreDetails.setDirection(
                        getRoadwayDirectionFromGeometry(geometryPoints, coreDetails.getRoadNames()));
            }
            RoadEventFeature feature = RoadEventFeature.builder()
                    .id(id)
                    .properties(properties)
                    .geometry(geometry)
                    .build();

            // Generate WorkZoneRoadEvent for the current milepost range
            features.add(feature);

            previousMilepost = milepost;
        }

        // Add related road event IDs to each feature
        List<RelatedRoadEvent> relatedRoadEvents = new ArrayList<>();
        for (int i = 0; i < features.size(); i++) {
            RoadEventFeature feature = features.get(i);
            RelatedRoadEventType type = RelatedRoadEventType.NEXT_IN_SEQUENCE;
            if (i == 0) {
                type = RelatedRoadEventType.FIRST_IN_SEQUENCE;
            }
            relatedRoadEvents.add(RelatedRoadEvent.builder().id(feature.getId()).type(type).build());
        }

        for (int i = 0; i < features.size(); i++) {
            RoadEventFeature feature = features.get(i);
            List<RelatedRoadEvent> relatedForFeature = new ArrayList<>(relatedRoadEvents);
            // Remove self from related events
            relatedForFeature.removeIf(rre -> rre.getId().equals(feature.getId()));
            // Set and rely on pass by reference
            feature.getProperties().getCoreDetails().setRelatedRoadEvents(relatedForFeature);
        }

        return features;
    }

    public boolean isMilepostInEndRange(Double milepost, RoadSubEvent rse, boolean isAscending) {
        if (isAscending) {
            return milepost > rse.getBeginningMilepost() && milepost <= rse.getEndingMilepost();
        } else {
            // descending direction, starting milepost larger than ending milepost
            return milepost < rse.getBeginningMilepost() && milepost >= rse.getEndingMilepost();
        }
    }

    public LineString getGeometryBetweenPoints(List<LatLng> allPoints, LatLng startPoint, LatLng endPoint) {
        // Boundary points may come from a different sub event, so match by nearest
        // point
        int startIndex = nearestIndex(allPoints, startPoint);
        int endIndex = nearestIndex(allPoints, endPoint);

        List<LatLng> segmentPoints = new ArrayList<>();
        if (startIndex != -1 && endIndex != -1 && startIndex != endIndex) {
            int from = Math.min(startIndex, endIndex);
            int to = Math.max(startIndex, endIndex);
            segmentPoints.addAll(allPoints.subList(from, to + 1));
            if (startIndex > endIndex) {
                java.util.Collections.reverse(segmentPoints);
            }
        } else {
            log.warn("Could not match segment boundaries to sub event points, using full sub event geometry.");
            segmentPoints.addAll(allPoints);
        }

        return UpdateProcessorUtils.getLineStringFromLatLngs(segmentPoints);
    }

    private int nearestIndex(List<LatLng> points, LatLng target) {
        int best = -1;
        double bestDist = Double.MAX_VALUE;
        for (int i = 0; i < points.size(); i++) {
            double dLat = points.get(i).getLatitude() - target.getLatitude();
            double dLng = points.get(i).getLongitude() - target.getLongitude();
            double dist = dLat * dLat + dLng * dLng;
            if (dist < bestDist) {
                bestDist = dist;
                best = i;
            }
        }
        return best;
    }

    public RoadEventCoreDetails generateRoadEventCoreDetails(RoadEvent roadEvent, RoadSubEvent roadSubEvent) {
        List<String> roadNames = new ArrayList<>(roadSubEvent.getRoadNamesList());
        roadNames.add(roadSubEvent.getRouteId());
        return RoadEventCoreDetails.builder()
                .dataSourceId(this.dataSource.getDataSourceId()) // TODO: map data sources used in feature
                .eventType(EventType.WORK_ZONE)
                .roadNames(roadNames)
                .direction(UpdateProcessorUtils.getRoadwayDirection(roadSubEvent.getDirection()))
                .name(roadEvent.getName())
                .description(roadEvent.getDescription())
                .creationDate(null) // TODO: Lookup creation date
                .updateDate(null) // TODO: Lookup update date
                .build();
    }

    public RoadwayDirection getRoadwayDirectionFromGeometry(List<LatLng> points, List<String> roadNames) {
        // Compute direction of geometry from start to end
        if (points == null || points.size() < 2) {
            return RoadwayDirection.UNKNOWN;
        }
        LatLng start = points.get(0);
        LatLng end = points.get(points.size() - 1);

        double heading = computeHeadingDegrees(start, end);

        // Interstates like "ML80I" or "ML25I": route number ending in 0 runs east/west, 5 north/south
        if (roadNames != null) {
            for (String roadName : roadNames) {
                if (roadName == null) {
                    continue;
                }
                Matcher matcher = INTERSTATE_PATTERN.matcher(roadName.trim());
                if (!matcher.matches()) {
                    continue;
                }
                char lastDigit = matcher.group(1).charAt(matcher.group(1).length() - 1);
                if (lastDigit == '0') {
                    return heading >= 0 && heading < 180 ? RoadwayDirection.EASTBOUND : RoadwayDirection.WESTBOUND;
                } else if (lastDigit == '5') {
                    return heading >= 90 && heading < 270 ? RoadwayDirection.SOUTHBOUND : RoadwayDirection.NORTHBOUND;
                }
            }
        }

        if (heading >= 315 || heading < 45) {
            return RoadwayDirection.NORTHBOUND;
        } else if (heading < 135) {
            return RoadwayDirection.EASTBOUND;
        } else if (heading < 225) {
            return RoadwayDirection.SOUTHBOUND;
        }
        return RoadwayDirection.WESTBOUND;
    }

    // Initial great-circle bearing in degrees [0, 360), clockwise from north
    private double computeHeadingDegrees(LatLng start, LatLng end) {
        double lat1 = Math.toRadians(start.getLatitude());
        double lat2 = Math.toRadians(end.getLatitude());
        double dLng = Math.toRadians(end.getLongitude() - start.getLongitude());
        double y = Math.sin(dLng) * Math.cos(lat2);
        double x = Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1) * Math.cos(lat2) * Math.cos(dLng);
        return (Math.toDegrees(Math.atan2(y, x)) + 360) % 360;
    }

    public FeedInfo.FeedInfoBuilder generateFeedInfo(List<FeedDataSource> dataSources) {
        return FeedInfo.builder()
                .publisher(cwzProperties.getPublisher())
                .version("1.0")
                .license("https://creativecommons.org/publicdomain/zero/1.0/")
                .dataSources(dataSources)
                .updateFrequency(300)
                .contactName(cwzProperties.getContactName())
                .contactEmail(cwzProperties.getContactEmail());
    }

    private String serializeCwz(CwzFeed cwz) {
        try {
            return objectMapper.writeValueAsString(cwz);
        } catch (Exception e) {
            log.error("Error serializing CWZ Feed: {}", e.getMessage());
            return null;
        }
    }

    private UUID getFeatureId(Long roadSubEventId, Double startMilepost) {
        String idString = roadSubEventId + "_" + startMilepost;
        return UUID.nameUUIDFromBytes(idString.getBytes());
    }
}
