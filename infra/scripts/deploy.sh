#!/usr/bin/env bash
set -e

IMAGE="$1"

docker pull "$IMAGE"
docker stop nodejs-shopping || true
docker rm nodejs-shopping || true
docker run -d \
  --restart unless-stopped \
  --name nodejs-shopping \
  -p 80:3000 \
  "$IMAGE"
