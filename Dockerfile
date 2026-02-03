# Etapa 1: Construir con Maven y JDK 17 (LTS ampliamente compatible)
FROM maven:3.9-eclipse-temurin-17-alpine AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Etapa 2: Imagen de ejecución ligera con JRE 17
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copiar el JAR desde la etapa de construcción
COPY --from=builder /app/target/*.jar app.jar

# Exponer puerto (Render usará la variable PORT)
EXPOSE 8080

# Variables de entorno para optimizar memoria
ENV JAVA_OPTS="-Xmx256m -Xms128m -XX:+UseSerialGC"

# Comando de inicio
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]