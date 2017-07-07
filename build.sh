#!/bin/bash
shopt -s extglob

#for i in $( ls docker); do
#  case "$i" in
#       *-test )  ;;
#       * ) docker build -t unixelias/docker-dspace:$i docker/$i ;;
#  esac
#done
### Build DB

docker build -t unixelias/postgres-dspace:9.6-alpha docker/postgres && docker push unixelias/postgres-dspace:9.6-alpha

#Exclusivo para DEV version

docker build -t unixelias/docker-dspace:6.0-alpha docker/dev && docker push unixelias/docker-dspace:6.0-alpha

docker build -t unixelias/docker-dspace:6.0-alpha --add-host=postgres:127.0.0.1 docker/dev && docker push unixelias/docker-dspace:6.0-alpha;
