#!/bin/bash
shopt -s extglob

for i in $( ls docker); do
  if [ "$i" == "postgres" ]; then
    ### Build DB
    docker build -t unixelias/postgres-dspace:9.6-dev \
        --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
        --build-arg VCS_REF=`git rev-parse --short HEAD` docker/postgres \
        && docker push unixelias/postgres-dspace:9.6-dev
  else
    case "$i" in
        *-test )  ;;
        * ) docker build -t unixelias/docker-dspace:$i \
            --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
            --build-arg VCS_REF=`git rev-parse --short HEAD` docker/$i \
            && docker push unixelias/docker-dspace:$i ;;
    esac
  fi
done

## Build DB
# docker build -t unixelias/postgres-dspace:9.6-dev \
#        --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
#        --build-arg VCS_REF=`git rev-parse --short HEAD` docker/postgres \
#   && docker push unixelias/postgres-dspace:9.6-dev

## Build DSpace
#
# docker build -t unixelias/docker-dspace:5.6-dev \
#            --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
#            --build-arg VCS_REF=`git rev-parse --short HEAD` docker/5.6 \
#            && docker push unixelias/docker-dspace:5.6-dev
#

docker build -t unixelias/docker-dspace:5.x-dev \
           --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
           --build-arg VCS_REF=`git rev-parse --short HEAD` docker/dev \
           && docker push unixelias/docker-dspace:5.x-dev
