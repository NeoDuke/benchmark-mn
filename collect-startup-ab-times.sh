#!/usr/bin/env bash

source my-functions.sh


echo
echo "==> START : $(date)"

echo
echo "----------------------"
echo "MICRONAUT-JVM"
echo "----------------------"

docker run -d --rm --name helloworld-micronaut-jvm -p 9080:8080 neoduke/helloworld-micronaut-jvm:1.0.0

wait_for_container_log "helloworld-micronaut-jvm" "Startup completed in"
micronaut_jvm_startup_time=$(extract_startup_time_from_log "$wait_for_container_log_matched_row" "{print substr(\$9,0,length(\$9)-1)}")
micronaut_jvm_initial_memory_consumption=$(get_container_memory_consumption "helloworld-micronaut-jvm")

run_command "ab -c 10 -n 7500 http://localhost:9080/hello"
micronaut_jvm_ab_testing_time=$run_command_exec_time

micronaut_jvm_final_memory_consumption=$(get_container_memory_consumption "helloworld-micronaut-jvm")

docker stop helloworld-micronaut-jvm

echo
echo "-------------------------"
echo "MICRONAUT-GRAALVM"
echo "-------------------------"

docker run -d --rm --name helloworld-micronaut-graalvm -p 9081:8080 neoduke/helloworld-micronaut-graalvm:1.0.0

wait_for_container_log "helloworld-micronaut-graalvm" "Startup completed in"
micronaut_graalvm_startup_time=$(extract_startup_time_from_log "$wait_for_container_log_matched_row" "{print substr(\$10,0,length(\$10)-1)}")
micronaut_graalvm_initial_memory_consumption=$(get_container_memory_consumption "helloworld-micronaut-graalvm")

run_command "ab -c 10 -n 7500 http://localhost:9081/hello"
micronaut_graalvm_ab_testing_time=$run_command_exec_time

micronaut_graalvm_final_memory_consumption=$(get_container_memory_consumption "helloworld-micronaut-graalvm")

docker stop helloworld-micronaut-graalvm

echo
echo "------------------------"
echo "SPRINGBOOT-JVM"
echo "------------------------"

docker run -d --rm --name helloworld-springboot-jvm -p 9082:8080 neoduke/helloworld-springboot-jvm:1.0.0

wait_for_container_log "helloworld-springboot-jvm" "Started DemoApplication in"
startup_time_sec=$(extract_startup_time_from_log "$wait_for_container_log_matched_row" "{print substr(\$13,0,length(\$13))}")
springboot_jvm_startup_time="$(convert_seconds_to_millis $startup_time_sec)ms"

springboot_jvm_initial_memory_consumption=$(get_container_memory_consumption "helloworld-springboot-jvm")

run_command "ab -c 10 -n 7500 http://localhost:9082/hello"
springboot_jvm_ab_testing_time=$run_command_exec_time

springboot_jvm_final_memory_consumption=$(get_container_memory_consumption "helloworld-springboot-jvm")

docker stop helloworld-springboot-jvm

printf "\n"
printf "%30s | %12s | %26s | %15s | %24s |\n" "Application" "Startup Time" "Initial Memory Consumption" "Ab Testing Time" "Final Memory Consumption"
printf "%30s + %12s + %26s + %15s + %24s |\n" "------------------------------" "------------" "--------------------------" "---------------" "------------------------"
printf "%30s | %12s | %26s | %15s | %24s |\n" "micronaut-jvm" ${micronaut_jvm_startup_time} ${micronaut_jvm_initial_memory_consumption} ${micronaut_jvm_ab_testing_time} ${micronaut_jvm_final_memory_consumption}
printf "%30s | %12s | %26s | %15s | %24s |\n" "micronaut-graalvm" ${micronaut_graalvm_startup_time} ${micronaut_graalvm_initial_memory_consumption} ${micronaut_graalvm_ab_testing_time} ${micronaut_graalvm_final_memory_consumption}
printf "%30s | %12s | %26s | %15s | %24s |\n" "springboot-jvm" ${springboot_jvm_startup_time} ${springboot_jvm_initial_memory_consumption} ${springboot_jvm_ab_testing_time} ${springboot_jvm_final_memory_consumption}
printf "%30s + %12s + %26s + %15s + %24s |\n" ".............................." "..........." ".........................." "..............." "........................"

echo
echo "==> FINISH : $(date)"
echo