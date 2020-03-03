#!/usr/bin/env bash

source my-functions.sh

docker rmi \
  neoduke/helloworld-micronaut-jvm:1.0.0 \
  neoduke/helloworld-micronaut-native:1.0.0 \
  neoduke/helloworld-springboot-jvm:1.0.0




echo
echo "==> START : $(date)"

echo
echo "----------------------"
echo "MICRONAUT-JVM"
echo "----------------------"

cd helloworld-micronaut

package_jar_build_image \
  "./mvnw clean" \
  "./mvnw package" \
  "target/helloworld-micronaut-0.1.jar" \
  "./docker-build.sh" \
  "neoduke/helloworld-micronaut-jvm:1.0.0"
micronaut_jvm_packaging_time=$package_jar_build_image_packaging_time
micronaut_jvm_jar_size=$package_jar_build_image_jar_size
micronaut_jvm_building_time=$package_jar_build_image_building_time
micronaut_jvm_docker_image_size=$package_jar_build_image_docker_image_size

echo
echo "------------------------"
echo "MICRONAUT-GRAALVM"
echo "------------------------"

cd ../helloworld-micronaut-graalvm

package_jar_build_image \
  "./mvnw clean" \
  "./mvnw package" \
  "target/helloworld-micronaut-native-0.1.jar" \
  "./docker-build.sh" \
  "neoduke/helloworld-micronaut-native:1.0.0"
micronaut_graalvm_packaging_time=$package_jar_build_image_packaging_time
micronaut_graalvm_jar_size=$package_jar_build_image_jar_size
micronaut_graalvm_building_time=$package_jar_build_image_building_time
micronaut_graalvm_docker_image_size=$package_jar_build_image_docker_image_size

echo
echo "---------------------"
echo "SPRINGBOOT-JVM"
echo "---------------------"

cd ../helloworld-springboot

package_jar_build_image \
  "./mvnw clean" \
  "./mvnw package" \
  "target/helloworld-springboot-0.0.1-SNAPSHOT.jar" \
  "./docker-build.sh" \
  "neoduke/helloworld-springboot-jvm:1.0.0"
springboot_packaging_time=$package_jar_build_image_packaging_time
springboot_jar_size=$package_jar_build_image_jar_size
springboot_building_time=$package_jar_build_image_building_time
springboot_docker_image_size=$package_jar_build_image_docker_image_size


printf "\n"
printf "%30s | %14s | %16s | %17s | %17s |\n" "Application" "Packaging Time" "Jar Size (bytes)" "Docker Build Time" "Docker Image Size"
printf "%30s + %14s + %16s + %17s + %17s |\n" "------------------------------" "--------------" "----------------" "-----------------" "-----------------"
printf "%30s | %14s | %16s | %17s | %17s |\n" "micronaut_jvm" ${micronaut_jvm_packaging_time} ${micronaut_jvm_jar_size} ${micronaut_jvm_building_time} ${micronaut_jvm_docker_image_size}
printf "%30s | %14s | %16s | %17s | %17s |\n" "micronaut_graalvm" ${micronaut_graalvm_packaging_time} ${micronaut_graalvm_jar_size} ${micronaut_graalvm_building_time} ${micronaut_graalvm_docker_image_size}
printf "%30s | %14s | %16s | %17s | %17s |\n" "springboot-jvm" ${springboot_packaging_time} ${springboot_jar_size} ${springboot_building_time} ${springboot_docker_image_size}
printf "%30s + %14s + %16s + %17s + %17s |\n" ".............................." ".............." "................" "................." "................."
p
echo
echo "==> FINISH : $(date)"
echo
