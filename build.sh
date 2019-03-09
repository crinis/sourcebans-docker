#!/usr/bin/env bash
#
# Builds TYPO3 Docker images locally

set -e

docker build -t crinis/sourcebans:latest .
