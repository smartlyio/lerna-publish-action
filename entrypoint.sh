#!/bin/bash

set -euo pipefail

BUMP_VERSION=$1
AUTH_TOKEN_STRING=$2
REGISTRY=$3

echo $AUTH_TOKEN_STRING >> ~/.npmrc

ls -la

node_modules/.bin/lerna publish --registry=$REGISTRY --yes $BUMP_VERSION
