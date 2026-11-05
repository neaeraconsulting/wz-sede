package com.wydot.message_generator.kafka;

import java.util.Map;

import org.apache.kafka.common.errors.SerializationException;
import org.apache.kafka.common.serialization.Deserializer;

import com.google.protobuf.Message;

public class ProtobufKafkaDeserializer<T extends Message> implements Deserializer<T> {
    private Class<T> clazz;

    // Public no-argument constructor required by Kafka
    public ProtobufKafkaDeserializer() {
    }

    public ProtobufKafkaDeserializer(Class<T> clazz) {
        this.clazz = clazz;
    }

    @Override
    public T deserialize(String topic, byte[] data) {
        if (data == null) {
            return null;
        }
        if (clazz == null) {
            throw new SerializationException("ProtobufDeserializer requires a class type for deserialization");
        }
        try {
            return clazz.cast(clazz.getMethod("parseFrom", byte[].class).invoke(null, data));
        } catch (Exception e) {
            throw new SerializationException("Error deserializing Protobuf message", e);
        }
    }

    @Override
    public void configure(Map<String, ?> configs, boolean isKey) {
        // Retrieve the class type from the configuration if provided
        String className = (String) configs.get("specific.protobuf.value.type");
        if (className != null) {
            try {
                this.clazz = (Class<T>) Class.forName(className);
            } catch (ClassNotFoundException e) {
                throw new SerializationException("Error configuring ProtobufDeserializer: class not found", e);
            }
        }
    }

    @Override
    public void close() {
        // No resources to close
    }
}