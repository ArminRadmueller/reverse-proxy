#!/bin/bash

docker login
docker build -t "arminradmueller/reverse-proxy:0.0.1" .
#docker push "arminradmueller/reverse-proxy:0.0.1"
