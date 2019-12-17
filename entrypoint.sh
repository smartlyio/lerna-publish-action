#!/bin/bash

set -euo pipefail

BUMP_VERSION=$1
REGISTRY=$2

EMAIL=${EMAIL:-"bot@lerna-publish-action"}
USERNAME=${USERNAME:-"lerna publish action bot"}

echo $AUTH_TOKEN_STRING >> ~/.npmrc

# Setup git

git config user.email "$EMAIL"
git config user.name "$USERNAME"

node_modules/.bin/lerna publish --registry=$REGISTRY --yes $BUMP_VERSION
