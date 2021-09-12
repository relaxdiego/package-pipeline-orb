#!/bin/bash
set -euo pipefail

Main() {
    set -x

    # Prepend BUILD-INFO contents as a single-line comment
    echo "# pipeline:build-info $(jq -c . ~/workspace/BUILD-INFO)" > "$PL_ORB_TARGET_FILENAME"

    circleci orb pack "$PL_ORB_SRC_PATH" >> "$PL_ORB_TARGET_FILENAME"
    circleci orb validate "$PL_ORB_TARGET_FILENAME"

    { set +x; } >/dev/null

    head -n5 "$PL_ORB_TARGET_FILENAME"
}


# Will not run if sourced for bats-core tests. View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    Main
fi
