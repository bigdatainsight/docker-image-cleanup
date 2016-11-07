#!/bin/bash

# remove exited containers:
docker rm -v $(docker ps --filter status=dead --filter status=exited -aq)
    
# removing Dangling images
docker rmi $(docker images -f "dangling=true" -q)
docker images --no-trunc | grep '<none>' | awk '{ print $3 }' | xargs -r docker rmi

# remove unused volumes:
# find '/var/lib/docker/volumes/' -mindepth 1 -maxdepth 1 -type d | grep -vFf <(
#   docker ps -aq | xargs docker inspect | jq -r '.[] | .Mounts | .[] | .Name | select(.)'
# ) | xargs -r rm -fr
# To the the same thing as above with docker 1.9
docker volume ls -f dangling=true | awk '{ print $2 }' | xargs docker volume rm

# Removing old images
docker images | grep "months ago" | grep -v jboss | grep -v ecm | grep -v edb | awk '{print $3}' | xargs docker rmi
docker images | grep "weeks ago" | grep -v jboss | grep -v ecm | grep -v edb | awk '{print $3}' | xargs docker rmi

##Similarly You can remove days, months old images too.
