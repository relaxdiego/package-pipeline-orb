#!/bin/bash
set -euo pipefail

Main() {
    PL_BUILD_INFO_PATH=${PL_BUILD_INFO_PATH:-"BUILD-INFO"}
    # The "eval echo" bit ensures that the path in the string is expanded.
    # NOTE that strings aren't normally expanded as per the POSIX standard
    PL_TAG=$(jq -r .build_id "$(eval echo "$PL_BUILD_INFO_PATH")")

    sudo npm install --no-progress --global dockerfilelint
    dockerfilelint "$(eval echo "$PL_DOCKERFILE_PATH")"
    docker build -t "$PL_DOCKER_IMAGE_NAME:$PL_TAG" "$(eval dirname "$PL_DOCKERFILE_PATH")"
}


# Will not run if sourced for bats-core tests. View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    Main
fi
