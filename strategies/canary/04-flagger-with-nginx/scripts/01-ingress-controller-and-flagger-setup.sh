#!/bin/bash
printf "\n..Initialize Nginx Ingress and Flagger..\n"

namespace=$1

if [[ -z "$1" ]]; 
  then        
    read -p "Target Namespace for ingress (default is ingress-nginx) : "
    namespace=${REPLY:-"ingress-nginx"}
fi

# delete namespace if exists
printf "\n...deleting $namespace namespace if it already exists\n"
kubectl delete ns $namespace

# create namesapce
printf "\n...creating $namespace namespace\n"
kubectl create ns $namespace

# nginx Upgrade
# see: https://docs.flagger.app/tutorials/nginx-progressive-delivery
# If it fails, pick a different repo such as bitnami
helm upgrade -i nginx-ingress stable/nginx-ingress \
--namespace $namespace \
--set controller.metrics.enabled=true \
--set controller.podAnnotations."prometheus\.io/scrape"=true \
--set controller.podAnnotations."prometheus\.io/port"=10254

# Install flagger in same namespace
helm repo add flagger https://flagger.app
helm upgrade -i flagger flagger/flagger \
--namespace $namespace \
--set prometheus.install=true \
--set meshProvider=nginx

printf "\n...done...\n"