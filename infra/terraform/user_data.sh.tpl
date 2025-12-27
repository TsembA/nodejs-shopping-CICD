#!/bin/bash
set -e

apt-get update -y
apt-get install -y docker.io

systemctl enable docker
systemctl start docker

docker login ghcr.io -u ${ghcr_user} -p ${ghcr_token}

docker pull ${image}

docker run -d \
  --restart always \
  -p 80:3000 \
  ${image}
