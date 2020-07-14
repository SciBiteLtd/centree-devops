#!/bin/bash
kubectl create secret generic regcred2 \
    --from-file=.dockerconfigjson=config.json \
    --type=kubernetes.io/dockerconfigjson
