// package com.wydot.wz_datahub.api.update_processors.field_device;

// import static org.junit.jupiter.api.Assertions.assertFalse;
// import static org.junit.jupiter.api.Assertions.assertTrue;
// import static org.mockito.Mockito.doReturn;
// import static org.mockito.Mockito.mock;
// import static org.mockito.Mockito.spy;
// import static org.mockito.Mockito.when;

// import org.junit.jupiter.api.BeforeEach;
// import org.junit.jupiter.api.Test;

// import com.google.type.LatLng;
// import com.wydot.wz_datahub.api.models.field_devices.FieldDeviceReading;
// import
// com.wydot.wz_datahub.api.models.field_devices.FieldDeviceUpdateCategory;
// import com.wydot.wz_datahub.api.update_processors.UpdateProcessorProperties;

// import wyo.dot.protobuf.FieldDevice;
// import wyo.dot.protobuf.FieldDevice.ArrowBoard;
// import wyo.dot.protobuf.FieldDevice.DynamicMessageSign;
// import wyo.dot.protobuf.FieldDevice.FieldDeviceCoreDetails;
// import wyo.dot.protobuf.FieldDevice.FieldDeviceStatus;
// import wyo.dot.protobuf.FieldDevice.FieldWorker;
// import wyo.dot.protobuf.FieldDevice.FlashingBeacon;
// import wyo.dot.protobuf.FieldDevice.HybridSign;
// import wyo.dot.protobuf.FieldDevice.MobileVehicle;
// import wyo.dot.protobuf.FieldDevice.TrafficSignal;
// import wyo.dot.protobuf.PointGeometry;

// public class FieldDeviceUpdateFilterTest {
// private FieldDeviceUpdateFilter filter;
// private UpdateProcessorProperties properties;

// @BeforeEach
// void setUp() {
// properties = mock(UpdateProcessorProperties.class);
// filter = new FieldDeviceUpdateFilter(properties);
// }

// @Test
// void testhasFieldDeviceChanged_NewReadingIsNull() {
// FieldDeviceReading newReading = null;
// FieldDeviceReading prevReading = mock(FieldDeviceReading.class);

// FieldDeviceUpdateCategory result = filter.hasFieldDeviceChanged(newReading,
// prevReading, null);

// assertFalse(result != null, "If new reading is null, the result should be
// false.");
// }

// @Test
// void testhasFieldDeviceChanged_PrevReadingIsNull() {
// FieldDeviceReading newReading = mock(FieldDeviceReading.class);
// FieldDeviceReading prevReading = null;
// FieldDevice newDevice = mock(FieldDevice.class);

// when(newReading.getDevice()).thenReturn(newDevice);
// FieldDeviceUpdateCategory result = filter.hasFieldDeviceChanged(newReading,
// prevReading, null);

// assert result != null;
// }

// @Test
// void testHasFieldDeviceChanged_DeviceStatusNotOk() {
// FieldDeviceReading newReading = mock(FieldDeviceReading.class);
// FieldDeviceReading prevReading = mock(FieldDeviceReading.class);
// FieldDevice newDevice = mock(FieldDevice.class);
// FieldDevice prevDevice = mock(FieldDevice.class);
// FieldDeviceCoreDetails coreDetails = mock(FieldDeviceCoreDetails.class);

// when(newReading.getDevice()).thenReturn(newDevice);
// when(prevReading.getDevice()).thenReturn(prevDevice);
// when(newDevice.getCoreDetails()).thenReturn(coreDetails);
// when(coreDetails.getDeviceStatus()).thenReturn(FieldDeviceStatus.FIELD_DEVICE_STATUS_WARNING);

// FieldDeviceUpdateCategory result = filter.hasFieldDeviceChanged(newReading,
// prevReading, null);

// assert result == null;
// }

// @Test
// void testCompareDeviceProperties_ArrowBoardChanged() {
// FieldDevice newDevice = mock(FieldDevice.class);
// FieldDevice prevDevice = mock(FieldDevice.class);
// FieldDeviceCoreDetails newCoreDetails = mock(FieldDeviceCoreDetails.class);
// FieldDeviceCoreDetails prevCoreDetails = mock(FieldDeviceCoreDetails.class);
// ArrowBoard newArrowBoard = mock(ArrowBoard.class);
// ArrowBoard prevArrowBoard = mock(ArrowBoard.class);

