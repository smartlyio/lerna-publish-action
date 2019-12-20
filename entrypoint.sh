#!/bin/bash

set -euo pipefail

if [ -z "$INPUT_BUMP" ]
then
    echo "bump input not specified."
    exit -1
fi

if [ -n "$AUTH_TOKEN_STRING" ]
then
    echo $AUTH_TOKEN_STRING >> ~/.npmrc
fi

# The script is run as root so we need to allow npm to execute scripts as root.
echo "unsafe-perm = true" >> ~/.npmrc

# Setup git

git config user.email "$INPUT_EMAIL"
git config user.name "$INPUT_USERNAME"

node_modules/.bin/lerna publish $INPUT_EXTRA_ARGUMENTS --registry=$INPUT_REGISTRY --yes $INPUT_BUMP
