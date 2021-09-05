set -euo pipefail

Main() {
  CheckEnvVars

  source "src/scripts/providers/${PIPELINE_PACKAGE_REPO_PROVIDER}/publish.sh"
  Publish
}


CheckEnvVars() {
  if [ -z "$PIPELINE_PACKAGE_REPO" ]; then
    echo "FATAL: PIPELINE_PACKAGE_REPO is undefined"
    exit 1
  fi

  case "$PIPELINE_PACKAGE_REPO_PROVIDER" in

    "circleci-orb");;

    *)
      echo "FATAL: Unknown PIPELINE_PACKAGE_REPO_PROVIDER '$PIPELINE_PACKAGE_REPO_PROVIDER'"
      exit 1
      ;;

  esac
}


# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    Main
fi
