# Lerna publish action

This action publishes packages managed with Lerna to npm or other registry.

## Requirements

Requires Lerna as a dependency. Make sure it is defined in your `package.json` and installed to
`node_modules/.bin/lerna` before running this action.

By default, `actions/checkout@v2` uses HTTP authentication that can not be used to push to protected branches. To
overcome this limitation, the action uses SSH to access the repository. The private key should be given as an
environment variable. This workaround can be removed once the limitation with protected branches is lifted.

## Input arguments

- `bump` (**required**): Semantic version to bump. Possible values: `major|minor|patch`.
- `registry` (default: https://registry.npmjs.org): Custom registry where to publish the packages.
- `email` (default: `bot@lerna-publish-action`): Email to use in lerna commits.
- `username` (default: `lerna publish action bot`): User name to use in lerna commits.
- `extra_arguments`: Extra arguments passed to lerna publish command.

## Environment variables

- `GIT_DEPLOY_KEY` (**required**): RSA private key to authentictate with the repository. See requirements.
- `AUTH_TOKEN_STRING`: Custom auth token that is injected to `.npmrc`. Used when connecting to custom registry that
  support ":_authToken". See [Publish to custom registry](#publish-to-custom-registry) for an example.
- `NPM_AUTH_TOKEN`: NPM auth token when publishing to npm

## Example usage

### Publish to NPM

```yaml
name: Lerna publish npm

on:
  push:
    branches: ['master']

jobs:
  publish:
    runs-on: ubuntu-18.04
    steps:
      - uses: actions/checkout@v2
        with:
          ref: master
      - uses: actions/setup-node@v1
        with:
          node-version: '12.x'
      - name: Install dependencies
        run: |
          yarn install
      - uses: smartlyio/lerna-publish-action@v2
        with:
          bump: major
        env:
          NPM_AUTH_TOKEN: ${{ secrets.NPM_AUTH_TOKEN }}
```

### Publish to custom registry

``` yaml
name: Lerna publish to custom registry

on:
  push:
    branches: ['master']

jobs:
  publish:
    runs-on: ubuntu-18.04
    steps:
      - uses: actions/checkout@v2
        with:
          ref: master
      - uses: actions/setup-node@v1
        with:
          node-version: '12.x'
      - name: Install dependencies
        run: |
          yarn install
      - uses: smartlyio/lerna-publish-action@v2
        with:
          bump: major
          registry: "https://npm.fury.io/smartly"
        env:
          AUTH_TOKEN_STRING: ${{ format('//npm.fury.io/:_authToken={0}', secrets.GEMFURY_TOKEN) }}
```

### Fetch bump version from label using smartlyio/version-checking-action

``` yaml
name: Lerna publish with label

on:
  pull_request:
    branches:
    - master
    types: [closed]

jobs:
  publish:
    runs-on: ubuntu-18.04
    steps:
      - uses: smartlyio/check-versioning-action@v3
        id: check-version
        with:
          enforce: true
      - uses: actions/checkout@v2
        with:
          ref: master
      - uses: actions/setup-node@v1
        with:
          node-version: '12.x'
      - name: Install dependencies
        run: |
          yarn install
      - uses: smartlyio/lerna-publish-action@v2
        with:
          bump: ${{ steps.check-version.outputs.VERSION_LOWER }}
        env:
          NPM_AUTH_TOKEN: ${{ secrets.NPM_AUTH_TOKEN }}
```
