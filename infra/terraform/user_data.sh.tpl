#!/usr/bin/env bash
set -euxo pipefail

exec > >(tee /var/log/user-data.log) 2>&1

apt-get update
apt-get install -y docker.io

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu

echo "${ghcr_token}" | docker login ghcr.io -u "${ghcr_user}" --password-stdin

docker pull ${image}

docker run -d \
  --restart unless-stopped \
  -p 80:3000 \
  ${image}
