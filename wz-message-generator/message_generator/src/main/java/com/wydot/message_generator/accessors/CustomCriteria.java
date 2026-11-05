package com.wydot.message_generator.accessors;

import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.lang.NonNull;
import org.springframework.lang.Nullable;

import java.time.Instant;
import java.util.Date;

public class CustomCriteria extends Criteria {

    /**
     * Build a query criteria object based on a time window
     *
     * @param fieldName        the db field to apply criteria to
     * @param startEpochMillis the nullable start time of the window, in
     *                         milliseconds since epoch
     * @param endEpochMillis   the nullable end time of the window, in milliseconds
     *                         since epoch
     * @return the criteria object to use for querying
     */
    public CustomCriteria withinTimeWindow(
            @NonNull String fieldName,
            @Nullable Long startEpochMillis,
            @Nullable Long endEpochMillis) {
        if (startEpochMillis != null && endEpochMillis != null) {
            this.and(fieldName)
                    .gte(formatDate(startEpochMillis))
                    .lte(formatDate(endEpochMillis));
            return this;
        } else if (startEpochMillis != null) {
            this.and(fieldName).gte(formatDate(startEpochMillis));
            return this;
        } else if (endEpochMillis != null) {
            this.and(fieldName).lte(formatDate(endEpochMillis));
            return this;
        }
        return this;
    }

    /**
     * Build a query criteria object based on a time window
     *
     * @param fieldNameStart the db field to apply criteria to
     * @param fieldNameEnd   the db field to apply criteria to
     * @param timestamp      the time of the window, in milliseconds since epoch
     * @return the criteria object to use for querying
     */
    public CustomCriteria timestampWithinWindow(
            @NonNull String fieldNameStart,
            @NonNull String fieldNameEnd,
            @Nullable Instant timestamp) {
        if (timestamp == null) {
            return this;
        }
        // Date date = Date.from(timestamp);
        this.andOperator(
                Criteria.where(fieldNameStart).lte(timestamp),
                new Criteria().orOperator(
                        Criteria.where(fieldNameEnd).gte(timestamp),
                        Criteria.where(fieldNameEnd).is(null) // Handle null end dates
                ));
        return this;
    }

    /**
     * Build a query criteria object based on a set of potentially overlapping time
     * windows.
     * Date fields may be null. If the start value is null, the event is assumed to
     * be inactive.
     * If the start field is non-null and the end field is null, the event is
     * assumed to be active
     *
     * @param startFieldName   the db field of the start of the time window
     * @param endFieldName     the db field of the end of the time window
     * @param startEpochMillis the nullable start time of the window, in
     *                         milliseconds since epoch
     * @param endEpochMillis   the nullable end time of the window, in milliseconds
     *                         since epoch
     * @return the criteria object to use for querying
     */
    public CustomCriteria rangeWithinTimeWindow(
            @NonNull String startFieldName,
            @NonNull String endFieldName,
            @Nullable Long startEpochMillis,
            @Nullable Long endEpochMillis) {
        if (startEpochMillis != null && endEpochMillis != null) {
            this.andOperator(
                    Criteria.where(startFieldName).lte(formatDate(endEpochMillis)),
                    new Criteria().orOperator(
                            Criteria.where(endFieldName).gte(formatDate(startEpochMillis)),
                            Criteria.where(endFieldName).is(null) // Handle null end dates
                    ));
        } else if (startEpochMillis != null) {
            this.andOperator(
                    Criteria.where(startFieldName).lte(formatDate(startEpochMillis)),
                    Criteria.where(endFieldName).is(null) // Handle null end dates
            );
        } else if (endEpochMillis != null) {
            this.andOperator(
                    Criteria.where(endFieldName).gte(formatDate(endEpochMillis)),
                    Criteria.where(startFieldName).is(null) // Handle null start dates
            );
        }
        return this;
    }

    /**
     * Format a date object for use in a query
     *
     * @param epochMillis the time of the window, in milliseconds since epoch
     * @return the criteria object to use for querying
     */
    private Object formatDate(Long epochMillis) {
        return Date.from(Instant.ofEpochMilli(epochMillis));
    }

    /**
     * Build a query criteria object based on a time window
     *
     * @param <T>       the type of the value to compare against
     * @param fieldName the db datetime field to apply criteria to
     * @param value     the value to compare against
     * @return the criteria object to use for querying
     */
    public <T> CustomCriteria whereOptional(@NonNull String fieldName,
            @Nullable T value) {
        if (value != null) {
            this.and(fieldName).is(value);
        }
        return this;
    }
}
