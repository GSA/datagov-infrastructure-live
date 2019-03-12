#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

sudo apt update

sudo apt install -y \
  python3-dev \
  python-virtualenv
