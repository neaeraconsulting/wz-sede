
package com.wydot.wz_datahub.api.accessors.raw;

import com.wydot.wz_datahub.api.models.raw_data.RawDataWrapper;

public interface RawDataRepository {
    void insert(RawDataWrapper object);
}