package com.wydot.message_generator.utilities;

import java.time.Instant;
import java.util.function.Consumer;

import org.bson.Document;

import com.google.protobuf.Timestamp;

public class ProtobufUtils {
    public static Long millisFromTimestamp(Timestamp timestamp) {
        if (timestamp == null) {
            return null;
        }
        return timestamp.getSeconds() * 1000 + timestamp.getNanos() / 1_000_000;
    }

    public static Instant instantFromTimestamp(Timestamp timestamp) {
        if (timestamp == null) {
            return null;
        }
        return Instant.ofEpochMilli(millisFromTimestamp(timestamp));
    }

    public static Timestamp timestampFromMillis(Long millis) {
        if (millis == null) {
            return null;
        }
        long seconds = millis / 1000;
        int nanos = (int) ((millis % 1000) * 1_000_000);
        return Timestamp.newBuilder().setSeconds(seconds).setNanos(nanos).build();
    }

    public static Timestamp timestampFromInstant(Instant instant) {
        if (instant == null) {
            return null;
        }
        return timestampFromMillis(instant.toEpochMilli());
    }

    public static <T> void setIfNotNull(T value, Consumer<T> setter) {
        if (value != null)
            setter.accept(value);
    }

    public static <T> void setIfPresent(Document source, String key, Class<T> type, Consumer<T> setter) {
        if (source.containsKey(key)) {
            T value = source.get(key, type);
            if (value != null) {
                setter.accept(value);
            }
        }
    }

    public static Long generateRequestId(Object id) {
        String timestamp = String.valueOf(System.currentTimeMillis());
        String hashCode = String.valueOf(Math.abs(id.hashCode())); // Ensure positive hash code
        String concatenated = timestamp + hashCode;

        // Safely parse the concatenated string into a long
        return Long.parseLong(concatenated.substring(0, Math.min(concatenated.length(), 19))); // Ensure it fits in a
                                                                                               // long
    }
}
