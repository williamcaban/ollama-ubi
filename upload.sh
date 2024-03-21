#!/bin/bash

OLLAMA_VERSION=$(cat VERSION)

podman push quay.io/afred/ollama:latest
podman push quay.io/afred/ollama:${OLLAMA_VERSION}
