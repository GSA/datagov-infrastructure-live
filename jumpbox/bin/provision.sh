#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

sudo apt update

# Dependencies to run ansible
sudo apt install -y \
  build-essential \
  git \
  python-dev \
  python-virtualenv \
  zlib1g-dev
