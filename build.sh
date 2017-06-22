#!/bin/bash
shopt -s extglob

#for i in $( ls docker); do
#  case "$i" in
#       *-test )  ;;
#       * ) docker build -t unixelias/docker-dspace:$i docker/$i ;;
#  esac
#done


#Exclusivo para DEV version
docker build -t unixelias/docker-dspace:5.6-tc9 docker/dev && docker push unixelias/docker-dspace:5.6-tc9
