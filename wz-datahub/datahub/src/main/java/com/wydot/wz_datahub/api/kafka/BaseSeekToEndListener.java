package com.wydot.wz_datahub.api.kafka;

import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.common.TopicPartition;
import org.springframework.kafka.listener.AbstractConsumerSeekAware;

import java.util.Map;

/**
 * Base class for Kafka listeners that seek to the last offset before consuming
 * when starting up.
 * See <a href="https://docs.spring.io/spring-kafka/reference/kafka/seek.html">
 * Spring Kafka: Seeking to a specific offset</a>
 */
@Slf4j
public class BaseSeekToEndListener extends AbstractConsumerSeekAware {

    public BaseSeekToEndListener() {
    }

    @Override
    public void onPartitionsAssigned(Map<TopicPartition, Long> assignments, ConsumerSeekCallback callback) {
        log.info("Seek to end for TopicPartitions {}", assignments.keySet());
        callback.seekToEnd(assignments.keySet());
        super.onPartitionsAssigned(assignments, callback);
    }

}
