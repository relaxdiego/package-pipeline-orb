Publish() {
  PIPELINE_BUILD_ID=$(jq -r .build_id BUILD-INFO)
  circleci orb publish \
    --skip-update-check \
    orb.yml \
    "${PIPELINE_PACKAGE_REPO}@${PIPELINE_BUILD_ID}" \
    --token "$CIRCLE_TOKEN"
}
