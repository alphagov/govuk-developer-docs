#!/bin/bash -e

## Name: startup_local_auth.sh
## Description: This script attempts to start-up the fully authenticated pay-team-manual stack locally
## Since: 2021-09-14
PROXY_ARCH="darwin-amd64"
PROXY_VER="7.5.1"

# Release Paths
PROXY_BIN_SUM="oauth2-proxy-v${PROXY_VER}.${PROXY_ARCH}-sha256sum.txt"
PROXY_BIN_TAR="oauth2-proxy-v${PROXY_VER}.${PROXY_ARCH}.tar.gz"
PROXY_REL_ROOT="https://github.com/oauth2-proxy/oauth2-proxy/releases/download/v${PROXY_VER}"

if [[ -z "${OAUTH2_PROXY_CLIENT_ID}" ]]; then
  printf "The OAUTH2_PROXY_CLIENT_ID env var is not set. If you need a Client ID, you can go here:\n https://github.com/settings/developers "
  exit 1
fi

if [[ -z "${OAUTH2_PROXY_CLIENT_SECRET}" ]]; then
  printf "The OAUTH2_PROXY_CLIENT_SECRET env var is not set. If you need a Client Secret, you can go here:\n https://github.com/settings/developers "
  exit 1
fi

## Change working directory to /auth...
cd auth

function download {
    echo "Getting latest OAuth2 Proxy Tar from Github..."
    wget -q --show-progress -N "${PROXY_REL_ROOT}/${PROXY_BIN_TAR}"

    echo "Extracting OAuth2 Proxy Binary from Tar..."
    tar -zxvf ${PROXY_BIN_TAR} --strip=1

    rm "${PROXY_BIN_TAR}"
}

echo "Getting latest OAuth2 Proxy Checksum from Github..."
wget -q --show-progress -N "${PROXY_REL_ROOT}/${PROXY_BIN_SUM}"

if test -f "oauth2-proxy"; then
    echo "oauth2-proxy already exists. Checking if it matches the checksum..."
    EXISTING_SUM=$(sha256sum oauth2-proxy | cut -d " " -f 1)
    REMOTE_SUM=$(cat $PROXY_BIN_SUM | cut -d " " -f 1)

    if [[ "$EXISTING_SUM" == "$REMOTE_SUM" ]]; then
        echo "Binary is already up to date."
    else
        echo "Binary checksum failed. Downloading new version..."
        download
    fi
else
    echo "Oauth2 Proxy not found. Downloading..."
    download
fi

cd ..

bundle check || bundle install

# # Launch Middleman to host the Manual, fork it, then store the PID...
# echo "Starting Middleman Server..."
# NO_CONTRACTS=true bundle exec middleman server -d &> middleman.log &

# # Trap Ctrl+C and terminate Middleman and the OAuth2 Proxy...
# trap onexit INT
# function onexit() {
#     echo "Terminating Middleman Server..."
#     lsof -t -i tcp:4567 | xargs kill -9
# }

# Launch OAuth2 Proxy (with Localhost Config)...
echo "Starting OAuth Proxy Server..."
auth/oauth2-proxy --config=./auth/oauth2-proxy-localhost.cfg
