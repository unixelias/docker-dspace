#!/bin/bash
shopt -s extglob

for i in $( ls docker); do
  case "$i" in
       *-test )  ;;
       * ) docker build -t unixelias/dspace-ufvjm:$i docker/$i ;;
  esac
done


#Exclusivo para DEV version
#docker build -t unixelias/dspace-ufvjm:dev docker/dev
