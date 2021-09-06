set -euo pipefail

BUILD_ID=$(jq -r .build_id ~/workspace/BUILD-INFO)
echo $BUILD_ID

cat > pipelineparams.json <<EOF
{
    "branch": "$CIRCLE_BRANCH",
    "parameters": {
        "vet-the-deb-build": true,
        "orb-dev-build-id": "dev:${BUILD_ID}"
    }
}
EOF
curl -u "$CIRCLE_TOKEN": \
     -X POST \
     --header "Content-Type: application/json" \
     -d @pipelineparams.json \
     "https://circleci.com/api/v2/project/gh/${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}/pipeline"
