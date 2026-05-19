FROM eclipse-temurin:8-jdk
WORKDIR /app
COPY CPUScheduler.java ./
RUN javac CPUScheduler.java
CMD ["sh", "-c", "echo 'CPUScheduler compiled successfully in Docker container'"]
