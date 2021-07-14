#!/bin/bash
# Copyright (c) Facebook, Inc. and its affiliates.

set -euf -o pipefail

pushd $(dirname $0) >/dev/null
for ks in $(find . -maxdepth 1 -name '*.ks' -type l);
do
  echo Checking ${ks}
  ./gen.sh ${ks}
done
popd >/dev/null

