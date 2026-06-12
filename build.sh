#!/usr/bin/env bash
#
# Builds Sourcebans Docker images locally

set -euo pipefail

if [ "$#" -ne 1 ] || { [ "$1" != "docker" ] && [ "$1" != "podman" ]; }; then
    echo "Usage: $0 <docker|podman>" >&2
    exit 1
fi

TOOL="$1"

get_latest_release_tag() {
    curl -fsSL \
        ${GITHUB_TOKEN:+-H "Authorization: Bearer ${GITHUB_TOKEN}"} \
        -H "Accept: application/vnd.github+json" \
        'https://api.github.com/repos/sbpp/sourcebans-pp/releases?per_page=100' \
      | jq -r '[ .[] | select(.prerelease == false) | .tag_name | select(test("^1\\.8\\.[0-9]+$")) ] | first // empty'
}

SB_TAG="$(get_latest_release_tag)"
test -n "$SB_TAG" || { echo "ERROR: could not determine SourceBans release tag" >&2; exit 1; }

EXTRA_ARGS=()
if [ "$TOOL" = "podman" ]; then
    # The default OCI image format drops the HEALTHCHECK instruction.
    EXTRA_ARGS+=(--format docker)
fi

"$TOOL" build "${EXTRA_ARGS[@]}" -t "crinis/sourcebans:sb-${SB_TAG}" -t crinis/sourcebans:latest --build-arg CHECKOUT="${SB_TAG}" .
