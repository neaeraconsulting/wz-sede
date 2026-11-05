package com.wydot.wz_datahub.api.models.wz.wzdx;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

/**
 * Class representing the type of work being performed in the work zone.
 * 
 * @see <a href=
 *      "https://github.com/usdot-jpo-ode/wzdx/blob/main/spec-content/objects/TypeOfWork.md">TypeOfWork</a>
 */
@Data
public class TypeOfWork {
    @JsonProperty("type_name")
    private WorkTypeName typeName;
    @JsonProperty("is_architectural_change")
    private boolean isArchitecturalChange;
}