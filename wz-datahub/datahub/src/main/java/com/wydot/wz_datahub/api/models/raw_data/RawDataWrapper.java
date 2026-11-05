package com.wydot.wz_datahub.api.models.raw_data;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class RawDataWrapper {
    private Long timestamp;
    private RawDataType type;
    private Object data;
}
