#!/usr/bin/env bash
set -eu

for file in "$@"; do
  lint=$(vale $file >/dev/null 2>/dev/null || echo "failed")

  if [[ $lint == "failed" ]]; then
    echo "${file} has failed linting. Results:"
    vale $file
    exit 1
  fi
done
