#!/bin/sh
docker build -t spring-dev . -f Dockerfile  --target development

#run
docker run --publish 8086:8086 spring-dev
