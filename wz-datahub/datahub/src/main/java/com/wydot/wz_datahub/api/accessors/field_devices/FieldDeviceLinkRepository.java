
package com.wydot.wz_datahub.api.accessors.field_devices;

import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.wydot.wz_datahub.api.models.field_devices.FieldDeviceManufacturer;
import com.wydot.wz_datahub.api.models.raw_data.RawDataType;
import com.wydot.wz_datahub.api.models.field_devices.FieldDeviceLink;

public interface FieldDeviceLinkRepository {
    long count(String deviceId, Long projectId, Long roadEventId, Long generatedStartTime, Long generatedEndTime);

    Page<FieldDeviceLink> find(String deviceId, Long projectId, Long roadEventId, Long generatedStartTime,
            Long generatedEndTime, Pageable pageable);

    Page<FieldDeviceLink> findNonAvl(String deviceId, Long projectId, Long roadEventId, Long generatedStartTime,
            Long generatedEndTime, Pageable pageable);

    FieldDeviceLink findOne(String deviceId);

    List<FieldDeviceLink> findByDeviceSource(RawDataType source);

    void update(String deviceId, FieldDeviceLink device);

    void delete(String deviceId);

    /**
     * Generate a deterministic device ID UUID based on the device ID and
     * manufacturer
     *
     * @param deviceId     the device ID
     * @param manufacturer the field device manufacturer
     * @return a device ID as a string UUID
     */
    public static String getDeterministicDeviceId(String deviceId, FieldDeviceManufacturer manufacturer) {
        return UUID.nameUUIDFromBytes((manufacturer.getUniqueId().toString() + deviceId.toString()).getBytes())
                .toString();
    }
}