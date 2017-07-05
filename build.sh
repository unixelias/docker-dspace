#!/bin/bash
shopt -s extglob

#for i in $( ls docker); do
#  case "$i" in
#       *-test )  ;;
#       * ) docker build -t unixelias/docker-dspace:$i docker/$i ;;
#  esac
#done


#Exclusivo para DEV version
docker build -t unixelias/docker-dspace:6.0.1-alpha docker/dev && docker push unixelias/docker-dspace:6.0.1-alpha
