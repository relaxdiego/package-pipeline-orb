#!/bin/bash
set -euo pipefail

Main() {
    sudo npm install --no-progress --global dockerfilelint
    dockerfilelint "$(eval echo "$PL_DOCKERFILE_PATH")"
}


# Will not run if sourced for bats-core tests. View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    Main
fi
