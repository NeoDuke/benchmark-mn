FROM oracle/graalvm-ce:19.3.1-java8 as graalvm
#FROM oracle/graalvm-ce:19.3.1-java11 as graalvm # For JDK 11
RUN gu install native-image

COPY . /home/app/helloworld-micronaut-native
WORKDIR /home/app/helloworld-micronaut-native

RUN native-image --no-server --static -cp target/helloworld-micronaut-native-*.jar

FROM scratch
EXPOSE 8080
COPY --from=graalvm /home/app/helloworld-micronaut-native/helloworld-micronaut-native /app/helloworld-micronaut-native
ENTRYPOINT ["/app/helloworld-micronaut-native", "-Djava.library.path=/app"]
