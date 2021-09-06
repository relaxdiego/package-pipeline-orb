set -eo pipefail

Main() {
  RunProvider
}


RunProvider() {
  case "$PIPELINE_PACKAGE_TYPE" in

    "circleci-orb") CircleCIOrb;;

    *)
      echo "FATAL: Unknown PIPELINE_PACKAGE_TYPE '$PIPELINE_PACKAGE_TYPE'" 1>&2
      exit 1
    ;;

  esac
}


# The job that requires this provider must use the circle-cli executor
CircleCIOrb() {
    echo "Packing orb to orb.yml"
    circleci orb pack src > orb.yml

    echo "Validating orb"
    circleci orb validate orb.yml

    echo "BuildAndTestCircleCIOrb completed"
}


# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    Main
fi
