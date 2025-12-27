#!/bin/bash
set -eux

apt-get update -y
apt-get install -y docker.io
systemctl enable docker
systemctl start docker