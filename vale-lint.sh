#!/usr/bin/env bash
set -u

set +e
ret=0
for file in "$@"; do
  if ! vale $file; then
    echo "${file} has failed linting. See above"
    ret=1
  fi
done

exit $ret
