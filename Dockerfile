# Etapa 1: Construir con Maven
FROM maven:3.8.4-openjdk-21-slim AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Etapa 2: Ejecutar con JRE más ligero
FROM openjdk:21-jre-slim
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar

# Exponer puerto (Render manejará la variable PORT)
EXPOSE 8080

# Variables de entorno
ENV JAVA_OPTS="-Xmx256m -Xms128m"

# Comando de inicio
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]