// when(newDevice.getDeviceCase()).thenReturn(FieldDevice.DeviceCase.ARROW_BOARD);
// when(prevDevice.getDeviceCase()).thenReturn(FieldDevice.DeviceCase.ARROW_BOARD);
// when(newDevice.getCoreDetails()).thenReturn(newCoreDetails);
// when(prevDevice.getCoreDetails()).thenReturn(prevCoreDetails);
// when(newCoreDetails.getIsMoving()).thenReturn(true);
// when(prevCoreDetails.getIsMoving()).thenReturn(true);
// when(newDevice.getArrowBoard()).thenReturn(newArrowBoard);
// when(prevDevice.getArrowBoard()).thenReturn(prevArrowBoard);
// when(newArrowBoard.getPattern()).thenReturn(ArrowBoard.ArrowBoardPattern.ARROW_BOARD_PATTERN_LEFT_ARROW_STATIC);
// when(prevArrowBoard.getPattern())
// .thenReturn(ArrowBoard.ArrowBoardPattern.ARROW_BOARD_PATTERN_RIGHT_ARROW_STATIC);

// boolean result = filter.compareDeviceProperties(newDevice, prevDevice);

// assertTrue(result, "Arrow board pattern change should return true.");
// }

// @Test
// void testCompareDeviceProperties_Camera() {
// FieldDevice newDevice = mock(FieldDevice.class);
// FieldDevice prevDevice = mock(FieldDevice.class);
// FieldDeviceCoreDetails newCoreDetails = mock(FieldDeviceCoreDetails.class);
// FieldDeviceCoreDetails prevCoreDetails = mock(FieldDeviceCoreDetails.class);

// when(newDevice.getDeviceCase()).thenReturn(FieldDevice.DeviceCase.CAMERA);
// when(prevDevice.getDeviceCase()).thenReturn(FieldDevice.DeviceCase.CAMERA);
// when(newDevice.getCoreDetails()).thenReturn(newCoreDetails);
// when(prevDevice.getCoreDetails()).thenReturn(prevCoreDetails);
// when(newCoreDetails.getIsMoving()).thenReturn(true);
// when(prevCoreDetails.getIsMoving()).thenReturn(true);

// boolean result = filter.compareDeviceProperties(newDevice, prevDevice);

// assertFalse(result, "Cameras are not used in field device updates, so it
// should return false.");
// }

// @Test
// void testCompareDeviceProperties_DynamicMessageSignChanged() {
// FieldDevice newDevice = mock(FieldDevice.class);
// FieldDevice prevDevice = mock(FieldDevice.class);
// FieldDeviceCoreDetails newCoreDetails = mock(FieldDeviceCoreDetails.class);
// FieldDeviceCoreDetails prevCoreDetails = mock(FieldDeviceCoreDetails.class);
// DynamicMessageSign newSign = mock(DynamicMessageSign.class);
// DynamicMessageSign prevSign = mock(DynamicMessageSign.class);

// when(newDevice.getDeviceCase()).thenReturn(FieldDevice.DeviceCase.DYNAMIC_MESSAGE_SIGN);
// when(prevDevice.getDeviceCase()).thenReturn(FieldDevice.DeviceCase.DYNAMIC_MESSAGE_SIGN);
// when(newDevice.getCoreDetails()).thenReturn(newCoreDetails);
// when(prevDevice.getCoreDetails()).thenReturn(prevCoreDetails);
// when(newCoreDetails.getIsMoving()).thenReturn(true);
// when(prevCoreDetails.getIsMoving()).thenReturn(true);
// when(newDevice.getDynamicMessageSign()).thenReturn(newSign);
// when(prevDevice.getDynamicMessageSign()).thenReturn(prevSign);
// when(newSign.getMessageMultiString()).thenReturn("New Message");
// when(prevSign.getMessageMultiString()).thenReturn("Old Message");

// boolean result = filter.compareDeviceProperties(newDevice, prevDevice);

// assertTrue(result, "Dynamic message sign change should return true.");
// }

// @Test
// void testCompareDeviceProperties_FlashingBeaconChanged() {
// FieldDevice newDevice = mock(FieldDevice.class);
// FieldDevice prevDevice = mock(FieldDevice.class);
// FieldDeviceCoreDetails newCoreDetails = mock(FieldDeviceCoreDetails.class);
// FieldDeviceCoreDetails prevCoreDetails = mock(FieldDeviceCoreDetails.class);
// FlashingBeacon newBeacon = mock(FlashingBeacon.class);
// FlashingBeacon prevBeacon = mock(FlashingBeacon.class);

