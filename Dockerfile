# Use a lightweight OpenJDK base image
FROM eclipse-temurin:21-jdk-alpine as builder

# Set work directory
WORKDIR /app

# Copy Gradle wrapper and build files
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .
COPY src src

# Grant execution permission to Gradle wrapper
RUN chmod +x ./gradlew

# Build the Spring Boot application JAR
RUN ./gradlew bootJar

# ------------------
# Final minimal image
# ------------------
FROM eclipse-temurin:21-jre-alpine

# Set work directory
WORKDIR /app

# Copy the built JAR from the builder stage
COPY --from=builder /app/build/libs/*.jar app.jar

# Expose the port (default Spring Boot port)
EXPOSE 8080

# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
