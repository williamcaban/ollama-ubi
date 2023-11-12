#!/bin/bash

OLLAMA_VERSION=$(curl -s "https://api.github.com/repos/jmorganca/ollama/releases/latest" | jq -r .name)

echo ${OLLAMA_VERSION} > VERSION

podman build --no-cache -t quay.io/wcaban/ollama:latest -f Containerfile
podman tag quay.io/wcaban/ollama:latest quay.io/wcaban/ollama:${OLLAMA_VERSION}

#podman push quay.io/wcaban/ollama:latest
#podman push quay.io/wcaban/ollama:${OLLAMA_VERSION}
