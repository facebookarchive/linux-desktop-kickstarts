#!/bin/bash
# Copyright (c) Facebook, Inc. and its affiliates.

set -euf -o pipefail

DESTDIR=kickstart
KS=${DESTDIR}/ks.cfg

print_usage () {
  echo Usage: $0 ksfile
  exit 1
}

if [[ $# -ne 1 ]] || [[ ! -f $1 ]];
then
  print_usage
fi

pushd $(dirname $0) >/dev/null
mkdir -p ${DESTDIR}

# override kickstart version to use
VERSION_PREFIX=$(echo $(basename $1) | cut -d- -f1)
if [[ "${VERSION_PREFIX}" =~ ^f[0-9]+$ ]] || [[ "${VERSION_PREFIX}" =~ ^rhel[0-9]+$ ]];
then
  VERSION_ARG="--version ${VERSION_PREFIX}"
else
  VERSION_ARG=
fi
ksflatten ${VERSION_ARG} -c $1 -o ${KS}
ksvalidator ${VERSION_ARG} ${KS}
popd >/dev/null

ACTUAL_BASE="$(readlink -f "$1")"
if [[ "${ACTUAL_BASE}" =~ "btrfs" ]]; then
  echo Patching in btrfs configuration
  cat extrasnippets/btrfs.ks >> ${KS}
elif [[ "${ACTUAL_BASE}" =~ "lvm" ]]; then 
  echo Patching in lvm configuration
  cat extrasnippets/lvm.ks >> ${KS}
fi
