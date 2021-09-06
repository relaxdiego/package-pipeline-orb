set -eo pipefail

Main() {
  CheckEnvVars
  RunProvider
}


CheckEnvVars() {
  if [ -z "$PIPELINE_PACKAGE_REPO" ]; then
    echo "FATAL: PIPELINE_PACKAGE_REPO is undefined"
    exit 1
  fi
}


RunProvider() {
    case "$PIPELINE_PACKAGE_REPO_PROVIDER" in

        "circleci-orb") CircleCIOrb;;

        *)
            echo "FATAL: Unknown PIPELINE_PACKAGE_REPO_PROVIDER '$PIPELINE_PACKAGE_REPO_PROVIDER'" 1>&2
            exit 1
            ;;

    esac
}


CircleCIOrb() {
  if [ -z "$CIRCLE_TOKEN" ]; then
      echo "FATAL: CIRCLE_TOKEN is not defined! To fix this error, make sure the" \
           "job is given a Circle CI context that defines the CIRCLE_TOKEN env var." \
           "See https://circleci.com/docs/2.0/contexts/ for more information." 1>&2
      exit 1
  fi

  PIPELINE_BUILD_ID=$(jq -r .build_id BUILD-INFO)
  circleci orb publish \
    --skip-update-check \
    orb.yml \
    "${PIPELINE_PACKAGE_REPO}@${PIPELINE_BUILD_ID}" \
    --token "$CIRCLE_TOKEN"
}


# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    Main
fi