// when(newDevice.getDeviceCase()).thenReturn(FieldDevice.DeviceCase.FLASHING_BEACON);
// when(prevDevice.getDeviceCase()).thenReturn(FieldDevice.DeviceCase.FLASHING_BEACON);
// when(newDevice.getCoreDetails()).thenReturn(newCoreDetails);
// when(prevDevice.getCoreDetails()).thenReturn(prevCoreDetails);
// when(newCoreDetails.getIsMoving()).thenReturn(true);
// when(prevCoreDetails.getIsMoving()).thenReturn(true);
// when(newDevice.getFlashingBeacon()).thenReturn(newBeacon);
// when(prevDevice.getFlashingBeacon()).thenReturn(prevBeacon);
// when(newBeacon.getFunction())
// .thenReturn(FlashingBeacon.FlashingBeaconFunction.FLASHING_BEACON_FUNCTION_QUEUE_WARNING);
// when(prevBeacon.getFunction())
// .thenReturn(FlashingBeacon.FlashingBeaconFunction.FLASHING_BEACON_FUNCTION_REDUCED_SPEED);

// boolean result = filter.compareDeviceProperties(newDevice, prevDevice);

// assertTrue(result, "Flashing beacon function change should return true.");
// }

// @Test
// void testCompareDeviceProperties_HybridSignChanged() {
// FieldDevice newDevice = mock(FieldDevice.class);
// FieldDevice prevDevice = mock(FieldDevice.class);
// FieldDeviceCoreDetails newCoreDetails = mock(FieldDeviceCoreDetails.class);
// FieldDeviceCoreDetails prevCoreDetails = mock(FieldDeviceCoreDetails.class);
// HybridSign newSign = mock(HybridSign.class);
// HybridSign prevSign = mock(HybridSign.class);

// when(newDevice.getDeviceCase()).thenReturn(FieldDevice.DeviceCase.HYBRID_SIGN);
// when(prevDevice.getDeviceCase()).thenReturn(FieldDevice.DeviceCase.HYBRID_SIGN);
// when(newDevice.getCoreDetails()).thenReturn(newCoreDetails);
// when(prevDevice.getCoreDetails()).thenReturn(prevCoreDetails);
// when(newCoreDetails.getIsMoving()).thenReturn(true);
// when(prevCoreDetails.getIsMoving()).thenReturn(true);
// when(newDevice.getHybridSign()).thenReturn(newSign);
// when(prevDevice.getHybridSign()).thenReturn(prevSign);
// when(newSign.getDynamicMessageFunction()).thenReturn(
// HybridSign.HybridSignDynamicMessageFunction.HYBRID_SIGN_DYNAMIC_MESSAGE_FUNCTION_SPEED_LIMIT);
// when(prevSign.getDynamicMessageFunction())
// .thenReturn(HybridSign.HybridSignDynamicMessageFunction.HYBRID_SIGN_DYNAMIC_MESSAGE_FUNCTION_OTHER);

// boolean result = filter.compareDeviceProperties(newDevice, prevDevice);

// assertTrue(result, "Hybrid sign dynamic message function change should return
// true.");
// }

// @Test
// void testCompareDeviceProperties_TrafficSignalChanged() {
// FieldDevice newDevice = mock(FieldDevice.class);
// FieldDevice prevDevice = mock(FieldDevice.class);
// FieldDeviceCoreDetails newCoreDetails = mock(FieldDeviceCoreDetails.class);
// FieldDeviceCoreDetails prevCoreDetails = mock(FieldDeviceCoreDetails.class);
// TrafficSignal newSignal = mock(TrafficSignal.class);
// TrafficSignal prevSignal = mock(TrafficSignal.class);

// when(newDevice.getDeviceCase()).thenReturn(FieldDevice.DeviceCase.TRAFFIC_SIGNAL);
// when(prevDevice.getDeviceCase()).thenReturn(FieldDevice.DeviceCase.TRAFFIC_SIGNAL);
// when(newDevice.getCoreDetails()).thenReturn(newCoreDetails);
// when(prevDevice.getCoreDetails()).thenReturn(prevCoreDetails);
// when(newCoreDetails.getIsMoving()).thenReturn(true);
// when(prevCoreDetails.getIsMoving()).thenReturn(true);
// when(newDevice.getTrafficSignal()).thenReturn(newSignal);
// when(prevDevice.getTrafficSignal()).thenReturn(prevSignal);
// when(newSignal.getMode()).thenReturn(TrafficSignal.TrafficSignalMode.TRAFFIC_SIGNAL_MODE_FULLY_ACTUATED);
// when(prevSignal.getMode()).thenReturn(TrafficSignal.TrafficSignalMode.TRAFFIC_SIGNAL_MODE_FLASHING_RED);

