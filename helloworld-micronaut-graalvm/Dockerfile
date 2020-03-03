FROM oracle/graalvm-ce:19.3.1-java8 as graalvm
# For JDK 11
#FROM oracle/graalvm-ce:19.3.1-java11 as graalvm
RUN gu install native-image

COPY . /home/app/helloworld-micronaut-graalvm
WORKDIR /home/app/helloworld-micronaut-graalvm

RUN native-image --no-server -cp target/helloworld-micronaut-graalvm-*.jar

FROM frolvlad/alpine-glibc
RUN apk update && apk add libstdc++
EXPOSE 8080
COPY --from=graalvm /home/app/helloworld-micronaut-graalvm/helloworld-micronaut-graalvm /app/helloworld-micronaut-graalvm
ENTRYPOINT ["/app/helloworld-micronaut-graalvm"]
