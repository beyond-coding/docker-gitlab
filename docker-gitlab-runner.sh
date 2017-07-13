#!/bin/bash

HEADER="Docker gitlab-runner -"

echo "$HEADER in process..."

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "$DIR"

docker run -d --name gitlab-runner --restart always --privileged \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $DIR/gitlab-runner/config:/etc/gitlab-runner \
  gitlab/gitlab-runner:latest

echo "Recommended executor type: docker | default docker image: alpine:latest"

docker exec -it gitlab-runner gitlab-runner register

echo "$HEADER perform: sudo vim gitlab-runner/config/config.toml and set privileged to true."

echo "$HEADER complete."
