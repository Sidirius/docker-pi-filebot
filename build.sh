#!/bin/bash
docker stop filebot_test
docker rm filebot_test
docker build --rm -t sidirius/docker-pi-filebot .
