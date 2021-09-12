#!/bin/bash

set -euo pipefail

Main() {
    case "$PL_PACKAGE_REPO_PROVIDER" in

        "circleci-orb") PublishCircleCIOrb;;

        *)
            echo "FATAL: Unknown PL_PACKAGE_REPO_PROVIDER '$PL_PACKAGE_REPO_PROVIDER'" 1>&2
            exit 1
            ;;

    esac
}


#
# PROVIDERS
#

PublishCircleCIOrb() {
  if [ -z "$CIRCLE_TOKEN" ]; then
      echo "FATAL: CIRCLE_TOKEN is not defined! To fix this error, make sure the" \
           "job is given a Circle CI context that defines the CIRCLE_TOKEN env var." \
           "See https://circleci.com/docs/2.0/contexts/ for more information." 1>&2
      exit 1
  fi

  set -x

  PL_BUILD_INFO_PATH=${PL_BUILD_INFO_PATH:-"BUILD-INFO"}

  # The "eval echo" bit ensures that the path in the string is expanded.
  # NOTE that strings aren't normally expanded as per the POSIX standard
  PL_ORB_BUILD_ID=$(jq -r .build_id "$(eval echo "$PL_BUILD_INFO_PATH")")
  PL_ORB_PATH=${PL_ORB_PATH:="orb.yml"}

  if [ -n "$PL_ORB_IS_PRERELEASE" ]; then
      PL_ORB_VERSION_PREFIX="dev:"
  else
      PL_ORB_VERSION_PREFIX=""
  fi

  # The "eval echo" bit ensures that the path in the string is expanded
  # NOTE that strings aren't normally expanded as per the POSIX standard
  circleci orb publish \
    --skip-update-check \
    "$(eval echo "$PL_ORB_PATH")" \
    "${PL_PACKAGE_REPO}@${PL_ORB_VERSION_PREFIX}${PL_ORB_BUILD_ID}" \
    --token "$CIRCLE_TOKEN"

  { set +x; } 2>/dev/null
}


# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    Main
fi
