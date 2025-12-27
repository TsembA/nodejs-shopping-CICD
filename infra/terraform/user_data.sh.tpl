#!/bin/bash
set -e

apt-get update -y
apt-get install -y docker.io docker-compose

systemctl enable docker
systemctl start docker

docker login ghcr.io -u ${GHCR_USER} -p ${GHCR_TOKEN}

docker pull ${image}

docker run -d \
  --restart always \
  -p 80:3000 \
  ${image}
