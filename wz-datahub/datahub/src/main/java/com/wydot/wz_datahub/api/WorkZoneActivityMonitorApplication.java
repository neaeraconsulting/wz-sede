package com.wydot.wz_datahub.api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@EnableScheduling
@SpringBootApplication
public class WorkZoneActivityMonitorApplication {

    public static void main(String[] args) {
        SpringApplication.run(WorkZoneActivityMonitorApplication.class, args);
    }

}
