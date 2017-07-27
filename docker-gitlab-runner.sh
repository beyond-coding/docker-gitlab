#!/bin/bash

# Checking that the domain was provided

: ${GITLAB_HOST:?"Set the environment variable GITLAB_HOST before running the script. (example: export GITLAB_HOST=registry.example.com"}
: ${1:?"Provide the runner registration token from gitlab as first parameter"}

TOKEN_FROM_GITLAB=$1
HEADER="Docker gitlab-runner -"

echo "$HEADER in process..."

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker run -d --name gitlab-runner --restart always --privileged \
  -v $DIR/gitlab-runner/config:/etc/gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  gitlab/gitlab-runner:latest

echo "Recommended executor type: docker | default docker image: alpine:latest"

docker exec -it gitlab-runner gitlab-ci-multi-runner register -n \
  --url https://$GITLAB_HOST:443 \
  --registration-token $TOKEN_FROM_GITLAB \
  --executor docker \
  --description "Runner 1" \
  --docker-image "docker:latest" \
  --docker-volumes /var/run/docker.sock:/var/run/docker.sock

echo "$HEADER perform: 'sudo vim $DIR/gitlab-runner/config/config.toml' and set 'privileged' to 'true' and make sure the docker.sock volumes are included = ['/cache', '/var/run.sh/docker.sock:/var/run.sh/docker.sock']."

echo "$HEADER complete."
