#!/bin/bash
set -euo pipefail

Main() {
    set -x

    # Prepend BUILD-INFO contents as a single-line comment
    echo "# pipeline:build-info $(jq -c . ~/workspace/BUILD-INFO)" > orb.yml

    circleci orb pack src >> orb.yml
    circleci orb validate orb.yml

    { set +x; } >/dev/null

    head -n5 orb.yml
}


# Will not run if sourced for bats-core tests. View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    Main
fi
