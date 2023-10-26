#!/bin/bash

if [ ! -f ~/bin/oc ]; then
	mkdir -pv ~/bin
	curl https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz | tar -xzf - -C ~/bin
fi

podman build -t quay.io/wcaban/ollama:latest -f Containerfile
#podman tag quay.io/wcaban/ollama:latest quay.io/wcaban/ollama:$(date +%y%m%d)
