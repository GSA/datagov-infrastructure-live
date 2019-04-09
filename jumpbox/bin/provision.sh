#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

sudo apt update

# Dependencies to run ansible
sudo apt install -y \
  build-essential \
  curl \
  git \
  libbz2-dev \
  libffi-dev \
  liblzma-dev \
  libncurses5-dev \
  libreadline-dev \
  libsqlite3-dev \
  libssl-dev \
  libxml2-dev \
  libxmlsec1-dev \
  llvm \
  python3-pip \
  python-dev \
  python-virtualenv \
  tk-dev \
  wget \
  xz-utils \
  zlib1g-dev
