#!/bin/bash

set -xeuo pipefail

BUMP_VERSION=$1
AUTH_TOKEN_STRING=$2
REGISTRY=$3

EMAIL=${EMAIL:-"bot@lerna-publish-action"}
USERNAME=${USERNAME:-"lerna publish action bot"}

echo $AUTH_TOKEN_STRING >> ~/.npmrc

# Setup git

git config user.email "$EMAIL"
git config user.name "$USERNAME"

node_modules/.bin/lerna publish --registry=$REGISTRY --yes $BUMP_VERSION
