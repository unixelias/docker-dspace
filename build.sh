#!/bin/bash
shopt -s extglob

last=""

for i in $( ls docker); do
  case "$i" in
      *-test|dev )  ;;
      * ) docker build -t unixelias/docker-dspace:$i \
          --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
          --build-arg VCS_REF=`git rev-parse --short HEAD` docker/$i \
          && docker push unixelias/docker-dspace:$i \
          && last=$i ;;
  esac
done
docker tag unixelias/docker-dspace:$last unixelias/docker-dspace:latest && docker push unixelias/docker-dspace:latest
