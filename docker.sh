#!/bin/sh
docker build -t spring-dev . -f Dockerfile  --target development

#show detail when build
docker build -t spring-dev . -f Dockerfile  --target development  --progress=plain
docker build -t spring-dev . -f Dockerfile  --target development  --progress=plain --no-cache

#run
docker run --publish 8086:8086 spring-dev
#docker run --publish 8086:8086  --publish 8000:8000  spring-dev #remote debug via 8000
