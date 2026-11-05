package com.wydot.wz_datahub.api.models.recordings;

import java.util.ArrayList;
import java.util.List;

import com.google.type.LatLng;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class RecordingSlice {
    RecordingMarking markingState;
    List<LatLng> points;

    public RecordingSlice clone() {
        List<LatLng> clonedPoints = new ArrayList<>(points); // Deep copy points
        return new RecordingSlice(markingState.clone(), clonedPoints);
    }

    // constructor to accept RecordingMarking and List<RecordingPoint>
    public static RecordingSlice fromRecordingPoints(RecordingMarking markingState,
            List<RecordingPoint> recordingPoints) {
        RecordingSlice slice = new RecordingSlice();
        slice.markingState = markingState;
        slice.points = recordingPoints.stream().map((point) -> LatLng.newBuilder()
                .setLatitude(point.getLatitude())
                .setLongitude(point.getLongitude())
                .build()).toList();
        return slice;
    }
}
