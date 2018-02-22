#!/bin/bash

echo Dockerfile: $(git branch | grep \* | cut -d ' ' -f2) ;
docker run -it --rm --privileged -v `pwd`:/root/ projectatomic/dockerfile-lint dockerfile_lint -f /root/docker/Dockerfile -r lint/default_rules.yaml ;

