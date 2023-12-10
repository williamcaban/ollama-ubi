#!/bin/bash

OLLAMA_VERSION=$(cat VERSION)

podman push homelab-quay-quay.apps.openshift1.avivgts.com/avivgt/ollama:latest
podman push homelab-quay-quay.apps.openshift1.avivgts.com/avivgt/ollama:{OLLAMA_VERSION}
