#!/bin/sh

SECONDS=0

docker build -t neoduke/helloworld-springboot-jvm:1.0.0 .

duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
