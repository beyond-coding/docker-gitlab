#!/bin/bash

# Checking that the domain was provided

: ${GITLAB_HOST:?"Set the environment variable GITLAB_HOST before running the script. (example: export GITLAB_HOST=registry.example.com"}

HEADER="Docker gitlab-runner -"

REGISTRY_PORT=5000

echo "$HEADER in process..."

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "$DIR"

# docker run --privileged --name some-docker -d docker:dind --insecure-registry 10.10.2.111:5000

docker run -d --name gitlab-runner --restart always --privileged \
  --insecure-registry $GITLAB_HOST:$REGISTRY_PORT \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $DIR/gitlab-runner/config:/etc/gitlab-runner \
  gitlab/gitlab-runner:latest

sudo cp certs/registry-auth.crt /etc/docker/certs.d/$GITLAB_HOST:$REGISTRY_PORT/ca.crt

echo "Recommended executor type: docker | default docker image: alpine:latest"

docker exec -it gitlab-runner gitlab-runner register

echo "$HEADER perform: 'sudo vim gitlab-runner/config/config.toml' and set privileged to true."

echo "$HEADER perform: 'docker exec -it gitlab-runner vi /etc/gitlab-runner/config.toml' and add the docker.sock volumes = ["/cache", "/var/run/docker.sock:/var/run/docker.sock"]"

echo "$HEADER complete."
