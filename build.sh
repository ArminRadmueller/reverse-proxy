#!/bin/bash

docker login
docker build -t "arminradmueller/reverse-proxy:latest" .
docker push "arminradmueller/reverse-proxy:latest"
