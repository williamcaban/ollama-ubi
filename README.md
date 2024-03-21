# ollama UBI-based image for OpenShift

This repo contains the Containerfile and manifest for an [UBI-based](https://catalog.redhat.com/software/base-images) image of [ollama.ai](https://ollama.ai) and the corresponding Kubernetes manifests to run it

The images are published at `quay.io/afred/ollama:latest`. See the full list of [image tags](https://quay.io/repository/afred/ollama?tab=tags&tag=latest)


## Deploy the Pod

**Prerequisites:** Must have the NVIDIA OpenShift Operator installed and operational

- Update and apply each one of the manifests to map to your environment

```bash
manifests/
├── 01-ollama-pvc.yaml
├── 02-ollama-serve-deployment.yaml
├── 03-ollama-svc.yaml
└── 04-ollama-route.yaml
```

## Downlaod LLMs

- Once the Pod is running, login into the Pod to pull desired LLM models

```bash
# get name of pod
oc get pods
NAME                            READY   STATUS    RESTARTS   AGE
ollama-serve-6f97989fd5-tfmph   1/1     Running   0          3d5h

# connect to pod
oc exec -ti ollama-serve-6f97989fd5-tfmph -- bash
bash-5.1$ ollama pull mistral:latest
pulling manifest
pulling 6ae280299950... 100% |███████████████████████████████████████████████████████████████████████████████████████| (4.1/4.1 GB, 77 TB/s)
pulling fede2d8d6c1f... 100% |█████████████████████████████████████████████████████████████████████████████████████████| (29/29 B, 1.3 MB/s)
pulling b96850d2e482... 100% |████████████████████████████████████████████████████████████████████████████████████████| (307/307 B, 16 MB/s)
verifying sha256 digest
writing manifest
removing any unused layers
success
bash-5.1$ ollama pull falcon:7b-instruct
pulling manifest
pulling 305c4103a989... 100% |██████████████████████████████████████████████████████████████| (4.2/4.2 GB, 112 MB/s)         
pulling 4dec76bb1a47... 100% |████████████████████████████████████████████████████████████████████| (45/45 B, 28 B/s)        
pulling 0644cce03f93... 100% |████████████████████████████████████████████████████████████████████| (31/31 B, 25 B/s)        
pulling 9ce7398869ad... 100% |█████████████████████████████████████████████████████████████████| (382/382 B, 120 B/s)        
verifying sha256 digest
writing manifest
removing any unused layers
success

# once the models download you can list them like

bash-5.1$ ollama list
NAME                      	ID          	SIZE  	MODIFIED
falcon:7b-instruct        	4280f7257e73	4.2 GB	5 hours ago
llama2:13b                	b3f03629d9a6	7.4 GB	2 days ago
llama2:latest             	fe938a131f40	3.8 GB	2 days ago
mistral:7b-instruct-q5_K_M	1041946669e8	5.1 GB	2 days ago
mistral:latest            	8aa307f73b26	4.1 GB	About a minute ago
openhermes2-mistral:latest	e8aa40c72cb0	4.1 GB	2 days ago

# to test a model from within the container 
bash-5.1$ ollama run mistral:latest "What is OpenShift"
OpenShift is an open-source container application platform that allows developers to easily build, deploy and manage applications in
containers. It is based on the popular Kubernetes platform and provides a user-friendly interface for managing containerized applications at
scale. OpenShift includes features such as automatic scaling, self-healing, and built-in security, making it an ideal platform for enterprise
applications. It also supports a wide range of programming languages and frameworks, making it accessible to developers of all backgrounds.
```

## Accessing OLLAMA API

- The available models will be accesible over the `ollama` [API](https://github.com/ollama/ollama/blob/main/docs/api.md) which defaults to http://localhost:11434
    - For deployments to OpenShift using the manifests in this repo get the URL for your application by executing `oc get route ollama-route -n ollama`

```bash
# retrieving the route
oc get route ollama-route -n ollama
NAME           HOST/PORT                       PATH   SERVICES     PORT    TERMINATION   WILDCARD
ollama-route   ollama.apps.openshift.lab              ollama-svc   11434                 None

# testing the route
curl -s http://ollama.apps.openshift.lab/api/tags | jq .
{
  "models": [
    {
      "name": "falcon:7b-instruct",
      "modified_at": "2023-10-26T14:58:39.763638601Z",
      "size": 4210994570,
      "digest": "4280f7257e73108cddb43de89eb9fa28350a21aaaf997b5935719f9de0281563"
    },
    {
      "name": "llama2:13b",
      "modified_at": "2023-10-24T01:12:40.264559502Z",
      "size": 7365847104,
      "digest": "b3f03629d9a68f2660285cd86d786079c38a56a235032557ab9ba170786f0cf3"
    },
    {
      "name": "llama2:latest",
      "modified_at": "2023-10-24T01:11:14.791578247Z",
      "size": 3825819519,
      "digest": "fe938a131f40e6f6d40083c9f0f430a515233eb2edaa6d72eb85c50d64f2300e"
    },
    {
      "name": "mistral:7b-instruct-q5_K_M",
      "modified_at": "2023-10-24T01:10:09.083592659Z",
      "size": 5131409362,
      "digest": "1041946669e8163f5e8f2a505ea9199f7065eb2c3391e1b08f331005c026fd12"
    },
    {
      "name": "mistral:latest",
      "modified_at": "2023-10-26T19:55:56.073227234Z",
      "size": 4108916688,
      "digest": "8aa307f73b2622af521e8f22d46e4b777123c4df91898dcb2e4079dc8fdf579e"
    }
  ]

```

