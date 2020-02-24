#!/bin/bash

set -eu

CF_ORGANIZATION=${CF_ORGANIZATION:-$(buildkite-agent meta-data get cf-organization)}
CF_SPACE=${CF_SPACE:-$(buildkite-agent meta-data get cf-space)}

: ${CF_API:?required}
: ${CF_USERNAME:?required}
: ${CF_PASSWORD:?required}

CF_CLI_VERSION=${CF_CLI_VERSION:-6.49.0}

mkdir -p bin
export PATH=$PWD/bin:$PATH

[[ -x "$(command -v cf)" ]] || {
( set -x
  # FIXME - hard-coded $os
  os=linux64
  url="https://packages.cloudfoundry.org/stable?release=${os}-binary&version=${CF_CLI_VERSION}&source=github-rel"
  curl -L "$url" | tar -C bin -xvz cf
  chmod +x bin/cf
)
}

( set -x; cf version )

echo cf api "${CF_API}" ${CF_SKIP_SSL_VALIDATION:=--skip-ssl-validation}
cf api "${CF_API}" ${CF_SKIP_SSL_VALIDATION:=--skip-ssl-validation}

echo cf login "${CF_USERNAME}" [redacted]
cf login "${CF_USERNAME}" "${CF_PASSWORD}"

echo cf target -o "${CF_ORGANIZATION}" -s "${CF_SPACE}"
cf target -o "${CF_ORGANIZATION}" -s "${CF_SPACE}"