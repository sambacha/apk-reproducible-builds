#!/bin/bash
VERSION=$(git log -1 --pretty=%h)
RELEASE="nightly"
BUILD_TIMESTAMP=$( date '+%F_%H:%M:%S' )
#docker build -t "$TAG" -t "$LATEST" --build-arg VERSION="$VERSION" --build-arg BUILD_TIMESTAMP="$BUILD_TIMESTAMP" .
DOCKER_BUILDKIT=1 docker buildx build . -t manifoldfinance/apk-buildshell