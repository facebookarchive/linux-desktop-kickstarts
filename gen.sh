#!/bin/bash

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
ksflatten -c $1 -o ${KS}
ksvalidator ${KS}
popd >/dev/null

if [[ "$1" =~ "btrfs" ]]; then
  echo Patching in btrfs configuration
  cat extrasnippets/btrfs.ks >> ${KS}
fi
