set -eo pipefail

PIPELINE_BUILD_ID=$(jq -r .build_id ~/workspace/BUILD-INFO)

envsubst < .circleci/pre-vetting/templates/vetting-config.template.yml > vetting-config.yml
