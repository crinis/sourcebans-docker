#!/usr/bin/zsh
#
# Builds Sourcebans Docker images locally until Github Actions are set up

set -e

function get_latest_release_tag() {
    SB_TAG=$(curl https://api.github.com/repos/sbpp/sourcebans-pp/releases -s | jq -r ".[].tag_name" | grep '^1\.7\.[0-9]*$' -m1)
    echo $SB_TAG
}

SB_TAG=$(get_latest_release_tag)

podman build -t crinis/sourcebans:${SB_TAG} -t crinis/sourcebans:latest --build-arg CHECKOUT="${SB_TAG}" .
podman push crinis/sourcebans:${SB_TAG}
podman push crinis/sourcebans:latest

podman build -t crinis/sourcebans:dev --build-arg CHECKOUT="php81" .
podman push crinis/sourcebans:dev
