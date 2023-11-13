#!/bin/sh
docker build -t spring-dev . -f Dockerfile  --target development

#run
docker run --publish 8086:8086 spring-dev
#docker run --publish 8086:8086  --publish 8000:8000  spring-dev #remote debug via 8000