// boolean result = filter.compareDeviceProperties(newDevice, prevDevice);

// assertTrue(result, "Traffic signal mode change should return true.");
// }

// @Test
// void testCompareDeviceProperties_MobileVehicleChanged() {
// FieldDevice newDevice = mock(FieldDevice.class);
// FieldDevice prevDevice = mock(FieldDevice.class);
// FieldDeviceCoreDetails newCoreDetails = mock(FieldDeviceCoreDetails.class);
// FieldDeviceCoreDetails prevCoreDetails = mock(FieldDeviceCoreDetails.class);
// MobileVehicle newVehicle = mock(MobileVehicle.class);
// MobileVehicle prevVehicle = mock(MobileVehicle.class);

// when(newDevice.getDeviceCase()).thenReturn(FieldDevice.DeviceCase.MOBILE_VEHICLE);
// when(prevDevice.getDeviceCase()).thenReturn(FieldDevice.DeviceCase.MOBILE_VEHICLE);
// when(newDevice.getCoreDetails()).thenReturn(newCoreDetails);
// when(prevDevice.getCoreDetails()).thenReturn(prevCoreDetails);
// when(newCoreDetails.getIsMoving()).thenReturn(true);
// when(prevCoreDetails.getIsMoving()).thenReturn(true);
// when(newDevice.getMobileVehicle()).thenReturn(newVehicle);
// when(prevDevice.getMobileVehicle()).thenReturn(prevVehicle);
// when(newVehicle.getOperationType()).thenReturn(MobileVehicle.VehicleOperationType.VEHICLE_OPERATION_STRIPING);
// when(prevVehicle.getOperationType()).thenReturn(MobileVehicle.VehicleOperationType.VEHICLE_OPERATION_PLOWING);

// boolean result = filter.compareDeviceProperties(newDevice, prevDevice);

// assertTrue(result, "Mobile vehicle operation type change should return
// true.");
// }

// @Test
// void testCompareDeviceProperties_FieldWorkerChanged() {
// FieldDevice newDevice = mock(FieldDevice.class);
// FieldDevice prevDevice = mock(FieldDevice.class);
// FieldDeviceCoreDetails newCoreDetails = mock(FieldDeviceCoreDetails.class);
// FieldDeviceCoreDetails prevCoreDetails = mock(FieldDeviceCoreDetails.class);
// FieldWorker newWorker = mock(FieldWorker.class);
// FieldWorker prevWorker = mock(FieldWorker.class);

// when(newDevice.getDeviceCase()).thenReturn(FieldDevice.DeviceCase.FIELD_WORKER);
// when(prevDevice.getDeviceCase()).thenReturn(FieldDevice.DeviceCase.FIELD_WORKER);
// when(newDevice.getCoreDetails()).thenReturn(newCoreDetails);
// when(prevDevice.getCoreDetails()).thenReturn(prevCoreDetails);
// when(newCoreDetails.getIsMoving()).thenReturn(true);
// when(prevCoreDetails.getIsMoving()).thenReturn(true);
// when(newDevice.getFieldWorker()).thenReturn(newWorker);
// when(prevDevice.getFieldWorker()).thenReturn(prevWorker);
// when(newWorker.getOperationType()).thenReturn(FieldWorker.OperationType.OPERATION_TYPE_FLAGGER);
// when(prevWorker.getOperationType()).thenReturn(FieldWorker.OperationType.OPERATION_TYPE_WORKER);

// boolean result = filter.compareDeviceProperties(newDevice, prevDevice);

// assertTrue(result, "Field worker operation type change should return true.");
// }

