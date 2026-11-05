package com.wydot.wz_datahub.api;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.LinkedHashMap;
import java.util.function.Consumer;

import org.bson.Document;

import com.google.protobuf.Timestamp;
import com.google.type.Date;
import com.google.type.TimeOfDay;

import wyo.dot.protobuf.EventRecurrence;

public class ProtobufUtils {

    private static final ZoneId WYOMING_TIME_ZONE = ZoneId.of("America/Denver");

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

    public static Instant instantFromRecurrenceStart(EventRecurrence recurrence) {
        if (!recurrence.hasStartDate()) {
            return null;
        }
        com.google.type.Date date = recurrence.getStartDate();

        // Create LocalDate from protobuf Date
        LocalDate localDate = LocalDate.of(date.getYear(), date.getMonth(), date.getDay());

        // Convert to Instant at start of day in Wyoming time (Mountain Time)
        ZonedDateTime wyomingDateTime = localDate.atStartOfDay(WYOMING_TIME_ZONE);

        // If time is provided, adjust the Instant to the specified time
        if (recurrence.hasStartTime()) {
            com.google.type.TimeOfDay time = recurrence.getStartTime();
            wyomingDateTime = wyomingDateTime.withHour(time.getHours()).withMinute(time.getMinutes())
                    .withSecond(time.getSeconds());
        }

        return wyomingDateTime.toInstant();
    }

    public static Instant instantFromRecurrenceEnd(EventRecurrence recurrence) {
        if (!recurrence.hasEndDate()) {
            return null;
        }
        com.google.type.Date date = recurrence.getEndDate();

        // Create LocalDate from protobuf Date
        LocalDate localDate = LocalDate.of(date.getYear(), date.getMonth(), date.getDay());

        // Convert to Instant at start of day in Wyoming time (Mountain Time)
        ZonedDateTime wyomingDateTime = localDate.atStartOfDay(WYOMING_TIME_ZONE);

        // If time is provided, adjust the Instant to the specified time
        if (recurrence.hasEndTime()) {
            com.google.type.TimeOfDay time = recurrence.getEndTime();
            wyomingDateTime = wyomingDateTime.withHour(time.getHours()).withMinute(time.getMinutes())
                    .withSecond(time.getSeconds());
        }

        return wyomingDateTime.toInstant();
    }

    public static com.google.type.Date instantToDate(Instant instant) {
        if (instant == null) {
            return null;
        }

        // Convert Instant to LocalDate in Wyoming time
        LocalDate localDate = instant.atZone(WYOMING_TIME_ZONE).toLocalDate();

        return com.google.type.Date.newBuilder()
                .setYear(localDate.getYear())
                .setMonth(localDate.getMonthValue())
                .setDay(localDate.getDayOfMonth())
                .build();
    }

    public static com.google.type.TimeOfDay instantToTimeOfDay(Instant instant) {
        if (instant == null) {
            return null;
        }

        ZonedDateTime wyomingDateTime = instant.atZone(WYOMING_TIME_ZONE);
        return com.google.type.TimeOfDay.newBuilder()
                .setHours(wyomingDateTime.getHour())
                .setMinutes(wyomingDateTime.getMinute())
                .setSeconds(wyomingDateTime.getSecond())
                .build();
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

    @SuppressWarnings("unchecked")
    public static EventRecurrence mapHashMapToEventRecurrence(LinkedHashMap<String, Object> map) {
        EventRecurrence.Builder builder = EventRecurrence.newBuilder();

        if (map.containsKey("startTime")) {
            LinkedHashMap<String, Object> startTimeMap = (LinkedHashMap<String, Object>) map.get("startTime");
            TimeOfDay.Builder todBuilder = TimeOfDay.newBuilder();
            if (startTimeMap.get("hours") != null) {
                todBuilder.setHours((Integer) startTimeMap.get("hours"));
            }
            if (startTimeMap.get("minutes") != null) {
                todBuilder.setMinutes((Integer) startTimeMap.get("minutes"));
            }
            if (startTimeMap.get("seconds") != null) {
                todBuilder.setSeconds((Integer) startTimeMap.get("seconds"));
            }
            builder.setStartTime(todBuilder.build());
        }
        if (map.containsKey("endTime")) {
            LinkedHashMap<String, Object> endTimeMap = (LinkedHashMap<String, Object>) map.get("endTime");
            TimeOfDay.Builder todBuilder = TimeOfDay.newBuilder();
            if (endTimeMap.get("hours") != null) {
                todBuilder.setHours((Integer) endTimeMap.get("hours"));
            }
            if (endTimeMap.get("minutes") != null) {
                todBuilder.setMinutes((Integer) endTimeMap.get("minutes"));
            }
            if (endTimeMap.get("seconds") != null) {
                todBuilder.setSeconds((Integer) endTimeMap.get("seconds"));
            }
            builder.setEndTime(todBuilder.build());
        }
        if (map.containsKey("startDate")) {
            LinkedHashMap<String, Object> startDateMap = (LinkedHashMap<String, Object>) map.get("startDate");
            Date.Builder dateBuilder = Date.newBuilder();
            if (startDateMap.get("year") != null) {
                dateBuilder.setYear((Integer) startDateMap.get("year"));
            }
            if (startDateMap.get("month") != null) {
                dateBuilder.setMonth((Integer) startDateMap.get("month"));
            }
            if (startDateMap.get("day") != null) {
                dateBuilder.setDay((Integer) startDateMap.get("day"));
            }
            builder.setStartDate(dateBuilder.build());
        }
        if (map.containsKey("endDate")) {
            LinkedHashMap<String, Object> endDateMap = (LinkedHashMap<String, Object>) map.get("endDate");
            Date.Builder dateBuilder = Date.newBuilder();
            if (endDateMap.get("year") != null) {
                dateBuilder.setYear((Integer) endDateMap.get("year"));
            }
            if (endDateMap.get("month") != null) {
                dateBuilder.setMonth((Integer) endDateMap.get("month"));
            }
            if (endDateMap.get("day") != null) {
                dateBuilder.setDay((Integer) endDateMap.get("day"));
            }
            builder.setEndDate(dateBuilder.build());
        }
        if (map.containsKey("monday")) {
            builder.setMonday((Boolean) map.get("monday"));
        }
        if (map.containsKey("tuesday")) {
            builder.setTuesday((Boolean) map.get("tuesday"));
        }
        if (map.containsKey("wednesday")) {
            builder.setWednesday((Boolean) map.get("wednesday"));
        }
        if (map.containsKey("thursday")) {
            builder.setThursday((Boolean) map.get("thursday"));
        }
        if (map.containsKey("friday")) {
            builder.setFriday((Boolean) map.get("friday"));
        }
        if (map.containsKey("saturday")) {
            builder.setSaturday((Boolean) map.get("saturday"));
        }
        if (map.containsKey("sunday")) {
            builder.setSunday((Boolean) map.get("sunday"));
        }

        return builder.build();

    }
}
