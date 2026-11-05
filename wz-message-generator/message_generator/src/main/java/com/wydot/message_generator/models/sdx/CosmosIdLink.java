package com.wydot.message_generator.models.sdx;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class CosmosIdLink {
    private String cosmosId;
    private Long roadEventId;
}
