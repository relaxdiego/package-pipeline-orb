set -euo pipefail

Main() {
  CheckPackageType

  source "src/scripts/providers/${PIPELINE_PACKAGE_TYPE}/build-and-test.sh"
  BuildAndTest
}


CheckPackageType() {
  case "$PIPELINE_PACKAGE_TYPE" in

    "circleci-orb");;

    *)
      echo "FATAL: Unknown PIPELINE_PACKAGE_TYPE '$PIPELINE_PACKAGE_TYPE'"
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
