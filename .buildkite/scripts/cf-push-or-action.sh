#!/bin/bash

# USAGE: ./cf-push-or-action.sh
# To delete the app: CF_ACTION=delete ./cf-push-or-action.sh

set -eu

: "${CF_ORGANIZATION:?required}"

[[ "${CF_SPACE_SELECTOR:-X}" == "X" ]] || {
  CF_SPACE="${!CF_SPACE_SELECTOR}"
}
: "${CF_SPACE:?required}"

[[ "${CF_ROUTE_SELECTOR:-X}" == "X" ]] || {
  CF_ROUTE="${!CF_ROUTE_SELECTOR}"
}
: "${CF_ROUTE:?required}"

echo "+ cf target -o ${CF_ORGANIZATION} -s ${CF_SPACE}"
cf target -o "${CF_ORGANIZATION}" -s "${CF_SPACE}"
echo

if [[ "${CF_ACTION:-push}" == "delete" ]]; then
  ( set -x; cf delete buildkite-cloudfoundry-demo-app -f )
else
  ( set -x; cf push --var route="${CF_ROUTE}" )
fi
