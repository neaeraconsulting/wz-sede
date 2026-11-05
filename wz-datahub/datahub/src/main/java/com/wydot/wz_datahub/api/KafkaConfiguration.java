package com.wydot.wz_datahub.api;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.kafka.clients.admin.NewTopic;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.kafka.config.TopicBuilder;
import org.springframework.kafka.core.KafkaAdmin;
import org.springframework.kafka.core.KafkaAdmin.NewTopics;
import org.springframework.stereotype.Component;

import com.wydot.wz_datahub.api.kafka.KafkaTopics;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Data
@Component
@ConfigurationProperties(prefix = "kafka.topics")
public class KafkaConfiguration {
    private final KafkaAdmin admin;
    private boolean autoCreateTopics;
    private int numPartitions;
    private int numReplicas;
    private String cleanupPolicy;
    private int retentionMs;

    public KafkaConfiguration(KafkaAdmin admin) {
        this.admin = admin;
    }

    @Bean(name = "createKafkaTopics")
    public KafkaAdmin.NewTopics createKafkaTopics() {
        log.info("createTopic");
        List<NewTopic> newTopics = new ArrayList<>();

        try {
            if (!autoCreateTopics) {
                log.info("Auto create topics is disabled");
                return null;
            }

            log.info("Creating topics: {}", KafkaTopics.topics);

            List<String> topicNames = new ArrayList<>();
            for (String topicName : KafkaTopics.topics) {
                topicNames.add(topicName);

                Map<String, String> topicConfigs = new HashMap<>();
                topicConfigs.put("cleanup.policy", cleanupPolicy);
                topicConfigs.put("retention.ms", String.valueOf(retentionMs));

                NewTopic newTopic = TopicBuilder
                        .name(topicName)
                        .partitions(numPartitions)
                        .replicas(numReplicas)
                        .configs(topicConfigs)
                        .build();
                newTopics.add(newTopic);
                log.info("New Topic: {}", newTopic);
            }

            // Explicitly create the topics here to prevent error on first run
            admin.initialize();
            admin.createOrModifyTopics(newTopics.toArray(new NewTopic[0]));

            // Check that topics were created
            var topicDescMap = admin.describeTopics(topicNames.toArray(new String[0]));
            for (var entry : topicDescMap.entrySet()) {
                String topicName = entry.getKey();
                var desc = entry.getValue();
                log.info("Created topic {}: {}", topicName, desc);
            }

        } catch (Exception e) {
            log.error("Exception in createKafkaTopics", e);
            throw e;
        }

        return new NewTopics(newTopics.toArray(NewTopic[]::new));

    }
}
