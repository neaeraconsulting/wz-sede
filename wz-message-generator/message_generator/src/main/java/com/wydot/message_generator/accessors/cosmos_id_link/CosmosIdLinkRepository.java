
package com.wydot.message_generator.accessors.cosmos_id_link;

import java.util.List;

import com.wydot.message_generator.models.sdx.CosmosIdLink;

public interface CosmosIdLinkRepository {
    List<CosmosIdLink> findAll();

    CosmosIdLink findOne(String cosmosId, Long roadEventId);

    void insert(CosmosIdLink item);

    void delete(String cosmosId);
}