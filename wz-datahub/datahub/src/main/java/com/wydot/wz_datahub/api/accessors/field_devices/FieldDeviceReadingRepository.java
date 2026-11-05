
package com.wydot.wz_datahub.api.accessors.field_devices;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.wydot.wz_datahub.api.models.field_devices.FieldDeviceReading;

public interface FieldDeviceReadingRepository {
    long count(String id, Long generatedStartTime, Long generatedEndTime);

    Page<FieldDeviceReading> find(String id, Long generatedStartTime, Long generatedEndTime, Pageable pageable);

    FieldDeviceReading findLatest(String id, Long generatedStartTime, Long generatedEndTime);

    List<FieldDeviceReading> findUnique(Long generatedStartTime, Long generatedEndTime);

    List<FieldDeviceReading> findUniqueNonAvl(Long generatedStartTime, Long generatedEndTime);

    void insert(FieldDeviceReading device);
}