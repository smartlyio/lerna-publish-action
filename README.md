# Lerna publish action

This action publishes packages managed with Lerna to npm or other registry.

## Requirements

Requires Lerna as a dependency. Make sure it is defined in your `package.json` and installed to
`node_modules/.bin/lerna` before running this action.

## Environment variables

- `BUMP_VERSION` (**required**): Semantic version to bump. Possible values: `major|minor|patch`.
- `REGISTRY` (default: https://registry.npmjs.org): Custom registry where to publish the packages.
- `EMAIL` (default: `bot@lerna-publish-action`): Email to use in lerna commits.
- `USERNAME` (default: `lerna publish action bot`): User name to use in lerna commits.
- `LERNA_ARGUMENTS`: Extra arguments passed to lerna publish command.
- `NPM_AUTH_TOKEN`: NPM auth token when publishing to npm
- `AUTH_TOKEN_STRING`: Custom auth token that is injected to `.npmrc`. Used when connecting to custom registry that
  support ":_authToken". See [Publish to custom registry](#publish-to-custom-registry) for an example.

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
      - uses: smartlyio/lerna-publish-action@v1
        env:
          BUMP_VERSION: major
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
      - uses: smartlyio/lerna-publish-action@v1
        env:
          REGISTRY: "https://npm.fury.io/smartly"
          BUMP_VERSION: major
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
      - uses: smartlyio/lerna-publish-action@v1
        env:
          BUMP_VERSION: ${{ steps.check-version.outputs.VERSION_LOWER }}
          NPM_AUTH_TOKEN: ${{ secrets.NPM_AUTH_TOKEN }}
```
