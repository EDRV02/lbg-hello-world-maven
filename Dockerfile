# Stage 1: Build the application
FROM maven:3.8.1-openjdk-17 AS build
 
# Set the working directory
WORKDIR /app
 
# Copy the project files
COPY pom.xml .
COPY src ./src
 
# Build the Maven project
RUN mvn clean package
 
# Stage 2: Run the application
FROM openjdk:17-slim
 
# Set the working directory
WORKDIR /app
 
# Copy the JAR file from the build stage to a consistent name
COPY --from=build /app/target/*.jar app.jar
 
# Expose the port if needed (optional, depending on your app)
EXPOSE 8080
 
# Command to run the application
CMD ["java", "-jar", "app.jar"]