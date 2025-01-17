#!/bin/bash
set -e

USERS=($(. /etc/os-release && echo "$ID") root rootless vagrant)

sudo install -m 0755 -d /etc/apt/keyring

sudo apt-get update && \
sudo apt-get upgrade -y && \
sudo apt-get install -y \
  ca-certificates \
  curl

sudo curl \
  -fsSL https://download.docker.com/linux/$(. /etc/os-release && echo "$ID")/gpg \
  -o /etc/apt/keyring/docker.asc

sudo chmod a+r /etc/apt/keyring/docker.asc

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyring/docker.asc] \
https://download.docker.com/linux/$(. /etc/os-release && echo "$ID") \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
| sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

for USER in "${USERS[@]}"; do

  if id "$USER" &>/dev/null; then

    sudo usermod -aG docker $USER

  fi

done
