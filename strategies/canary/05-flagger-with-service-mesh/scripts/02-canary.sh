#!/bin/bash
printf "\n..Canary Resource deployment..\n"

namespace=$1

if [[ -z "$1" ]]; 
  then        
    read -p "Target Namespace (default is canary-mesh) : "
    namespace=${REPLY:-"canary-mesh"}
fi

printf "\n...creating canary resource for the app\n"
kubectl apply -f ../manifests/canary.yaml -n $namespace
