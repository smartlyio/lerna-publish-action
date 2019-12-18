#!/bin/bash

set -xeuo pipefail

REGISTRY=${REGISTRY:-"https://registry.npmjs.org"}
EMAIL=${EMAIL:-"bot@lerna-publish-action"}
USERNAME=${USERNAME:-"lerna publish action bot"}
LERNA_ARGUMENTS=${LERNA_ARGUMENTS:-""}

if [ -z "$BUMP_VERSION" ]
then
    echo "BUMP_VERSION environment variable not specified."
    exit -1
fi

if [ -n "$AUTH_TOKEN_STRING" ]
then
    echo $AUTH_TOKEN_STRING >> ~/.npmrc
fi

# The script is run as root so we need to allow npm to execute scripts as root.
echo "unsafe-perm = true" >> ~/.npmrc

# Setup git

git config user.email "$EMAIL"
git config user.name "$USERNAME"

node_modules/.bin/lerna publish $LERNA_ARGUMENTS --registry=$REGISTRY --yes $BUMP_VERSION
