#!/bin/bash
shopt -s extglob

for i in $( ls docker); do
  case "$i" in
       *-test )  ;;
       * ) docker build -t unixelias/docker-dspace:$i docker/$i && docker push unixelias/docker-dspace:$i ;;
  esac
done


#Exclusivo para DEV version
#docker build -t unixelias/docker-dspace:dev docker/dev && docker push unixelias/docker-dspace:dev
