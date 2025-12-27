#!/bin/bash
set -e

# Install Docker
apt-get update -y
apt-get install -y docker.io docker-compose

systemctl enable docker
systemctl start docker

# Login to GHCR
docker login ghcr.io -u ${ghcr_user} -p ${ghcr_token}

# Pull and run application
docker pull ${image}

docker run -d \
  --restart always \
  -p 80:3000 \
  ${image}
