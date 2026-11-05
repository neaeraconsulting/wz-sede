# Stage 1: Build the application and submodule
FROM maven:3.9.4-eclipse-temurin-21 AS build

# Install a specific version of protoc (Protobuf compiler)
RUN apt-get update && apt-get install -y wget unzip && \
    wget https://github.com/protocolbuffers/protobuf/releases/download/v25.5/protoc-25.5-linux-x86_64.zip && \
    unzip protoc-25.5-linux-x86_64.zip -d /usr/local && \
    rm protoc-25.5-linux-x86_64.zip

# Set the working directory for the build
WORKDIR /app

# Copy the Maven project files
COPY pom.xml . 
COPY ./wz-datahub-schemas ./wz-datahub-schemas
COPY src ./src

# Build the wz-datahub-schemas submodule
RUN mvn -f wz-datahub-schemas/pom.xml clean install -DskipTests

# Build the main application
RUN mvn clean package -DskipTests

# Stage 2: Create the runtime image
FROM eclipse-temurin:21-jdk-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the built JAR files from the build stage
COPY --from=build /app/target/work-zone-data-hub-0.0.1-SNAPSHOT.jar app.jar

# Expose the port your Spring Boot application runs on
EXPOSE 8081

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]