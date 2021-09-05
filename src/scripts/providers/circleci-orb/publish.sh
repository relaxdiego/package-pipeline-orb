Publish() {
  if [ -z "$CIRCLE_TOKEN" ]; then
      echo "FATAL: CIRCLE_TOKEN is not defined! To fix this error, make sure the" \
           "job is given a Circle CI context that defines the CIRCLE_TOKEN env var." \
           "See https://circleci.com/docs/2.0/contexts/ for more information."
      exit 1
  fi

  PIPELINE_BUILD_ID=$(jq -r .build_id BUILD-INFO)
  circleci orb publish \
    --skip-update-check \
    orb.yml \
    "${PIPELINE_PACKAGE_REPO}@${PIPELINE_BUILD_ID}" \
    --token "$CIRCLE_TOKEN"
}
