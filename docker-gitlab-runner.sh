#!/bin/bash

HEADER="Docker gitlab-runner -"

echo "$HEADER in process..."

docker run -d --name gitlab-runner --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ./gitlab-runner/config:/etc/gitlab-runner \
  gitlab/gitlab-runner:latest

docker exec -it gitlab-runner gitlab-runner register

echo "$HEADER complete."
