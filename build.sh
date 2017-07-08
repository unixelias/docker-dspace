#!/bin/bash
shopt -s extglob

for i in $( ls docker); do
  if [ "$i" == "postgres" ]; then
    ### Build DB
    docker build -t unixelias/postgres-dspace:9.6-dev \
        --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
        --build-arg VCS_REF=`git rev-parse --short HEAD` \
        --build-arg VERSION="9.6-dev" docker/postgres \
        && docker push unixelias/postgres-dspace:9.6-dev
  else
    case "$i" in
        *-test )  ;;
        * ) if [ "$i" == "dev" ]; then
              i="6.0-dev"
            fi
            docker build -t unixelias/docker-dspace:$i \
            --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
            --build-arg VCS_REF=`git rev-parse --short HEAD` \
            --build-arg VERSION="$i" docker/$i \
            && docker push unixelias/docker-dspace:$i ;;
    esac
  fi
done

### Build DB
#docker build -t unixelias/postgres-dspace:9.6-dev \
#        --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
#        --build-arg VCS_REF=`git rev-parse --short HEAD` \
#        --build-arg VERSION='9.6-dev' docker/postgres \
#   && docker push unixelias/postgres-dspace:9.6-dev

### Build DSpace

#docker build -t unixelias/docker-dspace:6.0-dev \
#            --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
#            --build-arg VCS_REF=`git rev-parse --short HEAD` \
#            --build-arg VERSION="6.0-dev" docker/dev \
#   && docker push unixelias/docker-dspace:6.0-dev
