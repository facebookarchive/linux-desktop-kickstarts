#!/bin/bash

DESTDIR=iso

print_usage () {
  echo Usage: $0 isofile volume-id
  exit 1
}

if [[ $# -lt 2 ]] || [[ ! -f $1 ]];
then
  print_usage
fi

VOLID=$2
ISO="${DESTDIR}/${VOLID}-$(date +%Y%m%d-%s).iso"
pushd $(dirname $0) >/dev/null
mkdir -p ${DESTDIR}

# TODO: use lorax's mkksiso once https://github.com/weldr/lorax/pull/1047
# is merged and in a stable release
sudo ./mkksiso -V "${VOLID}" kickstart/ks.cfg ${1} ${ISO}
popd >/dev/null

