#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset
set -x

disk="${1:-/dev/xvdh}"
partition="${disk}1"

if [[ ! -b "$partition" ]]; then
  # write the partition table with a single partition taking the full disk
  parted --script --align optimal "$disk" -- mklabel gpt mkpart primary ext4 1M -1M name 1 data

  # sync the disk, just in case
  sync

  # format the partition
  mkfs -t ext4 "$partition"
fi

# mount the partition at boot
echo "$partition   /data        ext4   defaults,discard        0 1" >> /etc/fstab

# mount the partition now
mkdir /data
mount "$partition" /data
