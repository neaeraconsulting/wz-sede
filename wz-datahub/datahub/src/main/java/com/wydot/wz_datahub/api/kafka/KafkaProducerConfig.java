package com.wydot.wz_datahub.api.kafka;

import java.util.HashMap;
import java.util.Map;

import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.common.serialization.StringSerializer;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.core.DefaultKafkaProducerFactory;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.core.ProducerFactory;

import wyo.dot.protobuf.CreateRoadEvent;
import wyo.dot.protobuf.DataHubFieldDeviceUpdate;
import wyo.dot.protobuf.DataHubRoadEventUpdate;
import wyo.dot.protobuf.conadmin.ConAdminRoadEventUpdate;

@Configuration
public class KafkaProducerConfig {

    @Value("${spring.kafka.bootstrap-servers}")
    private String bootstrapServers;

    @Bean
    ProducerFactory<String, DataHubFieldDeviceUpdate> dataHubFieldDeviceUpdateProducerFactory() {
        return producerFactory();
    }

    @Bean
    KafkaTemplate<String, DataHubFieldDeviceUpdate> dataHubFieldDeviceUpdateKafkaTemplate() {
        return new KafkaTemplate<>(dataHubFieldDeviceUpdateProducerFactory());
    }

    @Bean
    ProducerFactory<String, DataHubRoadEventUpdate> dataHubRoadEventUpdateProducerFactory() {
        return producerFactory();
    }

    @Bean
    KafkaTemplate<String, DataHubRoadEventUpdate> dataHubRoadEventUpdateKafkaTemplate() {
        return new KafkaTemplate<>(dataHubRoadEventUpdateProducerFactory());
    }

    @Bean
    ProducerFactory<String, CreateRoadEvent> createRoadEventProducerFactory() {
        return producerFactory();
    }

    @Bean
    KafkaTemplate<String, CreateRoadEvent> createRoadEventKafkaTemplate() {
        return new KafkaTemplate<>(createRoadEventProducerFactory());
    }

    @Bean
    ProducerFactory<String, ConAdminRoadEventUpdate> conAdminRoadEventUpdateProducerFactory() {
        return producerFactory();
    }

    @Bean
    KafkaTemplate<String, ConAdminRoadEventUpdate> conAdminRoadEventUpdateKafkaTemplate() {
        return new KafkaTemplate<>(conAdminRoadEventUpdateProducerFactory());
    }

    private <TKey, TValue> DefaultKafkaProducerFactory<TKey, TValue> producerFactory() {
        Map<String, Object> configProps = new HashMap<>();
        configProps.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        configProps.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
        configProps.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, ProtobufKafkaSerializer.class);
        configProps.put("use.latest.version", false); // Disable Schema Registry usage
        configProps.put("auto.register.schemas", false); // Disable Schema Registry usage
        return new DefaultKafkaProducerFactory<>(configProps);
    }
}