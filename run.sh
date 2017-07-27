#!/bin/bash

# Checking that the domain was provided

#: ${GITLAB_HOST:?"Set the environment variable GITLAB_HOST before running the script. (example: export GITLAB_HOST=registry.example.com"}
#: ${MAIL_USERNAME:?"Set the environment variable MAIL_USERNAME before running the script. (example: export MAIL_USERNAME=user@example.com"}
#: ${MAIL_PASSWORD:?"Set the environment variable MAIL_PASSWORD before running the script. (example: export MAIL_PASSWORD=my-mail-password"}

DOMAIN=$GITLAB_HOST
HEADER="Docker gitlab -"

echo "$HEADER in process..."

# Getting the docker-compose file

FILE="docker-compose.yml"
if [ -f "$FILE" ]
then
    echo "$HEADER docker-compose file was already downloaded."
else
    echo "$HEADER getting docker-compose file."
    wget https://raw.githubusercontent.com/beyond-coding/docker-gitlab/master/docker-compose.yml
    wget https://raw.githubusercontent.com/beyond-coding/docker-gitlab/master/docker-gitlab-runner.sh
    chmod 777 docker-gitlab-runner.sh
fi

# Running services

#echo "$HEADER running services"

# docker-compose up -d

#echo "$HEADER you can find GitLab at $DOMAIN:10080"
echo "$HEADER complete."


