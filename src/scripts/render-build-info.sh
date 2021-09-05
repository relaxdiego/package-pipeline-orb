Main() {
  CheckProvider

  source "src/scripts/providers/${PIPELINE_VERSIONING_PROVIDER}/render-build-info.sh"
  RenderBuildInfo > BUILD-INFO

  echo "BUILD-INFO rendered as:"
  cat BUILD-INFO
}


CheckProvider() {
  case "$PIPELINE_VERSIONING_PROVIDER" in

    "semver2");;

    *)
       echo "FATAL: Unknown PIPELINE_VERSIONING_PROVIDER '$PIPELINE_VERSIONING_PROVIDER'"
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
