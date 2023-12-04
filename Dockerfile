# syntax=docker/dockerfile:1

FROM maven:3.8.4-openjdk-17 as base
WORKDIR /app
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN mvn dependency:resolve
#COPY src ./src
RUN --mount=type=bind,source=src,target=src \
    ls -al

FROM base as test
CMD ["mvn", "test"]

FROM base as development
CMD ["mvn", "spring-boot:run", "-Dspring-boot.run.profiles=developer", "-Dspring-boot.run.jvmArguments='-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8000'"]

FROM base as build
RUN mvn  package

FROM eclipse-temurin:17-jre-jammy as production
EXPOSE 8086
COPY --from=build /app/target/demo-spring-boot-*.jar /demo-spring-boot.jar
CMD ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/demo-spring-boot.jar"]