#!/bin/bash
set -euo pipefail

Main() {
    local dockerfile_path
    dockerfile_path="$(eval echo "$PL_DOCKERFILE_PATH")"

    set -x

    sudo npm install --no-progress --global dockerfilelint
    test -f "$dockerfile_path"
    dockerfilelint "$dockerfile_path"

    { set +x; } >/dev/null
}


# Will not run if sourced for bats-core tests. View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    Main
fi
