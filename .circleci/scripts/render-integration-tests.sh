#!/bin/bash

set -eo pipefail

#
# Define variables used in the poor-man's rendering engine below
#

# shellcheck disable=SC2034
PIPELINE_BUILD_ID=dev:$(jq -r .build_id ~/workspace/BUILD-INFO)

#
# Poor man's rendering engine
#

eval "echo \"$( cat .circleci/templates/vetting-config.template.yml)\"" > vetting-config.yml
