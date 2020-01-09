#!/bin/bash

set -xeuo pipefail

if [ -z "$INPUT_BUMP" ]
then
    echo "bump input not specified."
    exit -1
fi

# Setup authentication for npm

if [ -n "$AUTH_TOKEN_STRING" ]
then
    echo $AUTH_TOKEN_STRING >> ~/.npmrc
fi

# Setup SSH keys so we can push lerna commits and tags to master branch

mkdir -p ~/.ssh
ssh-keyscan -t rsa github.com > ~/.ssh/known_hosts
echo "$GIT_DEPLOY_KEY" > ~/.ssh/id_rsa
chmod 400 ~/.ssh/id_rsa

# The script is run as root so we need to allow npm to execute scripts as root.
echo "unsafe-perm = true" >> ~/.npmrc

# Setup git and pull tags for Lerna

git config user.email "$INPUT_EMAIL"
git config user.name "$INPUT_USERNAME"

git remote set-url origin git@github.com:$GITHUB_REPOSITORY.git
git fetch --unshallow --tags

# Run lerna
node_modules/.bin/lerna publish $INPUT_EXTRA_ARGUMENTS --registry=$INPUT_REGISTRY --yes $INPUT_BUMP
