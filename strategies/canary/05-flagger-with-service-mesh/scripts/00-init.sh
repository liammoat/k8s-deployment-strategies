#!/bin/bash
printf "\n..Initialize Namespace and Annotate it for linkerd..\n"

namespace=$1

if [[ -z "$1" ]]; 
  then        
    read -p "Target Namespace (default is canary-mesh) : "
    namespace=${REPLY:-"canary-mesh"}
fi

# delete namespace if exists
printf "\n...deleting $namespace namespace if it already exists\n"
kubectl delete ns $namespace

# create namesapce
printf "\n...creating $namespace namespace\n"
kubectl create ns $namespace

printf "\n...annotating $namespace for linkerd auto injection\n"
kubectl annotate namespace $namespace linkerd.io/inject=enabled