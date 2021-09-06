set -eo pipefail

PIPELINE_BUILD_ID=dev:$(jq -r .build_id ~/workspace/BUILD-INFO)

# Poor man's rendering engine
eval "echo \"$( cat .circleci/pre-vetting/templates/vetting-config.template.yml)\"" > vetting-config.yml
