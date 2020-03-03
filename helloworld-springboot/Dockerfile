FROM openjdk:8-jre-alpine

LABEL maintainer="borja.rosco.a@gmail.com"

COPY target/helloworld-springboot-*.jar springboot.jar

CMD ["java", "-jar", "/springboot.jar"]

EXPOSE 8080