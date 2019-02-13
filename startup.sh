#!/bin/bash -x

set -eu

bundle check || bundle install
NO_CONTRACTS=true bundle exec middleman server
