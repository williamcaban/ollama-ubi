#!/bin/bash

OLLAMA_VERSION=$(cat VERSION)

podman push quay.io/wcaban/ollama:latest
podman push quay.io/wcaban/ollama:${OLLAMA_VERSION}
