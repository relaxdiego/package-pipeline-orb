set -eo pipefail

Main() {
    RunProvider > BUILD-INFO

    echo "BUILD-INFO rendered as:"
    cat BUILD-INFO
}


RunProvider() {
  case "$PIPELINE_VERSIONING_PROVIDER" in

    "semver2") SemVer2;;

    *)
       echo "FATAL: Unknown PIPELINE_VERSIONING_PROVIDER '$PIPELINE_VERSIONING_PROVIDER'" 1>&2
       exit 1
       ;;

  esac
}


SemVer2() {
    # TODO: Actually implement this
    echo "{ \"build_id\": \"dev:alpha\" }"
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    Main
fi
