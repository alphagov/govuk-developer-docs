#!/bin/bash -x

set -eu

export SKIP_PROXY_PAGES=true

"$(dirname "${BASH_SOURCE[0]}")"/startup.sh
