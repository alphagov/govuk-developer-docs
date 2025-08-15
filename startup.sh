#!/bin/bash -x

set -eu

bundle check || bundle install

yarn --version || npx yarn install -y

NO_CONTRACTS=true bundle exec middleman server
