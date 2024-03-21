#!/bin/bash

OLLAMA_VERSION=$(curl -s "https://api.github.com/repos/ollama/ollama/releases/latest" | jq -r .name)

echo ${OLLAMA_VERSION} > VERSION

podman build --no-cache --build-arg=VERSION=${OLLAMA_VERSION} -t quay.io/afred/ollama:latest -f Containerfile.build
podman tag quay.io/afred/ollama:latest quay.io/afred/ollama:${OLLAMA_VERSION}

# Moved to upload.sh
#podman push quay.io/afred/ollama:latest
#podman push quay.io/afred/ollama:${OLLAMA_VERSION}
