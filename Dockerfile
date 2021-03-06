FROM alpine:3.11

RUN apk add --no-cache curl bash jq

# install 'cf' into /usr/bin/cf
RUN CF_CLI_VERSION=6.49.0 && \
  curl -L "https://packages.cloudfoundry.org/stable?release=linux64-binary&version=${CF_CLI_VERSION}&source=github-rel" | tar -C /usr/bin -xvz cf

