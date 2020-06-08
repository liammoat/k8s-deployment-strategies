#!/bin/bash
printf "\n..Canary Resource deployment..\n"

resp=$1
namespace=$2

if [[ -z "$1" ]]; 
  then        
    read -p "Have you set the correct ip-address / hostname of ingress-controller in fortio.yaml (y/n): "
    namespace=${REPLY:-"n"}
fi

if [[ $REPLY != "y" ]]
then
    echo "\n...Please configure the ip in fortio.yaml (line:23) and press y when prompted next time...\n"
    exit 1
fi

if [[ -z "$2" ]]; 
  then        
    read -p "Target Namespace (default is canary-flagger) : "
    namespace=${REPLY:-"canary-flagger"}
fi

printf "\n...setting up fortio pod\n"
kubectl apply -f ../manifests/fortio.yaml -n $namespace