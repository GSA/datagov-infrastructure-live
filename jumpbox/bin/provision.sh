#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

apt update
apt full-upgrade

apt install -y \
  python3-dev \
  python-virtualenv
