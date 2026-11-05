package com.wydot.wz_datahub.api;

import java.util.ArrayList;
import java.util.List;

import org.springframework.core.convert.converter.Converter;
import org.springframework.data.mongodb.config.AbstractMongoClientConfiguration;
import org.springframework.data.mongodb.core.convert.MongoCustomConversions;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;

import com.mongodb.ConnectionString;
import com.mongodb.MongoClientSettings;
import com.wydot.wz_datahub.api.models.serialization.DocumentToConAdminRoadEventUpdateConverter;
import com.wydot.wz_datahub.api.models.serialization.DocumentToDataHubRoadEventUpdateConverter;
import com.wydot.wz_datahub.api.models.serialization.DocumentToFieldDeviceConverter;
import com.wydot.wz_datahub.api.models.serialization.DocumentToLatLngConverter;
import com.wydot.wz_datahub.api.models.serialization.DocumentToProjectConverter;
import com.wydot.wz_datahub.api.models.serialization.DocumentToRoadEventConverter;
import com.wydot.wz_datahub.api.models.serialization.DocumentToRoadSubEventConverter;
import com.wydot.wz_datahub.api.models.serialization.DocumentToTypeOfWorkConverter;
import com.wydot.wz_datahub.api.mongo.ProtobufMongoSerializer;

import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Slf4j
@Configuration
@EnableMongoRepositories
public class MongoConfig extends AbstractMongoClientConfiguration {

    private List<Converter<?, ?>> converters = new ArrayList<Converter<?, ?>>();

    @Value("${spring.data.mongodb.database}")
    private String db;

    @Value("${spring.data.mongodb.host}")
    private String host;

    @Value("${spring.data.mongodb.port}")
    private String port;

    @Value("${spring.data.mongodb.username}")
    private String username;

    @Value("${spring.data.mongodb.password}")
    private String password;

    @Value("${spring.data.mongodb.authenticationDatabase}")
    private String authenticationDatabase;

    @Value("${spring.data.mongodb.uri}")
    private String overrideURI;

    @Override
    protected String getDatabaseName() {
        return db;
    }

    @Override
    public void configureClientSettings(MongoClientSettings.Builder builder) {

        String uri = "";

        if (overrideURI != null && !overrideURI.isEmpty() && !overrideURI.equals("null")) {
            uri = overrideURI;
        } else {
            uri = "mongodb://" + username + ":" + password + "@" + host + ":" + port + "/" + db + "?authSource="
                    + authenticationDatabase;
        }

        log.info("MongoDB Connection String: {}", uri);
        builder.applyConnectionString(new ConnectionString(uri));
    }

    @Override
    public MongoCustomConversions customConversions() {
        converters.add(new ProtobufMongoSerializer<>());
        converters.add(new DocumentToConAdminRoadEventUpdateConverter());
        converters.add(new DocumentToDataHubRoadEventUpdateConverter());
        converters.add(new DocumentToFieldDeviceConverter());
        converters.add(new DocumentToLatLngConverter());
        converters.add(new DocumentToProjectConverter());
        converters.add(new DocumentToRoadEventConverter());
        converters.add(new DocumentToRoadSubEventConverter());
        converters.add(new DocumentToTypeOfWorkConverter());

        return new MongoCustomConversions(converters);
    }
}