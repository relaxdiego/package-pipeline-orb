#!/bin/bash

set -eo pipefail


if [ "$CIRCLE_BRANCH" = "main" ] || [ "$CIRCLE_BRANCH" = "master" ]; then
    echo "Getting get latest tag in $CIRCLE_BRANCH" 1>&2
    tag=$(git tag --list --merged "$CIRCLE_BRANCH" "v*.*.*"  | head -n1)

    if [ -n "$tag" ]; then
        echo "Found latest $tag" 1>&2

        old_build_id=()
        IFS=" " read -r -a old_build_id <<< "$(echo "$tag" | sed -E 's/v([0-9]*)\.([0-9]*)\.([0-9]*)(\+.*)?/\1 \2 \3/g')"

        major_ver="${old_build_id[0]}"
        minor_ver="${old_build_id[1]}"
        patch_ver="${old_build_id[2]}"
        search_start_point=$(git rev-list -n 1 "$tag")
    else
        major_ver=0
        minor_ver=0
        patch_ver=0
        search_start_point=$(git log --reverse --pretty=oneline | awk '{print $1}' | head -n1)
    fi

    echo "Searching for [semver:major] from $search_start_point to HEAD" 1>&2
    found_logs=$(git log --oneline --grep="\[semver:major\]" "$search_start_point" HEAD | wc -l)

    if [ "$found_logs" -gt 0 ]; then
        major_ver=$((major_ver + 1))
    else
        minor_ver=$((minor_ver + 1))
    fi

    git_short_sha=$(git rev-parse --short HEAD)
    pipeline_instance_number=$CIRCLE_BUILD_NUM

    build_id="${major_ver}.${minor_ver}.${patch_ver}+${git_short_sha}.${pipeline_instance_number}"

    echo "{\"build_id\": \"$build_id\"}"
fi
