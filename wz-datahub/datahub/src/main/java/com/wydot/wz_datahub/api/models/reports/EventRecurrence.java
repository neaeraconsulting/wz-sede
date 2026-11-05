package com.wydot.wz_datahub.api.models.reports;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

@Data
public class EventRecurrence {
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "H:m", timezone = "America/Denver")
    @JsonProperty("start_time")
    private LocalTime startTime;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "H:m", timezone = "America/Denver")
    @JsonProperty("end_time")
    private LocalTime endTime;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "America/Denver")
    @JsonProperty("start_date")
    private LocalDate startDate;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "America/Denver")
    @JsonProperty("end_date")
    private LocalDate endDate;

    @JsonProperty("days_of_week")
    private List<Integer> daysOfWeek;

    @JsonProperty("exclusion")
    private Boolean exclusion;
}
