FROM alpine:3.10

LABEL version="1.0.0"
LABEL repository="http://github.com/smartlyio/lerna-publish-action"
LABEL homepage="http://github.com/lerna-publish-action"

LABEL com.github.actions.name="Lerna publish action"
LABEL com.github.actions.description="Publish repositories using lerna"
LABEL com.github.actions.icon="package"

RUN apk add --no-cache bash

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
