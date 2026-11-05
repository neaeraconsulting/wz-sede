package com.wydot.wz_datahub.api.models.wz.wzdx;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

/**
 * Class describing <a href=
 * "https://github.com/openmobilityfoundation/curb-data-specification/tree/main/curbs#curb-zone">curb
 * zones<a> that are impacted by a work zone
 * 
 * @see <a href=
 *      "https://github.com/usdot-jpo-ode/wzdx/blob/main/spec-content/objects/CdsCurbZonesReference.md">CdsCurbZonesReference</a>
 */
@Data
public class CdsCurbZonesReference {
    @JsonProperty("cds_curb_zone_ids")
    private List<String> cdsCurbZoneIds;
    @JsonProperty("cds_curbs_api_url")
    private String cdsCurbsApiUrl;
}
