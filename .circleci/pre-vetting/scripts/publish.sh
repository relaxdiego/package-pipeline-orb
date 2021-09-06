set -eo pipefail

if [ -z "$CIRCLE_TOKEN" ]; then
    echo "FATAL: CIRCLE_TOKEN is not defined! To fix this error, make sure the" \
         "job is given a Circle CI context that defines the CIRCLE_TOKEN env var." \
         "See https://circleci.com/docs/2.0/contexts/ for more information." 1>&2
    exit 1
fi

PIPELINE_BUILD_ID=$(jq -r .build_id ~/workspace/BUILD-INFO)

set -x
circleci orb publish \
  --skip-update-check \
  ~/workspace/orb.yml \
  "${PIPELINE_PACKAGE_REPO}@dev:${PIPELINE_BUILD_ID}" \
  --token "$CIRCLE_TOKEN"
