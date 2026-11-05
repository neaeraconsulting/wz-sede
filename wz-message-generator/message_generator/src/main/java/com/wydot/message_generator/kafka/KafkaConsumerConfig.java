package com.wydot.message_generator.kafka;

import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.CreateRoadEvent;
import wyo.dot.protobuf.conadmin.ConAdminRoadEventUpdate;

import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.kafka.config.ConcurrentKafkaListenerContainerFactory;
import org.springframework.kafka.core.ConsumerFactory;
import org.springframework.kafka.core.DefaultKafkaConsumerFactory;

import io.confluent.kafka.serializers.protobuf.KafkaProtobufDeserializerConfig;

import java.util.HashMap;
import java.util.Map;

// Ref. https://github.com/eugenp/tutorials/blob/master/spring-kafka-3/src/main/java/com/baeldung/spring/kafka/startstopconsumer/KafkaConsumerConfig.java
@EnableKafka
@Configuration
@Slf4j
public class KafkaConsumerConfig {

    @Value("${spring.kafka.bootstrap-servers}")
    private String bootstrapServers;

    public KafkaConsumerConfig() {
    }

    @Bean
    ConsumerFactory<String, ConAdminRoadEventUpdate> conAdminRoadEventUpdateConsumerFactory() {
        return consumerFactory(ConAdminRoadEventUpdate.class);
    }

    @Bean
    ConcurrentKafkaListenerContainerFactory<String, ConAdminRoadEventUpdate> conAdminRoadEventUpdateKafkaListenerContainerFactory() {
        ConcurrentKafkaListenerContainerFactory<String, ConAdminRoadEventUpdate> factory = new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(conAdminRoadEventUpdateConsumerFactory());
        return factory;
    }

    @Bean
    ConsumerFactory<String, CreateRoadEvent> createRoadEventConsumerFactory() {
        return consumerFactory(CreateRoadEvent.class);
    }

    @Bean
    ConcurrentKafkaListenerContainerFactory<String, CreateRoadEvent> createRoadEventKafkaListenerContainerFactory() {
        ConcurrentKafkaListenerContainerFactory<String, CreateRoadEvent> factory = new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(createRoadEventConsumerFactory());
        return factory;
    }

    private <TKey, TValue> DefaultKafkaConsumerFactory<TKey, TValue> consumerFactory(Class<TValue> valueClass) {
        Map<String, Object> configProps = new HashMap<>();
        configProps.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        configProps.put(ConsumerConfig.GROUP_ID_CONFIG, "message-generator-group");
        configProps.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");
        configProps.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, true);
        configProps.put(ConsumerConfig.AUTO_COMMIT_INTERVAL_MS_CONFIG, "1000");
        configProps.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);
        configProps.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, ProtobufKafkaDeserializer.class);
        configProps.put(KafkaProtobufDeserializerConfig.SPECIFIC_PROTOBUF_VALUE_TYPE,
                ConAdminRoadEventUpdate.class.getName());
        configProps.put("specific.protobuf.value.type", valueClass.getName());
        configProps.put("use.latest.version", false); // Disable Schema Registry usage
        configProps.put("auto.register.schemas", false); // Disable Schema Registry usage
        return new DefaultKafkaConsumerFactory<>(configProps);
    }
}
