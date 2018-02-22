#!/bin/bash
shopt -s extglob

docker build -t unixelias/docker-dspace:${TRAVIS_BRANCH} \
    --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
    --build-arg VCS_BRANCH=${TRAVIS_BRANCH} \
    --build-arg VCS_REF=`git rev-parse --short HEAD` \
    --build-arg DSPACE_VERSION=`git ls-remote --tags https://github.com/DSpace/DSpace.git | awk '{print $2}' | grep -v '{}' | egrep -e "dspace-?.?" | grep -v 'parent' | grep -v 'imscp' | awk -F"/" '{print $3}' | sort -V -t. -k1,1 -k2,2 -k3,3 | tail -n 1 | cut -d'-' -f 2`\
    --build-arg TOMCAT_MAJOR=`svn list http://svn.apache.org/repos/asf/tomcat/tags | sort -V -t. -k1,1 -k2,2 -k3,3 | tail -n 1 | cut -d '_' --fields=2` \
    --build-arg TOMCAT_VERSION=`svn list http://svn.apache.org/repos/asf/tomcat/tags | sort -V -t. -k1,1 -k2,2 -k3,3 | tail -n 1 | cut -d '_' --fields=2,3,4 | cut -d'/' -f 1 | tr -t '_' '.'` \
    --build-arg MAVEN_MAJOR=`git ls-remote --tags https://github.com/apache/maven.git | awk '{print $2}' | grep -v '{}' | grep -v 'workspace' | awk -F"/" '{print $3}' | sort -V -t. -k1,1 -k2,2 -k3,3 | tail -n 1 | cut -d'.' -f 1 | cut -d'-' -f2` \
    --build-arg MAVEN_VERSION=`git ls-remote --tags https://github.com/apache/maven.git | awk '{print $2}' | grep -v '{}' | grep -v 'workspace' | awk -F"/" '{print $3}' | sort -V -t. -k1,1 -k2,2 -k3,3 | tail -n 1 | cut -d'-' -f2` \
    docker;                   

docker push unixelias/docker-dspace:${TRAVIS_BRANCH};

