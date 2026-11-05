package com.wydot.wz_datahub.api.kafka;

import lombok.extern.slf4j.Slf4j;
import wyo.dot.protobuf.conadmin.ConAdminFieldDeviceUpdate;
import wyo.dot.protobuf.conadmin.ConAdminProjectUpdate;
import wyo.dot.protobuf.conadmin.ConAdminRoadEventApproval;
import wyo.dot.protobuf.conadmin.ConAdminRoadEventUpdate;

import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.common.serialization.Deserializer;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.kafka.config.ConcurrentKafkaListenerContainerFactory;
import org.springframework.kafka.core.ConsumerFactory;
import org.springframework.kafka.core.DefaultKafkaConsumerFactory;
import org.springframework.kafka.support.serializer.JsonDeserializer;

import com.wydot.wz_datahub.api.models.raw_vehicle_location.RawVehicleLocation;

import io.confluent.kafka.serializers.protobuf.KafkaProtobufDeserializerConfig;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

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
    ConsumerFactory<String, ConAdminRoadEventApproval> conAdminRoadEventApprovalConsumerFactory() {
        return consumerFactory(ConAdminRoadEventApproval.class);
    }

    @Bean
    ConcurrentKafkaListenerContainerFactory<String, ConAdminRoadEventApproval> conAdminRoadEventApprovalKafkaListenerContainerFactory() {
        ConcurrentKafkaListenerContainerFactory<String, ConAdminRoadEventApproval> factory = new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(conAdminRoadEventApprovalConsumerFactory());
        return factory;
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
    ConsumerFactory<String, ConAdminProjectUpdate> conAdminProjectUpdateConsumerFactory() {
        return consumerFactory(ConAdminProjectUpdate.class);
    }

    @Bean
    ConcurrentKafkaListenerContainerFactory<String, ConAdminProjectUpdate> conAdminProjectUpdateKafkaListenerContainerFactory() {
        ConcurrentKafkaListenerContainerFactory<String, ConAdminProjectUpdate> factory = new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(conAdminProjectUpdateConsumerFactory());
        return factory;
    }

    @Bean
    ConsumerFactory<String, ConAdminFieldDeviceUpdate> conAdminFieldDeviceUpdateConsumerFactory() {
        return consumerFactory(ConAdminFieldDeviceUpdate.class);
    }

    @Bean
    ConcurrentKafkaListenerContainerFactory<String, ConAdminFieldDeviceUpdate> conAdminFieldDeviceUpdateKafkaListenerContainerFactory() {
        ConcurrentKafkaListenerContainerFactory<String, ConAdminFieldDeviceUpdate> factory = new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(conAdminFieldDeviceUpdateConsumerFactory());
        return factory;
    }

    private <TKey, TValue> DefaultKafkaConsumerFactory<TKey, TValue> consumerFactory(Class<TValue> valueClass) {
        Map<String, Object> configProps = new HashMap<>();
        configProps.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        configProps.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);
        configProps.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, ProtobufKafkaDeserializer.class);
        configProps.put(KafkaProtobufDeserializerConfig.SPECIFIC_PROTOBUF_VALUE_TYPE,
                ConAdminRoadEventUpdate.class.getName());
        configProps.put("specific.protobuf.value.type", valueClass.getName());
        configProps.put("use.latest.version", false); // Disable Schema Registry usage
        configProps.put("auto.register.schemas", false); // Disable Schema Registry usage
        return new DefaultKafkaConsumerFactory<>(configProps);
    }

    @Bean
    DefaultKafkaConsumerFactory<String, RawVehicleLocation> rawVehicleLocationConsumerFactory() {
        return consumerFactory(ListenerIds.RAW_VEHICLE_LOCATION,
                new StringDeserializer(),
                new JsonDeserializer<>(RawVehicleLocation.class));
    }

    @Bean
    ConcurrentKafkaListenerContainerFactory<String, RawVehicleLocation> rawVehicleLocationListenerContainerFactory() {
        ConcurrentKafkaListenerContainerFactory<String, RawVehicleLocation> factory = new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(rawVehicleLocationConsumerFactory());
        return factory;
    }

    private <TKey, TValue> DefaultKafkaConsumerFactory<TKey, TValue> consumerFactory(
            String id, Deserializer<TKey> keyDeserializer, Deserializer<TValue> valueDeserializer) {
        Map<String, Object> props = commonProps(id);
        props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, keyDeserializer);
        props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, valueDeserializer);
        return new DefaultKafkaConsumerFactory<TKey, TValue>(props,
                keyDeserializer,
                valueDeserializer);
    }

    private Map<String, Object> commonProps(final String id) {
        Map<String, Object> props = new HashMap<>();

        props.put(ConsumerConfig.CLIENT_ID_CONFIG, id);

        // Make the consumer group id be unique to the instance to prevent consumers
        // forming into groups
        // if running more than one instance
        String groupIdSuffix;
        try {
            groupIdSuffix = InetAddress.getLocalHost().getHostName();
        } catch (UnknownHostException e) {
            log.warn("Unable to find host IP address, using random group id");
            groupIdSuffix = UUID.randomUUID().toString();
        }
        final String groupId = id + "_" + groupIdSuffix;
        props.put(ConsumerConfig.GROUP_ID_CONFIG, groupId);
        log.info("Consumer group ID = {}", groupId);

        props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "latest");
        props.put(ConsumerConfig.AUTO_COMMIT_INTERVAL_MS_CONFIG, 100);
        return props;
    }
}
