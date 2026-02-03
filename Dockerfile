# Etapa 1: Construir la aplicación
FROM maven:3.8.4-openjdk-11-slim AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Etapa 2: Imagen de ejecución ligera
FROM openjdk:11-jre-slim
WORKDIR /app

# Copiar el JAR desde la etapa de construcción
COPY --from=builder /app/target/*.jar app.jar

# Exponer puerto (Render usará la variable PORT)
EXPOSE 8080

# Variables de entorno por defecto
ENV JAVA_OPTS="-Xmx256m"

# Comando de inicio (importante: usa exec form)
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]