// @Test
// void testHasFieldDeviceChanged_PositionChanged_identical() {
// FieldDeviceReading newReading = mock(FieldDeviceReading.class);
// FieldDeviceReading prevReading = mock(FieldDeviceReading.class);
// FieldDevice newDevice = mock(FieldDevice.class);
// FieldDevice prevDevice = mock(FieldDevice.class);
// FieldDeviceCoreDetails newCoreDetails = mock(FieldDeviceCoreDetails.class);
// FieldDeviceCoreDetails prevCoreDetails = mock(FieldDeviceCoreDetails.class);
// PointGeometry newGeometry = mock(PointGeometry.class);
// PointGeometry prevGeometry = mock(PointGeometry.class);
// FieldDeviceUpdateFilter filterSpy = spy(filter);

// // Distance: 0m
// LatLng newCoordinates =
// LatLng.newBuilder().setLatitude(41.0).setLongitude(-105.0).build();
// LatLng prevCoordinates =
// LatLng.newBuilder().setLatitude(41.0).setLongitude(-105.0).build();

// when(newReading.getDevice()).thenReturn(newDevice);
// when(prevReading.getDevice()).thenReturn(prevDevice);
// when(newDevice.getCoreDetails()).thenReturn(newCoreDetails);
// when(prevDevice.getCoreDetails()).thenReturn(prevCoreDetails);
// when(newCoreDetails.getDeviceStatus()).thenReturn(FieldDeviceStatus.FIELD_DEVICE_STATUS_OK);
// when(newDevice.getGeometry()).thenReturn(newGeometry);
// when(prevDevice.getGeometry()).thenReturn(prevGeometry);
// when(newGeometry.getCoordinates()).thenReturn(newCoordinates);
// when(prevGeometry.getCoordinates()).thenReturn(prevCoordinates);
// doReturn(false).when(filterSpy).compareDeviceProperties(newDevice,
// prevDevice);
// when(properties.getPositionFilterRadiusMeters(newDevice)).thenReturn(1.0); //
// 1,000 km

// FieldDeviceUpdateCategory result =
// filterSpy.hasFieldDeviceChanged(newReading, prevReading, null);
// assert result == null;
// }

// @Test
// void testHasFieldDeviceChanged_PositionChanged_MultipleDistances() {
// FieldDeviceReading newReading = mock(FieldDeviceReading.class);
// FieldDeviceReading prevReading = mock(FieldDeviceReading.class);
// FieldDevice newDevice = mock(FieldDevice.class);
// FieldDevice prevDevice = mock(FieldDevice.class);
// FieldDeviceCoreDetails newCoreDetails = mock(FieldDeviceCoreDetails.class);
// FieldDeviceCoreDetails prevCoreDetails = mock(FieldDeviceCoreDetails.class);
// PointGeometry newGeometry = mock(PointGeometry.class);
// PointGeometry prevGeometry = mock(PointGeometry.class);
// FieldDeviceUpdateFilter filterSpy = spy(filter);

// // Distance: 323m
// LatLng newCoordinates =
// LatLng.newBuilder().setLatitude(41.09606281823744).setLongitude(-105.19016773455911)
// .build();
// LatLng prevCoordinates =
// LatLng.newBuilder().setLatitude(41.096260464164544).setLongitude(-105.18632698846335)
// .build();

// when(newReading.getDevice()).thenReturn(newDevice);
// when(prevReading.getDevice()).thenReturn(prevDevice);
// when(newDevice.getCoreDetails()).thenReturn(newCoreDetails);
// when(prevDevice.getCoreDetails()).thenReturn(prevCoreDetails);
// when(newCoreDetails.getDeviceStatus()).thenReturn(FieldDeviceStatus.FIELD_DEVICE_STATUS_OK);
// when(newDevice.getGeometry()).thenReturn(newGeometry);
// when(prevDevice.getGeometry()).thenReturn(prevGeometry);
// when(newGeometry.getCoordinates()).thenReturn(newCoordinates);
// when(prevGeometry.getCoordinates()).thenReturn(prevCoordinates);
// doReturn(false).when(filterSpy).compareDeviceProperties(newDevice,
// prevDevice);

// when(properties.getPositionFilterRadiusForDevice(newDevice)).thenReturn(1000.0);//
// 1000m > 323, should return
// // true
// FieldDeviceUpdateCategory result =
// filterSpy.hasFieldDeviceChanged(newReading, prevReading, null);
// assert result == null;

// when(properties.getPositionFilterRadiusForDevice(newDevice)).thenReturn(100.0);
// // 100m < 323, should return
// // false
// result = filterSpy.hasFieldDeviceChanged(newReading, prevReading, null);
// assert result != null;
// }
// }
