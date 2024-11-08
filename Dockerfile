# Use the official Maven image for build stage.
FROM maven:3.8.1-openjdk-11 AS build

# Set the working directory.
WORKDIR /app

# Copy the pom.xml file and download dependencies.
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the source code and build the application.
COPY src ./src
RUN mvn package -DskipTests

# Use a lightweight OpenJDK image for runtime stage.
FROM openjdk:11

# Set the working directory.
WORKDIR /app

# Copy the JAR file from the build stage.
COPY --from=build /app/target/*.jar app.jar

# Expose the port your app runs on.
EXPOSE 8000

# Define the command to run the application.
ENTRYPOINT ["java", "-jar", "app.jar"]
