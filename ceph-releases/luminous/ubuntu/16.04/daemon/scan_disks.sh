#!/bin/bash

set -e

function get_all_disks_without_partitions {
  # NOTE (leseb): when not running with --privileged=true -v /dev/:/dev/
  # lsblk is not able to get device mappers path and is complaining.
  # That's why stderr is suppressed in /dev/null
  DISCOVERED_DEVICES=$(lsblk --output NAME --noheadings --raw --scsi 2>/dev/null)

  for disk in $DISCOVERED_DEVICES; do
    if [[ $(egrep -c $disk[0-9] /proc/partitions) > 0 ]]; then
      # remove disks with partitions
      DISCOVERED_DEVICES="${DISCOVERED_DEVICES/$disk/}"
    fi
  done
}

function send_disks_to_k8s {
  for disk in $DISCOVERED_DEVICES; do
    echo "sending $disk..."
  done
  echo "Here is/are the device(s) I discovered: $DISCOVERED_DEVICES"
}

get_all_disks_without_partitions
send_disks_to_k8s
