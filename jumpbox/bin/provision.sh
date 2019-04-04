#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

sudo apt update

# Dependencies to run ansible
sudo apt install -y \
  build-essential \
  python-dev \
  python-virtualenv
