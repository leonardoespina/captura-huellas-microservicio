# Etapa 1: Construir con Maven y JDK 21 (coherente con pom.xml)
FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Etapa 2: Imagen de ejecución con JRE 21
FROM eclipse-temurin:21-jre
WORKDIR /app

# Copiar el JAR desde la etapa de construcción
COPY --from=builder /app/target/*.jar app.jar

# Exponer puerto (Render usará la variable PORT)
EXPOSE 8080

# Variables de entorno para optimizar memoria en Render Free
ENV JAVA_OPTS="-Xmx256m -Xms128m -XX:+UseSerialGC -XX:MaxRAM=512m"

# Comando de inicio
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]