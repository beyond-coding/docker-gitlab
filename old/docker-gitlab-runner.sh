#!/bin/bash

# Checking that the domain was provided

: ${GITLAB_HOST:?"Set the environment variable GITLAB_HOST before running the script. (example: export GITLAB_HOST=registry.example.com"}
: ${1:?"Provide the runner registration token from gitlab as first parameter"}

TOKEN_FROM_GITLAB=$1
HEADER="Docker gitlab-runner -"

REGISTRY_PORT=5000

echo "$HEADER in process..."

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# docker run.sh --privileged --name some-docker -d docker:dind --insecure-registry 10.10.2.111:5000

#  --insecure-registry $GITLAB_HOST:$REGISTRY_PORT \
docker run -d --name gitlab-runner --restart always --privileged \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $DIR/certs:/certs \
  -v $DIR/gitlab-runner/config:/etc/gitlab-runner \
  gitlab/gitlab-runner:latest

REGISTRATION_FOLDER=/etc/docker/certs.d/$GITLAB_HOST:$REGISTRY_PORT
sudo mkdir -p $REGISTRATION_FOLDER
sudo cp certs/registry-auth.crt $REGISTRATION_FOLDER/ca.crt

echo "Recommended executor type: docker | default docker image: alpine:latest"

# docker exec -it gitlab-runner gitlab-runner register

docker exec -it gitlab-runner gitlab-ci-multi-runner register -n \
  --url http://$GITLAB_HOST:10080 \
  --registration-token $TOKEN_FROM_GITLAB \
  --executor docker \
  --description "Runner 1" \
  --docker-image "docker:latest" \
  --docker-volumes /var/run/docker.sock:/var/run/docker.sock

echo "$HEADER perform: 's' and set privileged to true and make sure the docker.sock volumes are included = ['/cache', '/var/run.sh/docker.sock:/var/run.sh/docker.sock']."

echo "$HEADER complete."
