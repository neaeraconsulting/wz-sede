package com.wydot.message_generator.models.wz.cwz;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Builder;
import lombok.Data;

/**
 * Class representing the type of work being performed in the work zone.
 * 
 * @see <a href=
 *      "https://github.com/usdot-jpo-ode/wzdx/blob/main/spec-content/objects/TypeOfWork.md">TypeOfWork</a>
 */
@Data
@Builder
public class TypeOfWork {
    @JsonProperty("type_name")
    private WorkTypeName typeName;
    @JsonProperty("is_architectural_change")
    private Boolean isArchitecturalChange;
}