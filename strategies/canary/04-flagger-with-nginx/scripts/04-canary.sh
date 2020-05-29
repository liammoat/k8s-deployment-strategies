#!/bin/bash
printf "\n..Canary Resource deployment..\n"

resp=$1
namespace=$2

if [[ -z "$1" ]]; 
  then        
    read -p "Have you updated the canary.yaml in manifest folder to point to correct ingress-controller ip? (y/n): "
    resp=${REPLY:-"n"}
fi

if [[ $REPLY != "y" ]]
then
    echo "Please change the ingressExiting"
    exit 1
fi



if [[ -z "$2" ]]; 
  then        
    read -p "Target Namespace (default is canary-flagger) : "
    namespace=${REPLY:-"canary-flagger"}
fi

printf "\n...creating canary resource for the app\n"
kubectl apply -f ../manifests/canary.yaml -n $namespace

printf "\n...monitoring canary app...\n"
watch kubectl get canaries -n $namespace
