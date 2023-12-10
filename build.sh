#!/bin/bash

OLLAMA_VERSION=$(curl -s "https://api.github.com/repos/jmorganca/ollama/releases/latest" | jq -r .name)

echo ${OLLAMA_VERSION} > VERSION

podman build --no-cache --build-arg=VERSION=${OLLAMA_VERSION} -t homelab-quay-quay.apps.openshift1.avivgts.com/avivgt/ollama:latest -f Containerfile.build
podman tag homelab-quay-quay.apps.openshift1.avivgts.com/avivgt/ollama:latest homelab-quay-quay.apps.openshift1.avivgts.com/avivgt/ollama:${OLLAMA_VERSION}

#podman push homelab-quay-quay.apps.openshift1.avivgts.com/avivgt/ollama:latest
#podman push homelab-quay-quay.apps.openshift1.avivgts.com/avivgt/ollama:{OLLAMA_VERSION}
