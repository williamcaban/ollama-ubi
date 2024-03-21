#FROM docker.io/nvidia/cuda:12.2.2-runtime-ubi9
FROM docker.io/nvidia/cuda:12.3.2-devel-ubi9

LABEL maintainer=afred@redhat.com \
      io.k8s.display-name="Ollama AI" \
      summary="ollama.ai - tool for running LLMs locally"

RUN dnf -y update \
    && dnf install -y --nodocs pciutils \
    && dnf clean all && rm -rf /var/cache/*


ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1


USER root
# Note: Raw model data is stored under /usr/share/ollama/.ollama/models
WORKDIR /usr/share/ollama

RUN curl https://ollama.ai/install.sh | sh

EXPOSE 11434
ENV OLLAMA_HOST 0.0.0.0
#ENV OLLAMA_ORIGINS  http://localhost:*,http://0.0.0.0:*
ENV OLLAMA_MODELS /.ollama/models

ENTRYPOINT ["/usr/local/bin/ollama"]
CMD ["serve"]
